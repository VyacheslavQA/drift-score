import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/local/competition_local.dart';
import '../models/local/team_local.dart';
import '../models/local/weighing_local.dart';
import '../models/local/weighing_result_local.dart';
import '../models/local/result_local.dart';
import '../models/local/operation_queue.dart';

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
      await isar.competitionLocals.delete(id);
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
      await isar.teamLocals.delete(id);
    });
  }

  // ========== WeighingLocal ==========

  Future<int> saveWeighing(WeighingLocal weighing) async {
    final isar = await getInstance();
    return await isar.writeTxn(() async {
      return await isar.weighingLocals.put(weighing);
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
      await isar.weighingLocals.delete(id);
    });
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
}