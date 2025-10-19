import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';
import 'isar_service.dart';
import '../models/local/competition_local.dart';
import '../models/local/team_local.dart';
import '../models/local/weighing_local.dart';
import '../models/local/weighing_result_local.dart';
import '../models/local/casting_session_local.dart';
import '../models/local/casting_result_local.dart';
import '../models/local/protocol_local.dart';
import '../models/remote/competition_remote.dart';
import '../models/remote/team_remote.dart';
import '../models/remote/weighing_remote.dart';
import '../models/remote/weighing_result_remote.dart';
import '../models/remote/casting_session_remote.dart';
import '../models/remote/casting_result_remote.dart';
import '../models/remote/protocol_remote.dart';

/// Сервис для синхронизации данных между Isar (Local) и Firestore (Remote)
class SyncService {
  final FirebaseService _firebaseService = FirebaseService();
  final IsarService _isarService = IsarService();
  final Connectivity _connectivity = Connectivity();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========== ID MAPPING ==========
  final Map<int, String> _competitionIdMap = {};
  final Map<int, String> _teamIdMap = {};
  final Map<int, String> _weighingIdMap = {};
  final Map<int, String> _weighingResultIdMap = {};
  final Map<int, String> _castingSessionIdMap = {};
  final Map<int, String> _castingResultIdMap = {};
  final Map<int, String> _protocolIdMap = {};

  void _saveIdMapping(String type, int localId, String serverId) {
    switch (type) {
      case 'competition':
        _competitionIdMap[localId] = serverId;
        break;
      case 'team':
        _teamIdMap[localId] = serverId;
        break;
      case 'weighing':
        _weighingIdMap[localId] = serverId;
        break;
      case 'weighing_result':
        _weighingResultIdMap[localId] = serverId;
        break;
      case 'casting_session':
        _castingSessionIdMap[localId] = serverId;
        break;
      case 'casting_result':
        _castingResultIdMap[localId] = serverId;
        break;
      case 'protocol':
        _protocolIdMap[localId] = serverId;
        break;
    }
    print('💾 Saved ID mapping: $type localId=$localId → serverId=$serverId');
  }

  String? _getServerId(String type, int localId) {
    switch (type) {
      case 'competition':
        return _competitionIdMap[localId];
      case 'team':
        return _teamIdMap[localId];
      case 'weighing':
        return _weighingIdMap[localId];
      case 'weighing_result':
        return _weighingResultIdMap[localId];
      case 'casting_session':
        return _castingSessionIdMap[localId];
      case 'casting_result':
        return _castingResultIdMap[localId];
      case 'protocol':
        return _protocolIdMap[localId];
      default:
        return null;
    }
  }

  int? _getLocalId(String type, String serverId) {
    Map<int, String>? map;
    switch (type) {
      case 'competition':
        map = _competitionIdMap;
        break;
      case 'team':
        map = _teamIdMap;
        break;
      case 'weighing':
        map = _weighingIdMap;
        break;
      case 'weighing_result':
        map = _weighingResultIdMap;
        break;
      case 'casting_session':
        map = _castingSessionIdMap;
        break;
      case 'casting_result':
        map = _castingResultIdMap;
        break;
      case 'protocol':
        map = _protocolIdMap;
        break;
    }

    if (map == null) return null;

    for (var entry in map.entries) {
      if (entry.value == serverId) {
        return entry.key;
      }
    }
    return null;
  }

  // ========== CONNECTIVITY CHECK ==========

  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      print('⚠️ Error checking connectivity: $e');
      return false;
    }
  }

  // ========== SYNC COMPETITIONS ==========

  /// ✅ НОВЫЙ МЕТОД: Получить соревнования по коду из Firebase
  Future<List<CompetitionLocal>> getCompetitionsByCode(String code) async {
    try {
      print('🔍 Getting competitions by code from Firebase: $code');

      if (!await hasInternetConnection()) {
        print('⚠️ No internet - cannot get competitions from Firebase');
        return [];
      }

      final snapshot = await _firestore
          .collection('competitions')
          .where('accessCode', isEqualTo: code)
          .orderBy('createdAt', descending: true)
          .get();

      print('✅ Found ${snapshot.docs.length} competition(s) in Firebase with code: $code');

      final competitions = <CompetitionLocal>[];

      for (var doc in snapshot.docs) {
        try {
          final remote = CompetitionRemote.fromFirestore(doc.data(), doc.id);
          final local = remote.toLocal(0);

          local.serverId = doc.id;
          competitions.add(local);
          print('   - ${local.name} (ServerID: ${doc.id}, Code: ${local.accessCode})');
        } catch (e) {
          print('⚠️ Error converting competition: $e');
        }
      }

      return competitions;
    } catch (e) {
      print('❌ Error getting competitions by code: $e');
      return [];
    }
  }

  /// ✅ ОБНОВЛЕНО: Синхронизировать соревнование Local → Remote (возвращает serverId)
  Future<String?> syncCompetitionToFirebase(CompetitionLocal competition) async {
    try {
      if (!await hasInternetConnection()) {
        print('⚠️ No internet - competition sync queued');
        return null;
      }

      final remote = CompetitionRemote.fromLocal(competition);

      String serverId;
      if (competition.serverId != null && competition.serverId!.isNotEmpty) {
        await _firebaseService.updateCompetition(competition.serverId!, remote);
        serverId = competition.serverId!;
        print('✅ Updated competition in Firebase: $serverId');
      } else {
        serverId = await _firebaseService.createCompetition(remote);
        print('✅ Created competition in Firebase: $serverId');

        competition.serverId = serverId;
        await _isarService.updateCompetition(competition);
      }

      _saveIdMapping('competition', competition.id, serverId);

      competition.isSynced = true;
      competition.lastSyncedAt = DateTime.now();
      await _isarService.updateCompetition(competition);

      return serverId;
    } catch (e) {
      print('❌ Error syncing competition to Firebase: $e');
      return null;
    }
  }

  Future<void> syncCompetitionFromFirebase(String serverId) async {
    try {
      final remote = await _firebaseService.getCompetition(serverId);
      if (remote == null) {
        print('⚠️ Competition not found in Firebase: $serverId');
        return;
      }

      int? localId = _getLocalId('competition', serverId);
      if (localId == null) {
        final local = remote.toLocal(0);
        localId = await _isarService.saveCompetition(local);
        print('✅ Created local competition from Firebase: localId=$localId');
      } else {
        final existingLocal = await _isarService.getCompetition(localId);
        if (existingLocal != null) {
          if (_shouldUpdateLocal(existingLocal.updatedAt, remote.updatedAt)) {
            final updatedLocal = remote.toLocal(localId);
            await _isarService.updateCompetition(updatedLocal);
            print('✅ Updated local competition from Firebase: localId=$localId');
          } else {
            print('⚠️ Local version is newer - skipping update');
          }
        }
      }

      _saveIdMapping('competition', localId, serverId);
    } catch (e) {
      print('❌ Error syncing competition from Firebase: $e');
      rethrow;
    }
  }

  Future<void> syncAllCompetitions() async {
    try {
      if (!await hasInternetConnection()) {
        print('⚠️ No internet - cannot sync competitions');
        return;
      }

      final remoteCompetitions = await _firebaseService.getAllCompetitions();
      print('📥 Syncing ${remoteCompetitions.length} competitions from Firebase...');

      for (var remote in remoteCompetitions) {
        await syncCompetitionFromFirebase(remote.id);
      }

      print('✅ Synced all competitions');
    } catch (e) {
      print('❌ Error syncing all competitions: $e');
      rethrow;
    }
  }

  // ========== SYNC TEAMS ==========

  Future<void> syncTeamToFirebase(TeamLocal team, String competitionServerId) async {
    try {
      if (!await hasInternetConnection()) {
        print('⚠️ No internet - team sync queued');
        return;
      }

      final remote = TeamRemote.fromLocal(team, competitionServerId);

      String serverId;
      if (team.serverId != null && team.serverId!.isNotEmpty) {
        await _firebaseService.updateTeam(competitionServerId, team.serverId!, remote);
        serverId = team.serverId!;
        print('✅ Updated team in Firebase: $serverId');
      } else {
        serverId = await _firebaseService.createTeam(competitionServerId, remote);
        print('✅ Created team in Firebase: $serverId');

        team.serverId = serverId;
        await _isarService.updateTeam(team);
      }

      _saveIdMapping('team', team.id!, serverId);

      team.isSynced = true;
      team.lastSyncedAt = DateTime.now();
      await _isarService.updateTeam(team);
    } catch (e) {
      print('❌ Error syncing team to Firebase: $e');
      rethrow;
    }
  }

  Future<void> syncTeamsFromFirebase(String competitionServerId) async {
    try {
      final remoteTeams = await _firebaseService.getTeamsByCompetition(competitionServerId);
      final localCompetitionId = _getLocalId('competition', competitionServerId);

      if (localCompetitionId == null) {
        print('⚠️ Local competition not found for serverId: $competitionServerId');
        return;
      }

      for (var remote in remoteTeams) {
        int? localId = _getLocalId('team', remote.id);
        if (localId == null) {
          final local = remote.toLocal(localCompetitionId);
          localId = await _isarService.saveTeam(local);
          print('✅ Created local team from Firebase: localId=$localId');
        } else {
          final existingLocal = await _isarService.getTeam(localId);
          if (existingLocal != null && _shouldUpdateLocal(existingLocal.updatedAt, remote.updatedAt)) {
            final updatedLocal = remote.toLocal(localCompetitionId);
            updatedLocal.id = localId;
            await _isarService.updateTeam(updatedLocal);
            print('✅ Updated local team from Firebase: localId=$localId');
          }
        }

        _saveIdMapping('team', localId, remote.id);
      }
    } catch (e) {
      print('❌ Error syncing teams from Firebase: $e');
      rethrow;
    }
  }

  // ========== SYNC WEIGHINGS ==========

  Future<void> syncWeighingToFirebase(WeighingLocal weighing, String competitionServerId) async {
    try {
      if (!await hasInternetConnection()) {
        print('⚠️ No internet - weighing sync queued');
        return;
      }

      final remote = WeighingRemote.fromLocal(weighing, competitionServerId);

      String serverId;
      if (weighing.serverId != null && weighing.serverId!.isNotEmpty) {
        await _firebaseService.updateWeighing(competitionServerId, weighing.serverId!, remote);
        serverId = weighing.serverId!;
        print('✅ Updated weighing in Firebase: $serverId');
      } else {
        serverId = await _firebaseService.createWeighing(competitionServerId, remote);
        print('✅ Created weighing in Firebase: $serverId');

        weighing.serverId = serverId;
        await _isarService.updateWeighing(weighing);
      }

      _saveIdMapping('weighing', weighing.id!, serverId);

      weighing.isSynced = true;
      weighing.lastSyncedAt = DateTime.now();
      await _isarService.updateWeighing(weighing);
    } catch (e) {
      print('❌ Error syncing weighing to Firebase: $e');
      rethrow;
    }
  }

  Future<void> syncWeighingsFromFirebase(String competitionServerId) async {
    try {
      final remoteWeighings = await _firebaseService.getWeighingsByCompetition(competitionServerId);
      final localCompetitionId = _getLocalId('competition', competitionServerId);

      if (localCompetitionId == null) {
        print('⚠️ Local competition not found for serverId: $competitionServerId');
        return;
      }

      for (var remote in remoteWeighings) {
        int? localId = _getLocalId('weighing', remote.id);
        if (localId == null) {
          final local = remote.toLocal(localCompetitionId);
          localId = await _isarService.saveWeighing(local);
          print('✅ Created local weighing from Firebase: localId=$localId');
        } else {
          final existingLocal = await _isarService.getWeighing(localId);
          if (existingLocal != null && _shouldUpdateLocal(existingLocal.updatedAt, remote.updatedAt)) {
            final updatedLocal = remote.toLocal(localCompetitionId);
            updatedLocal.id = localId;
            await _isarService.updateWeighing(updatedLocal);
            print('✅ Updated local weighing from Firebase: localId=$localId');
          }
        }

        _saveIdMapping('weighing', localId, remote.id);
      }
    } catch (e) {
      print('❌ Error syncing weighings from Firebase: $e');
      rethrow;
    }
  }

  // ========== SYNC WEIGHING RESULTS ==========

  Future<void> syncWeighingResultToFirebase(
      WeighingResultLocal result,
      String competitionServerId,
      String weighingServerId,
      String teamServerId,
      ) async {
    try {
      if (!await hasInternetConnection()) {
        print('⚠️ No internet - weighing result sync queued');
        return;
      }

      final remote = WeighingResultRemote.fromLocal(result, weighingServerId, teamServerId);

      String serverId;
      if (result.serverId != null && result.serverId!.isNotEmpty) {
        await _firebaseService.updateWeighingResult(
          competitionServerId,
          weighingServerId,
          result.serverId!,
          remote,
        );
        serverId = result.serverId!;
        print('✅ Updated weighing result in Firebase: $serverId');
      } else {
        serverId = await _firebaseService.createWeighingResult(
          competitionServerId,
          weighingServerId,
          remote,
        );
        print('✅ Created weighing result in Firebase: $serverId');

        result.serverId = serverId;
        await _isarService.updateWeighingResult(result);
      }

      _saveIdMapping('weighing_result', result.id!, serverId);

      result.isSynced = true;
      result.lastSyncedAt = DateTime.now();
      await _isarService.updateWeighingResult(result);
    } catch (e) {
      print('❌ Error syncing weighing result to Firebase: $e');
      rethrow;
    }
  }

  Future<void> syncWeighingResultsFromFirebase(
      String competitionServerId,
      String weighingServerId,
      ) async {
    try {
      final remoteResults = await _firebaseService.getResultsByWeighing(
        competitionServerId,
        weighingServerId,
      );
      final localWeighingId = _getLocalId('weighing', weighingServerId);

      if (localWeighingId == null) {
        print('⚠️ Local weighing not found for serverId: $weighingServerId');
        return;
      }

      for (var remote in remoteResults) {
        final localTeamId = _getLocalId('team', remote.teamId);
        if (localTeamId == null) {
          print('⚠️ Local team not found for serverId: ${remote.teamId}');
          continue;
        }

        int? localId = _getLocalId('weighing_result', remote.id);
        if (localId == null) {
          final local = remote.toLocal(localWeighingId, localTeamId);
          localId = await _isarService.saveWeighingResult(local);
          print('✅ Created local weighing result from Firebase: localId=$localId');
        } else {
          final existingLocal = await _isarService.getWeighingResult(localId);
          if (existingLocal != null && _shouldUpdateLocal(existingLocal.updatedAt, remote.updatedAt)) {
            final updatedLocal = remote.toLocal(localWeighingId, localTeamId);
            updatedLocal.id = localId;
            await _isarService.updateWeighingResult(updatedLocal);
            print('✅ Updated local weighing result from Firebase: localId=$localId');
          }
        }

        _saveIdMapping('weighing_result', localId, remote.id);
      }
    } catch (e) {
      print('❌ Error syncing weighing results from Firebase: $e');
      rethrow;
    }
  }

  // ========== SYNC CASTING SESSIONS ==========

  Future<void> syncCastingSessionToFirebase(
      CastingSessionLocal session,
      String competitionServerId,
      ) async {
    try {
      if (!await hasInternetConnection()) {
        print('⚠️ No internet - casting session sync queued');
        return;
      }

      final remote = CastingSessionRemote.fromLocal(session, competitionServerId);

      String serverId;
      if (session.serverId != null && session.serverId!.isNotEmpty) {
        await _firebaseService.updateCastingSession(competitionServerId, session.serverId!, remote);
        serverId = session.serverId!;
        print('✅ Updated casting session in Firebase: $serverId');
      } else {
        serverId = await _firebaseService.createCastingSession(competitionServerId, remote);
        print('✅ Created casting session in Firebase: $serverId');

        session.serverId = serverId;
        await _isarService.updateCastingSession(session);
      }

      _saveIdMapping('casting_session', session.id, serverId);

      session.isSynced = true;
      session.lastSyncedAt = DateTime.now();
      await _isarService.updateCastingSession(session);
    } catch (e) {
      print('❌ Error syncing casting session to Firebase: $e');
      rethrow;
    }
  }

  Future<void> syncCastingSessionsFromFirebase(String competitionServerId) async {
    try {
      final remoteSessions = await _firebaseService.getCastingSessionsByCompetition(competitionServerId);
      final localCompetitionId = _getLocalId('competition', competitionServerId);

      if (localCompetitionId == null) {
        print('⚠️ Local competition not found for serverId: $competitionServerId');
        return;
      }

      for (var remote in remoteSessions) {
        int? localId = _getLocalId('casting_session', remote.id);
        if (localId == null) {
          final local = remote.toLocal(localCompetitionId);
          localId = await _isarService.saveCastingSession(local);
          print('✅ Created local casting session from Firebase: localId=$localId');
        } else {
          final existingLocal = await _isarService.getCastingSession(localId);
          if (existingLocal != null && _shouldUpdateLocal(existingLocal.updatedAt, remote.updatedAt)) {
            final updatedLocal = remote.toLocal(localCompetitionId);
            updatedLocal.id = localId;
            await _isarService.updateCastingSession(updatedLocal);
            print('✅ Updated local casting session from Firebase: localId=$localId');
          }
        }

        _saveIdMapping('casting_session', localId, remote.id);
      }
    } catch (e) {
      print('❌ Error syncing casting sessions from Firebase: $e');
      rethrow;
    }
  }

  // ========== SYNC CASTING RESULTS ==========

  Future<void> syncCastingResultToFirebase(
      CastingResultLocal result,
      String competitionServerId,
      String sessionServerId,
      String participantServerId,
      ) async {
    try {
      if (!await hasInternetConnection()) {
        print('⚠️ No internet - casting result sync queued');
        return;
      }

      final remote = CastingResultRemote.fromLocal(result, sessionServerId, participantServerId);

      String serverId;
      if (result.serverId != null && result.serverId!.isNotEmpty) {
        await _firebaseService.updateCastingResult(
          competitionServerId,
          sessionServerId,
          result.serverId!,
          remote,
        );
        serverId = result.serverId!;
        print('✅ Updated casting result in Firebase: $serverId');
      } else {
        serverId = await _firebaseService.createCastingResult(
          competitionServerId,
          sessionServerId,
          remote,
        );
        print('✅ Created casting result in Firebase: $serverId');

        result.serverId = serverId;
        await _isarService.updateCastingResult(result);
      }

      _saveIdMapping('casting_result', result.id, serverId);

      result.isSynced = true;
      result.lastSyncedAt = DateTime.now();
      await _isarService.updateCastingResult(result);
    } catch (e) {
      print('❌ Error syncing casting result to Firebase: $e');
      rethrow;
    }
  }

  Future<void> syncCastingResultsFromFirebase(
      String competitionServerId,
      String sessionServerId,
      ) async {
    try {
      final remoteResults = await _firebaseService.getResultsByCastingSession(
        competitionServerId,
        sessionServerId,
      );
      final localSessionId = _getLocalId('casting_session', sessionServerId);

      if (localSessionId == null) {
        print('⚠️ Local casting session not found for serverId: $sessionServerId');
        return;
      }

      for (var remote in remoteResults) {
        final localParticipantId = _getLocalId('team', remote.participantId);
        if (localParticipantId == null) {
          print('⚠️ Local participant not found for serverId: ${remote.participantId}');
          continue;
        }

        int? localId = _getLocalId('casting_result', remote.id);
        if (localId == null) {
          final local = remote.toLocal(localSessionId, localParticipantId);
          localId = await _isarService.saveCastingResult(local);
          print('✅ Created local casting result from Firebase: localId=$localId');
        } else {
          final existingLocal = await _isarService.getCastingResult(localId);
          if (existingLocal != null && _shouldUpdateLocal(existingLocal.updatedAt, remote.updatedAt)) {
            final updatedLocal = remote.toLocal(localSessionId, localParticipantId);
            updatedLocal.id = localId;
            await _isarService.updateCastingResult(updatedLocal);
            print('✅ Updated local casting result from Firebase: localId=$localId');
          }
        }

        _saveIdMapping('casting_result', localId, remote.id);
      }
    } catch (e) {
      print('❌ Error syncing casting results from Firebase: $e');
      rethrow;
    }
  }

  // ========== SYNC PROTOCOLS ==========

  Future<void> syncProtocolToFirebase(ProtocolLocal protocol, String competitionServerId) async {
    try {
      if (!await hasInternetConnection()) {
        print('⚠️ No internet - protocol sync queued');
        return;
      }

      final remote = ProtocolRemote.fromLocal(protocol, competitionServerId);

      String serverId;
      if (protocol.serverId != null && protocol.serverId!.isNotEmpty) {
        serverId = protocol.serverId!;
        print('⚠️ Protocol already synced: $serverId');
      } else {
        serverId = await _firebaseService.createProtocol(competitionServerId, remote);
        print('✅ Created protocol in Firebase: $serverId');

        protocol.serverId = serverId;
        await _isarService.saveProtocol(protocol);
      }

      _saveIdMapping('protocol', protocol.id, serverId);

      protocol.isSynced = true;
      protocol.lastSyncedAt = DateTime.now();
      await _isarService.saveProtocol(protocol);
    } catch (e) {
      print('❌ Error syncing protocol to Firebase: $e');
      rethrow;
    }
  }

  Future<void> syncProtocolsFromFirebase(String competitionServerId) async {
    try {
      final remoteProtocols = await _firebaseService.getProtocolsByCompetition(competitionServerId);

      for (var remote in remoteProtocols) {
        int? localId = _getLocalId('protocol', remote.id);
        if (localId == null) {
          final local = remote.toLocal();
          localId = await _isarService.saveProtocol(local);
          print('✅ Created local protocol from Firebase: localId=$localId');
        }

        _saveIdMapping('protocol', localId, remote.id);
      }
    } catch (e) {
      print('❌ Error syncing protocols from Firebase: $e');
      rethrow;
    }
  }

  // ========== CONFLICT RESOLUTION ==========

  bool _shouldUpdateLocal(DateTime? localUpdatedAt, DateTime? remoteUpdatedAt) {
    if (localUpdatedAt == null) return true;
    if (remoteUpdatedAt == null) return false;
    return remoteUpdatedAt.isAfter(localUpdatedAt);
  }

  // ========== SYNC STATUS ==========

  Future<bool> isSynced(int localId, String entityType) async {
    final serverId = _getServerId(entityType, localId);
    return serverId != null && serverId.isNotEmpty;
  }

  String? getServerId(int localId, String entityType) {
    return _getServerId(entityType, localId);
  }

  // ========== PUBLIC DELETE METHODS ==========

  Future<void> deleteCompetitionFromFirebase(String serverId) async {
    try {
      await _firebaseService.deleteCompetition(serverId);
      print('✅ Deleted competition from Firebase: $serverId');
    } catch (e) {
      print('❌ Error deleting competition from Firebase: $e');
      rethrow;
    }
  }

  Future<void> deleteTeamFromFirebase(String competitionId, String teamId) async {
    try {
      await _firebaseService.deleteTeam(competitionId, teamId);
      print('✅ Deleted team from Firebase: $teamId');
    } catch (e) {
      print('❌ Error deleting team from Firebase: $e');
      rethrow;
    }
  }

  Future<void> deleteWeighingFromFirebase(String competitionId, String weighingId) async {
    try {
      await _firebaseService.deleteWeighing(competitionId, weighingId);
      print('✅ Deleted weighing from Firebase: $weighingId');
    } catch (e) {
      print('❌ Error deleting weighing from Firebase: $e');
      rethrow;
    }
  }

  Future<void> deleteWeighingResultFromFirebase(
      String competitionId,
      String weighingId,
      String resultId,
      ) async {
    try {
      await _firebaseService.deleteWeighingResult(competitionId, weighingId, resultId);
      print('✅ Deleted weighing result from Firebase: $resultId');
    } catch (e) {
      print('❌ Error deleting weighing result from Firebase: $e');
      rethrow;
    }
  }

  Future<void> deleteCastingSessionFromFirebase(String competitionId, String sessionId) async {
    try {
      await _firebaseService.deleteCastingSession(competitionId, sessionId);
      print('✅ Deleted casting session from Firebase: $sessionId');
    } catch (e) {
      print('❌ Error deleting casting session from Firebase: $e');
      rethrow;
    }
  }

  Future<void> deleteCastingResultFromFirebase(
      String competitionId,
      String sessionId,
      String resultId,
      ) async {
    try {
      await _firebaseService.deleteCastingResult(competitionId, sessionId, resultId);
      print('✅ Deleted casting result from Firebase: $resultId');
    } catch (e) {
      print('❌ Error deleting casting result from Firebase: $e');
      rethrow;
    }
  }
}