import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/local/casting_session_local.dart';
import '../../data/models/local/casting_result_local.dart';
import '../../data/services/isar_service.dart';
import '../../data/services/sync_service.dart';
import 'competition_provider.dart';

final castingSessionsProvider = StateNotifierProvider.family<
    CastingSessionsNotifier,
    AsyncValue<List<CastingSessionLocal>>,
    int>((ref, competitionId) {
  final syncService = ref.watch(syncServiceProvider);
  return CastingSessionsNotifier(competitionId, syncService);
});

final castingResultsProvider = StateNotifierProvider.family<
    CastingResultsNotifier,
    AsyncValue<List<CastingResultLocal>>,
    int>((ref, sessionId) {
  final syncService = ref.watch(syncServiceProvider);
  return CastingResultsNotifier(sessionId, syncService);
});

class CastingSessionsNotifier extends StateNotifier<AsyncValue<List<CastingSessionLocal>>> {
  final int competitionId;
  final SyncService syncService;

  CastingSessionsNotifier(this.competitionId, this.syncService) : super(const AsyncValue.loading()) {
    loadSessions();
  }

  Future<String?> _getCompetitionServerId() async {
    final competition = await IsarService().getCompetition(competitionId);
    return competition?.serverId;
  }

  Future<void> loadSessions() async {
    state = const AsyncValue.loading();
    try {
      final sessions = await IsarService().getCastingSessionsByCompetition(competitionId);
      state = AsyncValue.data(sessions);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createSession({
    required int dayNumber,
    required int sessionNumber,
    required DateTime sessionTime,
  }) async {
    try {
      final session = CastingSessionLocal()
        ..competitionId = competitionId
        ..sessionNumber = sessionNumber
        ..dayNumber = dayNumber
        ..sessionTime = sessionTime
        ..resultIds = []
        ..isSynced = false
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();

      await IsarService().saveCastingSession(session);

      final competitionServerId = await _getCompetitionServerId();
      if (competitionServerId != null && competitionServerId.isNotEmpty) {
        try {
          await syncService.syncCastingSessionToFirebase(session, competitionServerId);
        } catch (e) {
          print('⚠️ Sync error: $e');
        }
      }

      await loadSessions();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> deleteSession(int sessionId) async {
    try {
      final session = await IsarService().getCastingSession(sessionId);
      final sessionServerId = session?.serverId;
      final competitionServerId = await _getCompetitionServerId();

      await IsarService().deleteCastingSession(sessionId);

      if (sessionServerId != null && competitionServerId != null) {
        try {
          await syncService.deleteCastingSessionFromFirebase(competitionServerId, sessionServerId);
        } catch (e) {
          print('⚠️ Delete sync error: $e');
        }
      }

      await loadSessions();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

class CastingResultsNotifier extends StateNotifier<AsyncValue<List<CastingResultLocal>>> {
  final int castingSessionId;
  final SyncService syncService;

  CastingResultsNotifier(this.castingSessionId, this.syncService) : super(const AsyncValue.loading()) {
    loadResults();
  }

  Future<String?> _getCompetitionServerId() async {
    final session = await IsarService().getCastingSession(castingSessionId);
    if (session == null) return null;
    final competition = await IsarService().getCompetition(session.competitionId);
    return competition?.serverId;
  }

  Future<String?> _getSessionServerId() async {
    final session = await IsarService().getCastingSession(castingSessionId);
    return session?.serverId;
  }

  Future<String?> _getParticipantServerId(int participantId) async {
    final team = await IsarService().getTeam(participantId);
    return team?.serverId;
  }

  Future<void> loadResults() async {
    state = const AsyncValue.loading();
    try {
      final results = await IsarService().getResultsByCastingSession(castingSessionId);
      state = AsyncValue.data(results);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> saveParticipantResult({
    required int participantId,
    required String participantFullName,
    required int sessionNumber,
    required double distance,
    required bool isValid,
  }) async {
    try {
      final isarService = IsarService();
      final allResults = await isarService.getResultsByCastingSession(castingSessionId);

      CastingResultLocal? existingResult = allResults.cast<CastingResultLocal?>().firstWhere(
            (r) => r?.participantFullName == participantFullName,
        orElse: () => null,
      );

      CastingResultLocal result;

      if (existingResult != null) {
        final attemptIndex = existingResult.attempts.indexWhere((a) => a.attemptNumber == sessionNumber);
        if (attemptIndex >= 0) {
          existingResult.attempts[attemptIndex]
            ..distance = distance
            ..isValid = isValid
            ..timestamp = DateTime.now();
        } else {
          existingResult.attempts.add(CastingAttempt()
            ..id = const Uuid().v4()
            ..attemptNumber = sessionNumber
            ..distance = distance
            ..isValid = isValid
            ..timestamp = DateTime.now());
        }

        final validAttempts = existingResult.attempts.where((a) => a.isValid && a.distance > 0).toList();
        if (validAttempts.isNotEmpty) {
          existingResult.bestDistance = validAttempts.map((a) => a.distance).reduce((a, b) => a > b ? a : b);
          existingResult.validAttemptsCount = validAttempts.length;
        } else {
          existingResult.bestDistance = 0.0;
          existingResult.validAttemptsCount = 0;
        }

        existingResult.updatedAt = DateTime.now();
        existingResult.isSynced = false;
        await isarService.updateCastingResult(existingResult);
        result = existingResult;
      } else {
        result = CastingResultLocal()
          ..castingSessionId = castingSessionId
          ..participantId = participantId
          ..participantFullName = participantFullName
          ..attempts = [
            CastingAttempt()
              ..id = const Uuid().v4()
              ..attemptNumber = sessionNumber
              ..distance = distance
              ..isValid = isValid
              ..timestamp = DateTime.now()
          ]
          ..bestDistance = isValid ? distance : 0.0
          ..validAttemptsCount = isValid ? 1 : 0
          ..isSynced = false
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();

        await isarService.saveCastingResult(result);
      }

      final competitionServerId = await _getCompetitionServerId();
      final sessionServerId = await _getSessionServerId();
      final participantServerId = await _getParticipantServerId(participantId);

      if (competitionServerId != null && sessionServerId != null && participantServerId != null) {
        try {
          await syncService.syncCastingResultToFirebase(
            result,
            competitionServerId,
            sessionServerId,
            participantServerId,
          );
        } catch (e) {
          print('⚠️ Sync error: $e');
        }
      }

      await loadResults();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> deleteResult(int resultId) async {
    try {
      final result = await IsarService().getCastingResult(resultId);
      final resultServerId = result?.serverId;
      final competitionServerId = await _getCompetitionServerId();
      final sessionServerId = await _getSessionServerId();

      await IsarService().deleteCastingResult(resultId);

      if (resultServerId != null && competitionServerId != null && sessionServerId != null) {
        try {
          await syncService.deleteCastingResultFromFirebase(
            competitionServerId,
            sessionServerId,
            resultServerId,
          );
        } catch (e) {
          print('⚠️ Delete sync error: $e');
        }
      }

      await loadResults();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}