import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/local/weighing_local.dart';
import '../../data/models/local/weighing_result_local.dart';
import '../../data/models/local/competition_local.dart';
import '../../data/models/local/team_local.dart';
import '../../data/services/isar_service.dart';
import '../../data/services/sync_service.dart';
import 'competition_provider.dart';

// ✅ Используем syncServiceProvider из competition_provider
final weighingsProvider = StateNotifierProvider.family<WeighingNotifier, AsyncValue<List<WeighingLocal>>, int>(
      (ref, competitionId) {
    final syncService = ref.watch(syncServiceProvider);
    return WeighingNotifier(competitionId, syncService);
  },
);

final weighingResultsProvider = StateNotifierProvider.family<WeighingResultNotifier, AsyncValue<List<WeighingResultLocal>>, int>(
      (ref, weighingId) {
    final syncService = ref.watch(syncServiceProvider);
    return WeighingResultNotifier(weighingId, syncService);
  },
);

class WeighingNotifier extends StateNotifier<AsyncValue<List<WeighingLocal>>> {
  final int competitionId;
  final SyncService syncService;
  final IsarService _isarService = IsarService();

  WeighingNotifier(this.competitionId, this.syncService) : super(const AsyncValue.loading()) {
    loadWeighings();
  }

  /// Получить serverId соревнования
  Future<String?> _getCompetitionServerId() async {
    final competition = await _isarService.getCompetition(competitionId);
    return competition?.serverId;
  }

  Future<void> loadWeighings() async {
    state = const AsyncValue.loading();
    try {
      final weighings = await _isarService.getWeighingsByCompetition(competitionId);
      print('✅ Weighings loaded for competition $competitionId: ${weighings.length} items');
      for (var w in weighings) {
        print('  - Day ${w.dayNumber}, #${w.weighingNumber}, id=${w.id}, Synced: ${w.isSynced}');
      }
      state = AsyncValue.data(weighings);
    } catch (e, stack) {
      print('❌ Error loading weighings: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  /// ✅ НОВЫЙ МЕТОД: Синхронизировать взвешивания из Firebase
  Future<void> syncWeighingsFromFirebase() async {
    print('🔵 syncWeighingsFromFirebase() called');
    try {
      final competitionServerId = await _getCompetitionServerId();
      if (competitionServerId == null || competitionServerId.isEmpty) {
        print('⚠️ Competition not synced to Firebase yet');
        return;
      }

      await syncService.syncWeighingsFromFirebase(competitionServerId);
      print('✅ Weighings synced from Firebase');
      await loadWeighings();
    } catch (e, stack) {
      print('❌ Error syncing weighings from Firebase: $e');
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
      print('✅ Weighing created locally with ID: $weighingId');

      // ✅ НОВОЕ: Синхронизация с Firebase
      final competitionServerId = await _getCompetitionServerId();
      if (competitionServerId != null && competitionServerId.isNotEmpty) {
        print('🔄 Syncing weighing to Firebase...');
        try {
          await syncService.syncWeighingToFirebase(weighing, competitionServerId);
          print('✅ Weighing synced to Firebase successfully');
        } catch (e) {
          print('⚠️ Error syncing weighing to Firebase (will retry later): $e');
        }
      } else {
        print('⚠️ Competition not synced to Firebase yet - weighing will sync later');
      }

      await loadWeighings();
      return weighingId;
    } catch (e) {
      print('❌ Error creating weighing: $e');
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
      weighing.isSynced = false;

      await _isarService.updateWeighing(weighing);
      print('✅ Weighing completed locally');

      // ✅ НОВОЕ: Синхронизация с Firebase
      final competitionServerId = await _getCompetitionServerId();
      if (competitionServerId != null && competitionServerId.isNotEmpty) {
        print('🔄 Syncing completed weighing to Firebase...');
        try {
          await syncService.syncWeighingToFirebase(weighing, competitionServerId);
          print('✅ Weighing completion synced to Firebase successfully');
        } catch (e) {
          print('⚠️ Error syncing weighing completion to Firebase (will retry later): $e');
        }
      }

      await loadWeighings();
    } catch (e) {
      print('❌ Error completing weighing: $e');
    }
  }

  Future<void> deleteWeighingSession(int weighingId) async {
    try {
      // Получаем serverId перед удалением
      final weighing = await _isarService.getWeighing(weighingId);
      final weighingServerId = weighing?.serverId;
      final competitionServerId = await _getCompetitionServerId();

      await _isarService.deleteWeighing(weighingId);
      print('✅ Weighing deleted locally');

      // ✅ НОВОЕ: Удаление из Firebase
      if (weighingServerId != null &&
          weighingServerId.isNotEmpty &&
          competitionServerId != null &&
          competitionServerId.isNotEmpty) {
        print('🔄 Deleting weighing from Firebase...');
        try {
          await syncService.deleteWeighingFromFirebase(competitionServerId, weighingServerId);
          print('✅ Weighing deleted from Firebase successfully');
        } catch (e) {
          print('⚠️ Error deleting weighing from Firebase: $e');
        }
      } else {
        print('⚠️ Weighing was not synced to Firebase');
      }

      await loadWeighings();
    } catch (e) {
      print('❌ Error deleting weighing: $e');
    }
  }
}

class WeighingResultNotifier extends StateNotifier<AsyncValue<List<WeighingResultLocal>>> {
  final int weighingId;
  final SyncService syncService;
  final IsarService _isarService = IsarService();

  WeighingResultNotifier(this.weighingId, this.syncService) : super(const AsyncValue.loading()) {
    loadResults();
  }

  /// Получить serverId взвешивания
  Future<String?> _getWeighingServerId() async {
    final weighing = await _isarService.getWeighing(weighingId);
    return weighing?.serverId;
  }

  /// Получить serverId соревнования
  Future<String?> _getCompetitionServerId() async {
    final weighing = await _isarService.getWeighing(weighingId);
    if (weighing == null) return null;

    final competition = await _isarService.getCompetition(weighing.competitionLocalId);
    return competition?.serverId;
  }

  /// Получить serverId команды
  Future<String?> _getTeamServerId(int teamId) async {
    final team = await _isarService.getTeam(teamId);
    return team?.serverId;
  }

  Future<void> loadResults() async {
    state = const AsyncValue.loading();
    try {
      final results = await _isarService.getResultsByWeighing(weighingId);
      print('✅ Weighing results loaded: ${results.length} items');
      for (var r in results) {
        print('  - Team ${r.teamLocalId}: ${r.fishCount} fish, ${r.totalWeight}kg, Synced: ${r.isSynced}');
      }
      state = AsyncValue.data(results);
    } catch (e, stack) {
      print('❌ Error loading weighing results: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  /// ✅ НОВЫЙ МЕТОД: Синхронизировать результаты из Firebase
  Future<void> syncResultsFromFirebase() async {
    print('🔵 syncResultsFromFirebase() called');
    try {
      final competitionServerId = await _getCompetitionServerId();
      final weighingServerId = await _getWeighingServerId();

      if (competitionServerId == null ||
          competitionServerId.isEmpty ||
          weighingServerId == null ||
          weighingServerId.isEmpty) {
        print('⚠️ Weighing not synced to Firebase yet');
        return;
      }

      await syncService.syncWeighingResultsFromFirebase(competitionServerId, weighingServerId);
      print('✅ Weighing results synced from Firebase');
      await loadResults();
    } catch (e, stack) {
      print('❌ Error syncing results from Firebase: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<bool> saveTeamResult({
    required int teamId,
    required List<FishCatch> fishes,
    String? signatureBase64,
    String? qrCode,
    int? placeInZone,      // Для зимней мормышки
    int? memberIndex,      // Для зимней мормышки
    String? zone,          // Для зимней мормышки
  }) async {
    try {
      print('💾 Saving team result: teamId=$teamId, weighingId=$weighingId, fishCount=${fishes.length}');

      final existing = await _isarService.getResultByTeamAndWeighing(teamId, weighingId);
      print('💾 Existing result: ${existing != null ? "found (id=${existing.id})" : "not found"}');

      final totalWeight = fishes.fold(0.0, (sum, f) => sum + f.weight);
      final averageWeight = fishes.isEmpty ? 0.0 : totalWeight / fishes.length;

      print('💾 Calculated: totalWeight=$totalWeight, avgWeight=$averageWeight, fishCount=${fishes.length}');
      print('💾 Signature: ${signatureBase64 != null ? "provided (${signatureBase64.length} chars)" : "not provided"}');
      print('💾 Zone data: placeInZone=$placeInZone, memberIndex=$memberIndex, zone=$zone');

      WeighingResultLocal result;

      if (existing != null) {
        print('💾 Updating existing result...');
        existing.fishes = fishes;
        existing.totalWeight = totalWeight;
        existing.averageWeight = averageWeight;
        existing.fishCount = fishes.length;
        existing.qrCode = qrCode;
        existing.signatureBase64 = signatureBase64;
        existing.placeInZone = placeInZone;
        existing.memberIndex = memberIndex;
        existing.zone = zone;
        existing.updatedAt = DateTime.now();
        existing.isSynced = false;

        await _isarService.updateWeighingResult(existing);
        result = existing;
      } else {
        print('💾 Creating new result...');
        final newResult = WeighingResultLocal()
          ..weighingLocalId = weighingId
          ..teamLocalId = teamId
          ..fishes = fishes
          ..totalWeight = totalWeight
          ..averageWeight = averageWeight
          ..fishCount = fishes.length
          ..qrCode = qrCode
          ..signatureBase64 = signatureBase64
          ..placeInZone = placeInZone
          ..memberIndex = memberIndex
          ..zone = zone
          ..isSynced = false
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();

        await _isarService.saveWeighingResult(newResult);
        result = newResult;
      }

      print('✅ Team result saved locally');

      // ✅ НОВОЕ: Синхронизация с Firebase
      final competitionServerId = await _getCompetitionServerId();
      final weighingServerId = await _getWeighingServerId();
      final teamServerId = await _getTeamServerId(teamId);

      if (competitionServerId != null &&
          competitionServerId.isNotEmpty &&
          weighingServerId != null &&
          weighingServerId.isNotEmpty &&
          teamServerId != null &&
          teamServerId.isNotEmpty) {
        print('🔄 Syncing weighing result to Firebase...');
        try {
          await syncService.syncWeighingResultToFirebase(
            result,
            competitionServerId,
            weighingServerId,
            teamServerId,
          );
          print('✅ Weighing result synced to Firebase successfully');
        } catch (e) {
          print('⚠️ Error syncing result to Firebase (will retry later): $e');
        }
      } else {
        print('⚠️ Required entities not synced to Firebase yet - result will sync later');
        print('   Competition synced: ${competitionServerId != null}');
        print('   Weighing synced: ${weighingServerId != null}');
        print('   Team synced: ${teamServerId != null}');
      }

      await loadResults();
      print('✅ Team result saved successfully');
      return true;
    } catch (e, stack) {
      print('❌ Error saving team result: $e');
      print('Stack trace: $stack');
      return false;
    }
  }

  FishCatch createEmptyFish() {
    return FishCatch()
      ..id = const Uuid().v4()
      ..fishType = ''
      ..weight = 0.0
      ..length = 0.0;
  }

  Future<void> deleteTeamResult(int resultId) async {
    try {
      // Получаем serverId перед удалением
      final result = await _isarService.getWeighingResult(resultId);
      final resultServerId = result?.serverId;
      final competitionServerId = await _getCompetitionServerId();
      final weighingServerId = await _getWeighingServerId();

      await _isarService.deleteWeighingResult(resultId);
      print('✅ Weighing result deleted locally');

      // ✅ НОВОЕ: Удаление из Firebase
      if (resultServerId != null &&
          resultServerId.isNotEmpty &&
          competitionServerId != null &&
          competitionServerId.isNotEmpty &&
          weighingServerId != null &&
          weighingServerId.isNotEmpty) {
        print('🔄 Deleting weighing result from Firebase...');
        try {
          await syncService.deleteWeighingResultFromFirebase(
            competitionServerId,
            weighingServerId,
            resultServerId,
          );
          print('✅ Weighing result deleted from Firebase successfully');
        } catch (e) {
          print('⚠️ Error deleting result from Firebase: $e');
        }
      } else {
        print('⚠️ Weighing result was not synced to Firebase');
      }

      await loadResults();
    } catch (e) {
      print('❌ Error deleting result: $e');
    }
  }
}