import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/local/weighing_local.dart';
import '../../data/models/local/weighing_result_local.dart';
import '../../data/services/isar_service.dart';

final weighingsProvider = StateNotifierProvider.family<WeighingNotifier, AsyncValue<List<WeighingLocal>>, int>(
      (ref, competitionId) => WeighingNotifier(competitionId),
);

final weighingResultsProvider = StateNotifierProvider.family<WeighingResultNotifier, AsyncValue<List<WeighingResultLocal>>, int>(
      (ref, weighingId) => WeighingResultNotifier(weighingId),
);

class WeighingNotifier extends StateNotifier<AsyncValue<List<WeighingLocal>>> {
  final int competitionId;
  final IsarService _isarService = IsarService();

  WeighingNotifier(this.competitionId) : super(const AsyncValue.loading()) {
    loadWeighings();
  }

  Future<void> loadWeighings() async {
    state = const AsyncValue.loading();
    try {
      final weighings = await _isarService.getWeighingsByCompetition(competitionId);
      state = AsyncValue.data(weighings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<int?> createWeighingSession({
    required int dayNumber,
    required DateTime weighingTime,
    required int weighingNumber,
    bool isExtraordinary = false,
  }) async {
    try {
      final weighing = WeighingLocal()
        ..competitionLocalId = competitionId
        ..dayNumber = dayNumber
        ..weighingTime = weighingTime
        ..weighingNumber = weighingNumber
        ..isCompleted = false
        ..isExtraordinary = isExtraordinary
        ..isSynced = false
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();

      final weighingId = await _isarService.saveWeighing(weighing);
      await loadWeighings();
      return weighingId;
    } catch (e) {
      print('Error creating weighing: $e');
      return null;
    }
  }

  Future<void> completeWeighingSession(int weighingId) async {
    try {
      final weighing = await _isarService.getWeighing(weighingId);
      if (weighing == null) return;

      weighing.isCompleted = true;
      weighing.completedAt = DateTime.now();
      weighing.updatedAt = DateTime.now();

      await _isarService.updateWeighing(weighing);
      await loadWeighings();
    } catch (e) {
      print('Error completing weighing: $e');
    }
  }

  Future<void> deleteWeighingSession(int weighingId) async {
    try {
      await _isarService.deleteWeighing(weighingId);
      await loadWeighings();
    } catch (e) {
      print('Error deleting weighing: $e');
    }
  }
}

class WeighingResultNotifier extends StateNotifier<AsyncValue<List<WeighingResultLocal>>> {
  final int weighingId;
  final IsarService _isarService = IsarService();

  WeighingResultNotifier(this.weighingId) : super(const AsyncValue.loading()) {
    loadResults();
  }

  Future<void> loadResults() async {
    state = const AsyncValue.loading();
    try {
      final results = await _isarService.getResultsByWeighing(weighingId);
      state = AsyncValue.data(results);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<bool> saveTeamResult({
    required int teamId,
    required List<FishCatch> fishes,
    String? qrCode,
    String? signature,
  }) async {
    try {
      final existing = await _isarService.getResultByTeamAndWeighing(teamId, weighingId);

      final totalWeight = fishes.fold(0.0, (sum, f) => sum + f.weight);
      final averageWeight = fishes.isEmpty ? 0.0 : totalWeight / fishes.length;

      if (existing != null) {
        existing.fishes = fishes;
        existing.totalWeight = totalWeight;
        existing.averageWeight = averageWeight;
        existing.fishCount = fishes.length;
        existing.qrCode = qrCode;
        existing.signatureBase64 = signature;
        existing.updatedAt = DateTime.now();
        existing.isSynced = false;

        await _isarService.updateWeighingResult(existing);
      } else {
        final result = WeighingResultLocal()
          ..weighingLocalId = weighingId
          ..teamLocalId = teamId
          ..fishes = fishes
          ..totalWeight = totalWeight
          ..averageWeight = averageWeight
          ..fishCount = fishes.length
          ..qrCode = qrCode
          ..signatureBase64 = signature
          ..isSynced = false
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();

        await _isarService.saveWeighingResult(result);
      }

      await loadResults();
      return true;
    } catch (e) {
      print('Error saving team result: $e');
      return false;
    }
  }

  FishCatch createEmptyFish() {
    const uuid = Uuid();
    return FishCatch()
      ..id = uuid.v4()
      ..weight = 0.0
      ..length = 0.0;
  }

  Future<void> deleteTeamResult(int resultId) async {
    try {
      await _isarService.deleteWeighingResult(resultId);
      await loadResults();
    } catch (e) {
      print('Error deleting result: $e');
    }
  }
}