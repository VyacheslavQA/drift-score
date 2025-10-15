import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/local/competition_local.dart';
import '../models/local/team_local.dart';
import '../models/local/weighing_local.dart';
import '../models/local/weighing_result_local.dart';
import '../models/local/result_local.dart';
import '../models/local/operation_queue.dart';
import '../models/local/protocol_local.dart';
import '../models/local/casting_session_local.dart';
import '../models/local/casting_result_local.dart';

class IsarService {
  static Isar? _isar;

  /// Получить инстанс Isar (singleton)
  static Future<Isar> getInstance() async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }

    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [
        CompetitionLocalSchema,
        TeamLocalSchema,
        WeighingLocalSchema,
        WeighingResultLocalSchema,
        ResultLocalSchema,
        OperationQueueSchema,
        ProtocolLocalSchema,
        CastingSessionLocalSchema,
        CastingResultLocalSchema,
      ],
      directory: dir.path,
      name: 'drift_score',
    );

    return _isar!;
  }

  /// Закрыть Isar (при необходимости)
  static Future<void> close() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
      _isar = null;
    }
  }

  // ========== CompetitionLocal ==========

  Future<int> saveCompetition(CompetitionLocal competition) async {
    final isar = await getInstance();
    return await isar.writeTxn(() async {
      return await isar.competitionLocals.put(competition);
    });
  }

  Future<CompetitionLocal?> getCompetition(int id) async {
    final isar = await getInstance();
    return await isar.competitionLocals.get(id);
  }

  Future<List<CompetitionLocal>> getAllCompetitions() async {
    final isar = await getInstance();
    return await isar.competitionLocals.where().findAll();
  }

  Future<void> updateCompetition(CompetitionLocal competition) async {
    final isar = await getInstance();
    await isar.writeTxn(() async {
      await isar.competitionLocals.put(competition);
    });
  }

  Future<void> deleteCompetition(int id) async {
    final isar = await getInstance();

    await isar.writeTxn(() async {
      // 1. Получаем все взвешивания этого соревнования
      final weighings = await isar.weighingLocals
          .filter()
          .competitionLocalIdEqualTo(id)
          .findAll();

      int deletedWeighingResults = 0;

      // 2. Для каждого взвешивания удаляем его результаты
      for (var weighing in weighings) {
        final results = await isar.weighingResultLocals
            .filter()
            .weighingLocalIdEqualTo(weighing.id!)
            .findAll();

        for (var result in results) {
          await isar.weighingResultLocals.delete(result.id!);
          deletedWeighingResults++;
        }

        // Удаляем само взвешивание
        await isar.weighingLocals.delete(weighing.id!);
      }

      // 3. Удаляем кастинг-сессии и их результаты (НОВОЕ)
      final castingSessions = await isar.castingSessionLocals
          .filter()
          .competitionIdEqualTo(id)
          .findAll();

      int deletedCastingResults = 0;
      for (var session in castingSessions) {
        final results = await isar.castingResultLocals
            .filter()
            .castingSessionIdEqualTo(session.id)
            .findAll();
        for (var result in results) {
          await isar.castingResultLocals.delete(result.id);
          deletedCastingResults++;
        }
        await isar.castingSessionLocals.delete(session.id);
      }

      // 4. Удаляем все команды соревнования
      final teams = await isar.teamLocals
          .filter()
          .competitionLocalIdEqualTo(id)
          .findAll();

      for (var team in teams) {
        await isar.teamLocals.delete(team.id!);
      }

      // 5. Удаляем все протоколы соревнования
      final protocols = await isar.protocolLocals
          .filter()
          .competitionIdEqualTo(id.toString())
          .findAll();

      for (var protocol in protocols) {
        await isar.protocolLocals.delete(protocol.id);
      }

      // 6. Удаляем само соревнование
      await isar.competitionLocals.delete(id);

      print('✅ Deleted competition $id with all related data:');
      print('   - Weighings: ${weighings.length}');
      print('   - Weighing Results: $deletedWeighingResults');
      print('   - Casting Sessions: ${castingSessions.length}');
      print('   - Casting Results: $deletedCastingResults');
      print('   - Teams: ${teams.length}');
      print('   - Protocols: ${protocols.length}');
    });
  }

  // ========== TeamLocal ==========

  Future<int> saveTeam(TeamLocal team) async {
    final isar = await getInstance();
    return await isar.writeTxn(() async {
      return await isar.teamLocals.put(team);
    });
  }

  Future<TeamLocal?> getTeam(int id) async {
    final isar = await getInstance();
    return await isar.teamLocals.get(id);
  }

  Future<List<TeamLocal>> getTeamsByCompetition(int competitionId) async {
    final isar = await getInstance();
    return await isar.teamLocals
        .filter()
        .competitionLocalIdEqualTo(competitionId)
        .findAll();
  }

  Future<void> updateTeam(TeamLocal team) async {
    final isar = await getInstance();
    await isar.writeTxn(() async {
      await isar.teamLocals.put(team);
    });
  }

  Future<void> deleteTeam(int id) async {
    final isar = await getInstance();
    await isar.writeTxn(() async {
      // Удаляем все результаты этой команды
      final results = await isar.weighingResultLocals
          .filter()
          .teamLocalIdEqualTo(id)
          .findAll();

      for (var result in results) {
        await isar.weighingResultLocals.delete(result.id!);
      }

      // Удаляем саму команду
      await isar.teamLocals.delete(id);

      print('✅ Deleted team $id with ${results.length} results');
    });
  }

  // ========== WeighingLocal ==========

  Future<int> saveWeighing(WeighingLocal weighing) async {
    final isar = await getInstance();

    // Проверяем, есть ли уже взвешивание с такими параметрами
    final existing = await isar.weighingLocals
        .filter()
        .competitionLocalIdEqualTo(weighing.competitionLocalId)
        .dayNumberEqualTo(weighing.dayNumber)
        .weighingNumberEqualTo(weighing.weighingNumber)
        .findFirst();

    if (existing != null && weighing.id == null) {
      print('⚠️ Weighing already exists: Day ${weighing.dayNumber}, #${weighing.weighingNumber}, id=${existing.id}');
      return existing.id!;
    }

    return await isar.writeTxn(() async {
      final id = await isar.weighingLocals.put(weighing);
      print('✅ Saved weighing: Day ${weighing.dayNumber}, #${weighing.weighingNumber}, id=$id');
      return id;
    });
  }

  Future<WeighingLocal?> getWeighing(int id) async {
    final isar = await getInstance();
    return await isar.weighingLocals.get(id);
  }

  Future<List<WeighingLocal>> getWeighingsByCompetition(int competitionId) async {
    final isar = await getInstance();
    return await isar.weighingLocals
        .filter()
        .competitionLocalIdEqualTo(competitionId)
        .sortByWeighingTimeDesc()
        .findAll();
  }

  Future<void> updateWeighing(WeighingLocal weighing) async {
    final isar = await getInstance();
    await isar.writeTxn(() async {
      await isar.weighingLocals.put(weighing);
    });
  }

  Future<void> deleteWeighing(int id) async {
    final isar = await getInstance();
    await isar.writeTxn(() async {
      // Удаляем все результаты этого взвешивания
      final results = await isar.weighingResultLocals
          .filter()
          .weighingLocalIdEqualTo(id)
          .findAll();

      for (var result in results) {
        await isar.weighingResultLocals.delete(result.id!);
      }

      // Удаляем само взвешивание
      await isar.weighingLocals.delete(id);

      print('✅ Deleted weighing $id with ${results.length} results');
    });
  }

  /// Удалить дубликаты взвешиваний (оставляет только первое)
  Future<int> removeDuplicateWeighings(int competitionId) async {
    final isar = await getInstance();

    final allWeighings = await isar.weighingLocals
        .filter()
        .competitionLocalIdEqualTo(competitionId)
        .findAll();

    // Группируем по ключу: day_number + weighing_number
    final Map<String, List<WeighingLocal>> groups = {};

    for (var w in allWeighings) {
      final key = '${w.dayNumber}_${w.weighingNumber}';
      groups.putIfAbsent(key, () => []).add(w);
    }

    int deletedCount = 0;

    await isar.writeTxn(() async {
      for (var group in groups.values) {
        if (group.length > 1) {
          // Сортируем по ID, оставляем первое
          group.sort((a, b) => a.id!.compareTo(b.id!));

          // Удаляем все кроме первого
          for (int i = 1; i < group.length; i++) {
            // Удаляем результаты дубликата
            final results = await isar.weighingResultLocals
                .filter()
                .weighingLocalIdEqualTo(group[i].id!)
                .findAll();

            for (var result in results) {
              await isar.weighingResultLocals.delete(result.id!);
            }

            await isar.weighingLocals.delete(group[i].id!);
            deletedCount++;
            print('🗑️ Deleted duplicate weighing id=${group[i].id}');
          }
        }
      }
    });

    print('✅ Removed $deletedCount duplicate weighings');
    return deletedCount;
  }

  /// Очистить мусор в базе данных (orphaned records)
  Future<Map<String, int>> cleanOrphanedRecords() async {
    final isar = await getInstance();

    int orphanedTeams = 0;
    int orphanedWeighings = 0;
    int orphanedResults = 0;

    await isar.writeTxn(() async {
      // Получаем все ID существующих соревнований
      final competitionIds = (await isar.competitionLocals.where().findAll())
          .map((c) => c.id!)
          .toSet();

      // Удаляем команды без соревнований
      final allTeams = await isar.teamLocals.where().findAll();
      for (var team in allTeams) {
        if (!competitionIds.contains(team.competitionLocalId)) {
          await isar.teamLocals.delete(team.id!);
          orphanedTeams++;
        }
      }

      // Удаляем взвешивания без соревнований
      final allWeighings = await isar.weighingLocals.where().findAll();
      final validWeighingIds = <int>{};

      for (var weighing in allWeighings) {
        if (!competitionIds.contains(weighing.competitionLocalId)) {
          await isar.weighingLocals.delete(weighing.id!);
          orphanedWeighings++;
        } else {
          validWeighingIds.add(weighing.id!);
        }
      }

      // Удаляем результаты без взвешиваний
      final allResults = await isar.weighingResultLocals.where().findAll();
      for (var result in allResults) {
        if (!validWeighingIds.contains(result.weighingLocalId)) {
          await isar.weighingResultLocals.delete(result.id!);
          orphanedResults++;
        }
      }
    });

    print('🧹 Database cleanup completed:');
    print('   - Orphaned teams: $orphanedTeams');
    print('   - Orphaned weighings: $orphanedWeighings');
    print('   - Orphaned results: $orphanedResults');

    return {
      'teams': orphanedTeams,
      'weighings': orphanedWeighings,
      'results': orphanedResults,
    };
  }

  // ========== WeighingResultLocal ==========

  Future<int> saveWeighingResult(WeighingResultLocal result) async {
    final isar = await getInstance();
    return await isar.writeTxn(() async {
      return await isar.weighingResultLocals.put(result);
    });
  }

  Future<WeighingResultLocal?> getWeighingResult(int id) async {
    final isar = await getInstance();
    return await isar.weighingResultLocals.get(id);
  }

  Future<List<WeighingResultLocal>> getResultsByWeighing(int weighingId) async {
    final isar = await getInstance();
    return await isar.weighingResultLocals
        .filter()
        .weighingLocalIdEqualTo(weighingId)
        .findAll();
  }

  Future<WeighingResultLocal?> getResultByTeamAndWeighing(int teamId, int weighingId) async {
    final isar = await getInstance();
    return await isar.weighingResultLocals
        .filter()
        .teamLocalIdEqualTo(teamId)
        .and()
        .weighingLocalIdEqualTo(weighingId)
        .findFirst();
  }

  Future<void> updateWeighingResult(WeighingResultLocal result) async {
    final isar = await getInstance();
    await isar.writeTxn(() async {
      await isar.weighingResultLocals.put(result);
    });
  }

  Future<void> deleteWeighingResult(int id) async {
    final isar = await getInstance();
    await isar.writeTxn(() async {
      await isar.weighingResultLocals.delete(id);
    });
  }

  // ========== CastingSessionLocal ==========

  /// Сохранить сессию кастинга
  Future<int> saveCastingSession(CastingSessionLocal session) async {
    final isar = await getInstance();

    // Проверяем, есть ли уже сессия с такими параметрами
    final existing = await isar.castingSessionLocals
        .filter()
        .competitionIdEqualTo(session.competitionId)
        .dayNumberEqualTo(session.dayNumber)
        .sessionNumberEqualTo(session.sessionNumber)
        .findFirst();

    if (existing != null && session.id == Isar.autoIncrement) {
      print('⚠️ Casting session already exists: Day ${session.dayNumber}, #${session.sessionNumber}, id=${existing.id}');
      return existing.id;
    }

    return await isar.writeTxn(() async {
      final id = await isar.castingSessionLocals.put(session);
      print('✅ Saved casting session: Day ${session.dayNumber}, #${session.sessionNumber}, id=$id');
      return id;
    });
  }

  /// Получить сессию кастинга по ID
  Future<CastingSessionLocal?> getCastingSession(int id) async {
    final isar = await getInstance();
    return await isar.castingSessionLocals.get(id);
  }

  /// Получить все сессии соревнования
  Future<List<CastingSessionLocal>> getCastingSessionsByCompetition(int competitionId) async {
    final isar = await getInstance();
    return await isar.castingSessionLocals
        .filter()
        .competitionIdEqualTo(competitionId)
        .sortBySessionTimeDesc()
        .findAll();
  }

  /// Обновить сессию кастинга
  Future<void> updateCastingSession(CastingSessionLocal session) async {
    final isar = await getInstance();
    await isar.writeTxn(() async {
      await isar.castingSessionLocals.put(session);
    });
  }

  /// Удалить сессию кастинга
  Future<void> deleteCastingSession(int id) async {
    final isar = await getInstance();
    await isar.writeTxn(() async {
      // Удаляем все результаты этой сессии
      final results = await isar.castingResultLocals
          .filter()
          .castingSessionIdEqualTo(id)
          .findAll();

      for (var result in results) {
        await isar.castingResultLocals.delete(result.id);
      }

      // Удаляем саму сессию
      await isar.castingSessionLocals.delete(id);

      print('✅ Deleted casting session $id with ${results.length} results');
    });
  }

  // ========== CastingResultLocal ==========

  /// Сохранить результат участника
  Future<int> saveCastingResult(CastingResultLocal result) async {
    final isar = await getInstance();
    return await isar.writeTxn(() async {
      return await isar.castingResultLocals.put(result);
    });
  }

  /// Получить результат по ID
  Future<CastingResultLocal?> getCastingResult(int id) async {
    final isar = await getInstance();
    return await isar.castingResultLocals.get(id);
  }

  /// Получить все результаты сессии
  Future<List<CastingResultLocal>> getResultsByCastingSession(int sessionId) async {
    final isar = await getInstance();
    return await isar.castingResultLocals
        .filter()
        .castingSessionIdEqualTo(sessionId)
        .sortByBestDistanceDesc()
        .findAll();
  }

  /// Получить результат участника в конкретной сессии
  Future<CastingResultLocal?> getResultByParticipantAndSession(
      int participantId,
      int sessionId,
      ) async {
    final isar = await getInstance();
    return await isar.castingResultLocals
        .filter()
        .participantIdEqualTo(participantId)
        .and()
        .castingSessionIdEqualTo(sessionId)
        .findFirst();
  }

  /// Обновить результат участника
  Future<void> updateCastingResult(CastingResultLocal result) async {
    final isar = await getInstance();
    await isar.writeTxn(() async {
      await isar.castingResultLocals.put(result);
    });
  }

  /// Удалить результат участника
  Future<void> deleteCastingResult(int id) async {
    final isar = await getInstance();
    await isar.writeTxn(() async {
      await isar.castingResultLocals.delete(id);
    });
  }

  /// Получить все результаты участника в соревновании
  Future<List<CastingResultLocal>> getResultsByParticipant(int participantId) async {
    final isar = await getInstance();
    return await isar.castingResultLocals
        .filter()
        .participantIdEqualTo(participantId)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// Получить топ участников соревнования по лучшей дальности
  Future<List<CastingResultLocal>> getTopParticipantsByDistance(
      int competitionId,
      {int limit = 10}
      ) async {
    final isar = await getInstance();

    // Получаем все сессии соревнования
    final sessions = await getCastingSessionsByCompetition(competitionId);
    final sessionIds = sessions.map((s) => s.id).toList();

    if (sessionIds.isEmpty) return [];

    // Получаем все результаты этих сессий
    final allResults = <CastingResultLocal>[];
    for (var sessionId in sessionIds) {
      final results = await getResultsByCastingSession(sessionId);
      allResults.addAll(results);
    }

    // Группируем по participantId и берём лучший результат
    final Map<int, CastingResultLocal> bestResults = {};
    for (var result in allResults) {
      if (!bestResults.containsKey(result.participantId) ||
          result.bestDistance > bestResults[result.participantId]!.bestDistance) {
        bestResults[result.participantId] = result;
      }
    }

    // Сортируем по дальности и возвращаем топ
    final sorted = bestResults.values.toList()
      ..sort((a, b) => b.bestDistance.compareTo(a.bestDistance));

    return sorted.take(limit).toList();
  }

  // ============================================================
  // PROTOCOL METHODS
  // ============================================================

  /// Сохранить протокол
  Future<int> saveProtocol(ProtocolLocal protocol) async {
    final isar = await getInstance();
    return await isar.writeTxn(() async {
      return await isar.protocolLocals.put(protocol);
    });
  }

  /// Получить все протоколы соревнования
  Future<List<ProtocolLocal>> getProtocolsByCompetition(int competitionId) async {
    final isar = await getInstance();
    return await isar.protocolLocals
        .filter()
        .competitionIdEqualTo(competitionId.toString())
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// Получить протоколы по типу
  Future<List<ProtocolLocal>> getProtocolsByType(
      int competitionId,
      String type,
      ) async {
    final isar = await getInstance();
    return await isar.protocolLocals
        .filter()
        .competitionIdEqualTo(competitionId.toString())
        .typeEqualTo(type)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// Получить протокол взвешивания
  Future<ProtocolLocal?> getWeighingProtocol(
      int competitionId,
      String weighingId,
      ) async {
    final isar = await getInstance();
    return await isar.protocolLocals
        .filter()
        .competitionIdEqualTo(competitionId.toString())
        .typeEqualTo('weighing')
        .weighingIdEqualTo(weighingId)
        .findFirst();
  }

  /// Получить промежуточный протокол по номеру взвешивания
  Future<ProtocolLocal?> getIntermediateProtocol(
      int competitionId,
      int weighingNumber,
      ) async {
    final isar = await getInstance();
    return await isar.protocolLocals
        .filter()
        .competitionIdEqualTo(competitionId.toString())
        .typeEqualTo('intermediate')
        .weighingNumberEqualTo(weighingNumber)
        .findFirst();
  }

  /// Получить протокол Big Fish по дню
  Future<ProtocolLocal?> getBigFishProtocol(
      int competitionId,
      int bigFishDay,
      ) async {
    final isar = await getInstance();
    return await isar.protocolLocals
        .filter()
        .competitionIdEqualTo(competitionId.toString())
        .typeEqualTo('big_fish')
        .bigFishDayEqualTo(bigFishDay)
        .findFirst();
  }

  /// Получить сводный протокол
  Future<ProtocolLocal?> getSummaryProtocol(int competitionId) async {
    final isar = await getInstance();
    return await isar.protocolLocals
        .filter()
        .competitionIdEqualTo(competitionId.toString())
        .typeEqualTo('summary')
        .sortByCreatedAtDesc()
        .findFirst();
  }

  /// Получить финальный протокол
  Future<ProtocolLocal?> getFinalProtocol(int competitionId) async {
    final isar = await getInstance();
    return await isar.protocolLocals
        .filter()
        .competitionIdEqualTo(competitionId.toString())
        .typeEqualTo('final')
        .findFirst();
  }

  /// Удалить протокол
  Future<bool> deleteProtocol(int id) async {
    final isar = await getInstance();
    return await isar.writeTxn(() async {
      return await isar.protocolLocals.delete(id);
    });
  }

  /// Удалить все протоколы соревнования
  Future<int> deleteProtocolsByCompetition(int competitionId) async {
    final isar = await getInstance();
    return await isar.writeTxn(() async {
      final protocols = await isar.protocolLocals
          .filter()
          .competitionIdEqualTo(competitionId.toString())
          .findAll();
      final ids = protocols.map((p) => p.id).toList();
      return await isar.protocolLocals.deleteAll(ids);
    });
  }
}