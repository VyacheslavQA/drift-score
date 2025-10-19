import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/remote/competition_remote.dart';
import '../models/remote/team_remote.dart';
import '../models/remote/weighing_remote.dart';
import '../models/remote/weighing_result_remote.dart';
import '../models/remote/casting_session_remote.dart';
import '../models/remote/casting_result_remote.dart';
import '../models/remote/protocol_remote.dart';

/// Сервис для работы с Firebase Firestore
///
/// Структура базы данных:
/// /competitions/{competitionId}
///   /teams/{teamId}
///   /weighings/{weighingId}
///     /results/{resultId}
///   /casting_sessions/{sessionId}
///     /results/{resultId}
///   /protocols/{protocolId}
class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========== COMPETITIONS ==========

  /// Создать соревнование
  Future<String> createCompetition(CompetitionRemote competition) async {
    try {
      final docRef = await _firestore
          .collection('competitions')
          .add(competition.toFirestore());

      print('✅ Created competition: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Error creating competition: $e');
      rethrow;
    }
  }

  /// Получить соревнование по ID
  Future<CompetitionRemote?> getCompetition(String id) async {
    try {
      final doc = await _firestore.collection('competitions').doc(id).get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return CompetitionRemote.fromFirestore(doc.data()!, doc.id);
    } catch (e) {
      print('❌ Error getting competition: $e');
      rethrow;
    }
  }

  /// Получить все соревнования
  Future<List<CompetitionRemote>> getAllCompetitions() async {
    try {
      final snapshot = await _firestore
          .collection('competitions')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => CompetitionRemote.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('❌ Error getting all competitions: $e');
      rethrow;
    }
  }

  /// Обновить соревнование
  Future<void> updateCompetition(String id, CompetitionRemote competition) async {
    try {
      await _firestore
          .collection('competitions')
          .doc(id)
          .update(competition.toFirestore());

      print('✅ Updated competition: $id');
    } catch (e) {
      print('❌ Error updating competition: $e');
      rethrow;
    }
  }

  /// Удалить соревнование (каскадное удаление)
  Future<void> deleteCompetition(String id) async {
    try {
      final batch = _firestore.batch();

      // Удаляем команды
      final teams = await _firestore
          .collection('competitions')
          .doc(id)
          .collection('teams')
          .get();
      for (var team in teams.docs) {
        batch.delete(team.reference);
      }

      // Удаляем взвешивания и их результаты
      final weighings = await _firestore
          .collection('competitions')
          .doc(id)
          .collection('weighings')
          .get();
      for (var weighing in weighings.docs) {
        final results = await weighing.reference.collection('results').get();
        for (var result in results.docs) {
          batch.delete(result.reference);
        }
        batch.delete(weighing.reference);
      }

      // Удаляем кастинг-сессии и их результаты
      final sessions = await _firestore
          .collection('competitions')
          .doc(id)
          .collection('casting_sessions')
          .get();
      for (var session in sessions.docs) {
        final results = await session.reference.collection('results').get();
        for (var result in results.docs) {
          batch.delete(result.reference);
        }
        batch.delete(session.reference);
      }

      // Удаляем протоколы
      final protocols = await _firestore
          .collection('competitions')
          .doc(id)
          .collection('protocols')
          .get();
      for (var protocol in protocols.docs) {
        batch.delete(protocol.reference);
      }

      // Удаляем само соревнование
      batch.delete(_firestore.collection('competitions').doc(id));

      await batch.commit();
      print('✅ Deleted competition: $id (with all subcollections)');
    } catch (e) {
      print('❌ Error deleting competition: $e');
      rethrow;
    }
  }

  /// Слушать изменения соревнования (real-time)
  Stream<CompetitionRemote> watchCompetition(String id) {
    return _firestore
        .collection('competitions')
        .doc(id)
        .snapshots()
        .map((doc) {
      if (!doc.exists || doc.data() == null) {
        throw Exception('Competition not found: $id');
      }
      return CompetitionRemote.fromFirestore(doc.data()!, doc.id);
    });
  }

  // ========== TEAMS ==========

  /// Создать команду
  Future<String> createTeam(String competitionId, TeamRemote team) async {
    try {
      final docRef = await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('teams')
          .add(team.toFirestore());

      print('✅ Created team: ${docRef.id} in competition: $competitionId');
      return docRef.id;
    } catch (e) {
      print('❌ Error creating team: $e');
      rethrow;
    }
  }

  /// Получить команду по ID
  Future<TeamRemote?> getTeam(String competitionId, String teamId) async {
    try {
      final doc = await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('teams')
          .doc(teamId)
          .get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return TeamRemote.fromFirestore(doc.data()!, doc.id);
    } catch (e) {
      print('❌ Error getting team: $e');
      rethrow;
    }
  }

  /// Получить все команды соревнования
  Future<List<TeamRemote>> getTeamsByCompetition(String competitionId) async {
    try {
      final snapshot = await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('teams')
          .orderBy('createdAt')
          .get();

      return snapshot.docs
          .map((doc) => TeamRemote.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('❌ Error getting teams: $e');
      rethrow;
    }
  }

  /// Обновить команду
  Future<void> updateTeam(String competitionId, String teamId, TeamRemote team) async {
    try {
      await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('teams')
          .doc(teamId)
          .update(team.toFirestore());

      print('✅ Updated team: $teamId');
    } catch (e) {
      print('❌ Error updating team: $e');
      rethrow;
    }
  }

  /// Удалить команду
  Future<void> deleteTeam(String competitionId, String teamId) async {
    try {
      await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('teams')
          .doc(teamId)
          .delete();

      print('✅ Deleted team: $teamId');
    } catch (e) {
      print('❌ Error deleting team: $e');
      rethrow;
    }
  }

  /// Слушать изменения команд (real-time)
  Stream<List<TeamRemote>> watchTeams(String competitionId) {
    return _firestore
        .collection('competitions')
        .doc(competitionId)
        .collection('teams')
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => TeamRemote.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  // ========== WEIGHINGS (для рыбалки) ==========

  /// Создать взвешивание
  Future<String> createWeighing(String competitionId, WeighingRemote weighing) async {
    try {
      final docRef = await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('weighings')
          .add(weighing.toFirestore());

      print('✅ Created weighing: ${docRef.id} in competition: $competitionId');
      return docRef.id;
    } catch (e) {
      print('❌ Error creating weighing: $e');
      rethrow;
    }
  }

  /// Получить все взвешивания соревнования
  Future<List<WeighingRemote>> getWeighingsByCompetition(String competitionId) async {
    try {
      final snapshot = await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('weighings')
          .orderBy('weighingTime', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => WeighingRemote.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('❌ Error getting weighings: $e');
      rethrow;
    }
  }

  /// Обновить взвешивание
  Future<void> updateWeighing(String competitionId, String weighingId, WeighingRemote weighing) async {
    try {
      await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('weighings')
          .doc(weighingId)
          .update(weighing.toFirestore());

      print('✅ Updated weighing: $weighingId');
    } catch (e) {
      print('❌ Error updating weighing: $e');
      rethrow;
    }
  }

  /// Удалить взвешивание (каскадное удаление результатов)
  Future<void> deleteWeighing(String competitionId, String weighingId) async {
    try {
      final batch = _firestore.batch();

      // Удаляем все результаты этого взвешивания
      final results = await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('weighings')
          .doc(weighingId)
          .collection('results')
          .get();

      for (var result in results.docs) {
        batch.delete(result.reference);
      }

      // Удаляем само взвешивание
      batch.delete(_firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('weighings')
          .doc(weighingId));

      await batch.commit();
      print('✅ Deleted weighing: $weighingId (with ${results.docs.length} results)');
    } catch (e) {
      print('❌ Error deleting weighing: $e');
      rethrow;
    }
  }

  // ========== WEIGHING RESULTS ==========

  /// Создать результат взвешивания
  Future<String> createWeighingResult(
      String competitionId,
      String weighingId,
      WeighingResultRemote result,
      ) async {
    try {
      final docRef = await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('weighings')
          .doc(weighingId)
          .collection('results')
          .add(result.toFirestore());

      print('✅ Created weighing result: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Error creating weighing result: $e');
      rethrow;
    }
  }

  /// Получить все результаты взвешивания
  Future<List<WeighingResultRemote>> getResultsByWeighing(
      String competitionId,
      String weighingId,
      ) async {
    try {
      final snapshot = await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('weighings')
          .doc(weighingId)
          .collection('results')
          .orderBy('createdAt')
          .get();

      return snapshot.docs
          .map((doc) => WeighingResultRemote.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('❌ Error getting weighing results: $e');
      rethrow;
    }
  }

  /// Обновить результат взвешивания
  Future<void> updateWeighingResult(
      String competitionId,
      String weighingId,
      String resultId,
      WeighingResultRemote result,
      ) async {
    try {
      await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('weighings')
          .doc(weighingId)
          .collection('results')
          .doc(resultId)
          .update(result.toFirestore());

      print('✅ Updated weighing result: $resultId');
    } catch (e) {
      print('❌ Error updating weighing result: $e');
      rethrow;
    }
  }

  /// Удалить результат взвешивания
  Future<void> deleteWeighingResult(
      String competitionId,
      String weighingId,
      String resultId,
      ) async {
    try {
      await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('weighings')
          .doc(weighingId)
          .collection('results')
          .doc(resultId)
          .delete();

      print('✅ Deleted weighing result: $resultId');
    } catch (e) {
      print('❌ Error deleting weighing result: $e');
      rethrow;
    }
  }

  // ========== CASTING SESSIONS (для кастинга) ==========

  /// Создать сессию кастинга
  Future<String> createCastingSession(
      String competitionId,
      CastingSessionRemote session,
      ) async {
    try {
      final docRef = await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('casting_sessions')
          .add(session.toFirestore());

      print('✅ Created casting session: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Error creating casting session: $e');
      rethrow;
    }
  }

  /// Получить все сессии кастинга соревнования
  Future<List<CastingSessionRemote>> getCastingSessionsByCompetition(
      String competitionId,
      ) async {
    try {
      final snapshot = await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('casting_sessions')
          .orderBy('sessionTime', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => CastingSessionRemote.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('❌ Error getting casting sessions: $e');
      rethrow;
    }
  }

  /// Обновить сессию кастинга
  Future<void> updateCastingSession(
      String competitionId,
      String sessionId,
      CastingSessionRemote session,
      ) async {
    try {
      await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('casting_sessions')
          .doc(sessionId)
          .update(session.toFirestore());

      print('✅ Updated casting session: $sessionId');
    } catch (e) {
      print('❌ Error updating casting session: $e');
      rethrow;
    }
  }

  /// Удалить сессию кастинга (каскадное удаление результатов)
  Future<void> deleteCastingSession(String competitionId, String sessionId) async {
    try {
      final batch = _firestore.batch();

      // Удаляем все результаты этой сессии
      final results = await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('casting_sessions')
          .doc(sessionId)
          .collection('results')
          .get();

      for (var result in results.docs) {
        batch.delete(result.reference);
      }

      // Удаляем саму сессию
      batch.delete(_firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('casting_sessions')
          .doc(sessionId));

      await batch.commit();
      print('✅ Deleted casting session: $sessionId (with ${results.docs.length} results)');
    } catch (e) {
      print('❌ Error deleting casting session: $e');
      rethrow;
    }
  }

  // ========== CASTING RESULTS ==========

  /// Создать результат участника
  Future<String> createCastingResult(
      String competitionId,
      String sessionId,
      CastingResultRemote result,
      ) async {
    try {
      final docRef = await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('casting_sessions')
          .doc(sessionId)
          .collection('results')
          .add(result.toFirestore());

      print('✅ Created casting result: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Error creating casting result: $e');
      rethrow;
    }
  }

  /// Получить все результаты сессии кастинга
  Future<List<CastingResultRemote>> getResultsByCastingSession(
      String competitionId,
      String sessionId,
      ) async {
    try {
      final snapshot = await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('casting_sessions')
          .doc(sessionId)
          .collection('results')
          .orderBy('bestDistance', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => CastingResultRemote.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('❌ Error getting casting results: $e');
      rethrow;
    }
  }

  /// Обновить результат участника
  Future<void> updateCastingResult(
      String competitionId,
      String sessionId,
      String resultId,
      CastingResultRemote result,
      ) async {
    try {
      await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('casting_sessions')
          .doc(sessionId)
          .collection('results')
          .doc(resultId)
          .update(result.toFirestore());

      print('✅ Updated casting result: $resultId');
    } catch (e) {
      print('❌ Error updating casting result: $e');
      rethrow;
    }
  }

  /// Удалить результат участника
  Future<void> deleteCastingResult(
      String competitionId,
      String sessionId,
      String resultId,
      ) async {
    try {
      await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('casting_sessions')
          .doc(sessionId)
          .collection('results')
          .doc(resultId)
          .delete();

      print('✅ Deleted casting result: $resultId');
    } catch (e) {
      print('❌ Error deleting casting result: $e');
      rethrow;
    }
  }

  // ========== PROTOCOLS ==========

  /// Создать протокол
  Future<String> createProtocol(
      String competitionId,
      ProtocolRemote protocol,
      ) async {
    try {
      final docRef = await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('protocols')
          .add(protocol.toFirestore());

      print('✅ Created protocol: ${docRef.id} (type: ${protocol.type})');
      return docRef.id;
    } catch (e) {
      print('❌ Error creating protocol: $e');
      rethrow;
    }
  }

  /// Получить все протоколы соревнования
  Future<List<ProtocolRemote>> getProtocolsByCompetition(String competitionId) async {
    try {
      final snapshot = await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('protocols')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ProtocolRemote.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('❌ Error getting protocols: $e');
      rethrow;
    }
  }

  /// Получить протоколы по типу
  Future<List<ProtocolRemote>> getProtocolsByType(
      String competitionId,
      String type,
      ) async {
    try {
      final snapshot = await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('protocols')
          .where('type', isEqualTo: type)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ProtocolRemote.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('❌ Error getting protocols by type: $e');
      rethrow;
    }
  }

  /// Удалить протокол
  Future<void> deleteProtocol(String competitionId, String protocolId) async {
    try {
      await _firestore
          .collection('competitions')
          .doc(competitionId)
          .collection('protocols')
          .doc(protocolId)
          .delete();

      print('✅ Deleted protocol: $protocolId');
    } catch (e) {
      print('❌ Error deleting protocol: $e');
      rethrow;
    }
  }
  // ========== PUBLIC VIEW: COMPETITIONS ==========

  /// Получить все публичные соревнования с real-time обновлением
  Stream<List<CompetitionRemote>> watchAllPublicCompetitions() {
    return _firestore
        .collection('competitions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CompetitionRemote.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  /// Получить публичные соревнования по типу рыбалки (real-time)
  Stream<List<CompetitionRemote>> watchCompetitionsByFishingType(String fishingType) {
    return _firestore
        .collection('competitions')
        .where('fishingType', isEqualTo: fishingType)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CompetitionRemote.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  /// Получить активные соревнования по типу рыбалки (real-time)
  Stream<List<CompetitionRemote>> watchActiveCompetitionsByFishingType(String fishingType) {
    return _firestore
        .collection('competitions')
        .where('fishingType', isEqualTo: fishingType)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CompetitionRemote.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  /// Получить завершённые соревнования по типу рыбалки (real-time)
  Stream<List<CompetitionRemote>> watchCompletedCompetitionsByFishingType(String fishingType) {
    return _firestore
        .collection('competitions')
        .where('fishingType', isEqualTo: fishingType)
        .where('isActive', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CompetitionRemote.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  /// Слушать изменения протоколов соревнования (real-time)
  Stream<List<ProtocolRemote>> watchProtocolsByCompetition(String competitionId) {
    return _firestore
        .collection('competitions')
        .doc(competitionId)
        .collection('protocols')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ProtocolRemote.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  /// Слушать протоколы определённого типа (real-time)
  Stream<List<ProtocolRemote>> watchProtocolsByType(String competitionId, String type) {
    return _firestore
        .collection('competitions')
        .doc(competitionId)
        .collection('protocols')
        .where('type', isEqualTo: type)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ProtocolRemote.fromFirestore(doc.data(), doc.id))
        .toList());
  }
}