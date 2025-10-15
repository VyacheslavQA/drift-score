import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/local/casting_session_local.dart';
import '../../data/models/local/casting_result_local.dart';
import '../../data/services/isar_service.dart';

// Provider для списка сессий кастинга
final castingSessionsProvider = StateNotifierProvider.family<
    CastingSessionsNotifier,
    AsyncValue<List<CastingSessionLocal>>,
    int>((ref, competitionId) {
  return CastingSessionsNotifier(competitionId);
});

// Provider для результатов кастинга в конкретной сессии
final castingResultsProvider = StateNotifierProvider.family<
    CastingResultsNotifier,
    AsyncValue<List<CastingResultLocal>>,
    int>((ref, sessionId) {
  return CastingResultsNotifier(sessionId);
});

// Notifier для управления сессиями кастинга
class CastingSessionsNotifier
    extends StateNotifier<AsyncValue<List<CastingSessionLocal>>> {
  final int competitionId;

  CastingSessionsNotifier(this.competitionId)
      : super(const AsyncValue.loading()) {
    print('🔵 CastingSessionsNotifier initialized for competition: $competitionId');
    loadSessions();
  }

  Future<void> loadSessions() async {
    print('🔵 loadSessions() called for competition: $competitionId');
    state = const AsyncValue.loading();
    try {
      final isarService = IsarService();
      final sessions = await isarService.getCastingSessionsByCompetition(competitionId);
      print('✅ Sessions loaded: ${sessions.length} items');
      state = AsyncValue.data(sessions);
    } catch (e, stack) {
      print('❌ Error loading sessions: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createSession({
    required int dayNumber,
    required int sessionNumber,
    required DateTime sessionTime,
  }) async {
    print('🔵 createSession() called');
    print('   Day: $dayNumber');
    print('   Session Number: $sessionNumber');
    print('   Time: $sessionTime');

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

      final isarService = IsarService();
      await isarService.saveCastingSession(session);
      print('✅ Session created with ID: ${session.id}');

      await loadSessions();
    } catch (e, stack) {
      print('❌ Error creating session: $e');
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> deleteSession(int sessionId) async {
    print('🔵 deleteSession() called: $sessionId');
    try {
      final isarService = IsarService();
      await isarService.deleteCastingSession(sessionId);
      print('✅ Session deleted: $sessionId');
      await loadSessions();
    } catch (e, stack) {
      print('❌ Error deleting session: $e');
      state = AsyncValue.error(e, stack);
    }
  }
}

// Notifier для управления результатами кастинга
class CastingResultsNotifier
    extends StateNotifier<AsyncValue<List<CastingResultLocal>>> {
  final int castingSessionId;

  CastingResultsNotifier(this.castingSessionId)
      : super(const AsyncValue.loading()) {
    print('🔵 CastingResultsNotifier initialized for session: $castingSessionId');
    loadResults();
  }

  Future<void> loadResults() async {
    print('🔵 loadResults() called for session: $castingSessionId');
    state = const AsyncValue.loading();
    try {
      final isarService = IsarService();
      final results = await isarService.getResultsByCastingSession(castingSessionId);
      print('✅ Results loaded: ${results.length} items');
      state = AsyncValue.data(results);
    } catch (e, stack) {
      print('❌ Error loading results: $e');
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
    print('🔵 saveParticipantResult() called');
    print('   Participant: $participantFullName');
    print('   Session Number: $sessionNumber');
    print('   Distance: $distance m');
    print('   Valid: $isValid');

    try {
      final isarService = IsarService();

      // Проверяем, есть ли уже результат для этого участника
      // Ищем по ФИО среди всех результатов сессии
      final allResults = await isarService.getResultsByCastingSession(castingSessionId);
      CastingResultLocal? existingResult = allResults.cast<CastingResultLocal?>().firstWhere(
            (r) => r?.participantFullName == participantFullName,
        orElse: () => null,
      );

      if (existingResult != null) {
        print('✅ Found existing result, updating...');

        // Обновляем попытку
        final attemptIndex = existingResult.attempts.indexWhere(
              (a) => a.attemptNumber == sessionNumber,
        );

        if (attemptIndex >= 0) {
          // Обновляем существующую попытку
          existingResult.attempts[attemptIndex]
            ..distance = distance
            ..isValid = isValid
            ..timestamp = DateTime.now();
        } else {
          // Добавляем новую попытку
          existingResult.attempts.add(CastingAttempt()
            ..id = const Uuid().v4()
            ..attemptNumber = sessionNumber
            ..distance = distance
            ..isValid = isValid
            ..timestamp = DateTime.now());
        }

        // Пересчитываем лучший результат
        final validAttempts = existingResult.attempts
            .where((a) => a.isValid && a.distance > 0)
            .toList();

        if (validAttempts.isNotEmpty) {
          existingResult.bestDistance = validAttempts
              .map((a) => a.distance)
              .reduce((a, b) => a > b ? a : b);
          existingResult.validAttemptsCount = validAttempts.length;
        } else {
          existingResult.bestDistance = 0.0;
          existingResult.validAttemptsCount = 0;
        }

        existingResult.updatedAt = DateTime.now();

        await isarService.updateCastingResult(existingResult);
        print('✅ Result updated');
      } else {
        print('✅ Creating new result...');

        // Создаём новый результат
        final result = CastingResultLocal()
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
        print('✅ Result created with ID: ${result.id}');
      }

      await loadResults();
    } catch (e, stack) {
      print('❌ Error saving result: $e');
      print('Stack: $stack');
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> deleteResult(int resultId) async {
    print('🔵 deleteResult() called: $resultId');
    try {
      final isarService = IsarService();
      await isarService.deleteCastingResult(resultId);
      print('✅ Result deleted: $resultId');
      await loadResults();
    } catch (e, stack) {
      print('❌ Error deleting result: $e');
      state = AsyncValue.error(e, stack);
    }
  }
}