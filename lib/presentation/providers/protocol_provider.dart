import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/local/protocol_local.dart';
import '../../data/services/isar_service.dart';
import '../../data/services/sync_service.dart';
import 'competition_provider.dart';
import 'protocol_generators/base_protocol_generator.dart';
import 'protocol_generators/carp_protocol_generator.dart';
import 'protocol_generators/casting_protocol_generator.dart';
import 'protocol_generators/float_protocol_generator.dart';
import 'protocol_generators/spinning_protocol_generator.dart';
import 'protocol_generators/feeder_protocol_generator.dart';
import 'protocol_generators/ice_jig_protocol_generator.dart';
import 'protocol_generators/ice_spoon_protocol_generator.dart';
import 'protocol_generators/trout_protocol_generator.dart';
import 'protocol_generators/fly_protocol_generator.dart';

// ========== STATE ==========

class ProtocolState {
  final List<ProtocolLocal> protocols;
  final bool isLoading;
  final String? error;

  ProtocolState({
    this.protocols = const [],
    this.isLoading = false,
    this.error,
  });

  ProtocolState copyWith({
    List<ProtocolLocal>? protocols,
    bool? isLoading,
    String? error,
  }) {
    return ProtocolState(
      protocols: protocols ?? this.protocols,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// ========== NOTIFIER ==========

class ProtocolNotifier extends StateNotifier<ProtocolState> {
  final IsarService _isarService;
  final SyncService _syncService;

  // Генераторы протоколов для каждого типа рыбалки
  late final CarpProtocolGenerator _carpGenerator;
  late final CastingProtocolGenerator _castingGenerator;
  late final FloatProtocolGenerator _floatGenerator;
  late final SpinningProtocolGenerator _spinningGenerator;
  late final FeederProtocolGenerator _feederGenerator;
  late final IceJigProtocolGenerator _iceJigGenerator;
  late final IceSpoonProtocolGenerator _iceSpoonGenerator;
  late final TroutProtocolGenerator _troutGenerator;
  late final FlyProtocolGenerator _flyGenerator;

  ProtocolNotifier(this._isarService, this._syncService) : super(ProtocolState()) {
    // Инициализируем генераторы
    _carpGenerator = CarpProtocolGenerator(_isarService, _syncService);
    _castingGenerator = CastingProtocolGenerator(_isarService, _syncService);
    _floatGenerator = FloatProtocolGenerator(_isarService, _syncService);
    _spinningGenerator = SpinningProtocolGenerator(_isarService, _syncService);
    _feederGenerator = FeederProtocolGenerator(_isarService, _syncService);
    _iceJigGenerator = IceJigProtocolGenerator(_isarService, _syncService);
    _iceSpoonGenerator = IceSpoonProtocolGenerator(_isarService, _syncService);
    _troutGenerator = TroutProtocolGenerator(_isarService, _syncService);
    _flyGenerator = FlyProtocolGenerator(_isarService, _syncService);
  }

  // ========== УПРАВЛЕНИЕ СОСТОЯНИЕМ ==========

  Future<void> loadProtocols(int competitionId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final protocols =
      await _isarService.getProtocolsByCompetition(competitionId);
      state = state.copyWith(protocols: protocols, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<List<ProtocolLocal>> loadProtocolsByType(
      int competitionId, String type) async {
    try {
      return await _isarService.getProtocolsByType(competitionId, type);
    } catch (e) {
      print('❌ Error loading protocols by type: $e');
      return [];
    }
  }

  // ✅ ИСПРАВЛЕНО: Удаление протокола из локальной базы И из Firebase
  Future<void> deleteProtocol(int id) async {
    try {
      // 1. Найти протокол в текущем состоянии
      final protocol = state.protocols.where((p) => p.id == id).firstOrNull;
      if (protocol == null) {
        print('⚠️ Protocol not found in state: id=$id');
        // Всё равно пытаемся удалить из локальной базы
        await _isarService.deleteProtocol(id);
        return;
      }

      print('🗑️ Deleting protocol: id=$id, type=${protocol.type}');

      // 2. Получить serverId соревнования
      final competitionId = int.parse(protocol.competitionId);
      final competition = await _isarService.getCompetition(competitionId);
      final competitionServerId = competition?.serverId;

      // 3. Удалить из локальной базы
      await _isarService.deleteProtocol(id);
      print('✅ Protocol deleted from local database');

      // 4. ✅ ДОБАВЛЕНО: Удалить из Firebase
      if (competitionServerId != null &&
          competitionServerId.isNotEmpty &&
          protocol.serverId != null &&
          protocol.serverId!.isNotEmpty) {
        try {
          await _syncService.deleteProtocolFromFirebase(
            protocol.serverId!,
            competitionServerId,
          );
          print('✅ Protocol deleted from Firebase');
        } catch (e) {
          print('⚠️ Error deleting from Firebase (may not exist): $e');
        }
      } else {
        print('ℹ️ Protocol was not synced to Firebase - skipping remote deletion');
      }

      // 5. Обновить состояние
      final updatedProtocols = state.protocols.where((p) => p.id != id).toList();
      state = state.copyWith(protocols: updatedProtocols);
      print('✅ Protocol deletion complete');
    } catch (e) {
      print('❌ Error deleting protocol: $e');
      rethrow;
    }
  }

  // ========== ГЕНЕРАЦИЯ ПРОТОКОЛОВ: КАСТИНГ ==========

  Future<ProtocolLocal?> generateCastingAttemptProtocol(
      int competitionId, int attemptNumber) async {
    return _castingGenerator.generateCastingAttemptProtocol(
        competitionId, attemptNumber);
  }

  Future<ProtocolLocal?> generateCastingIntermediateProtocol(
      int competitionId, int upToAttempt) async {
    return _castingGenerator.generateCastingIntermediateProtocol(
        competitionId, upToAttempt);
  }

  Future<ProtocolLocal?> generateCastingFinalProtocol(int competitionId) async {
    return _castingGenerator.generateCastingFinalProtocol(competitionId);
  }

  // ========== ГЕНЕРАЦИЯ ПРОТОКОЛОВ: РЫБАЛКА ==========

  Future<ProtocolLocal?> generateWeighingProtocol(
      int competitionId, int weighingId) async {
    final competition = await _isarService.getCompetition(competitionId);
    if (competition == null) return null;

    switch (competition.fishingType) {
      case 'carp':
        return _carpGenerator.generateWeighingProtocol(
            competitionId, weighingId);
      case 'float':
        return _floatGenerator.generateWeighingProtocol(
            competitionId, weighingId);
      case 'spinning':
        return _spinningGenerator.generateWeighingProtocol(
            competitionId, weighingId);
      case 'feeder':
        return _feederGenerator.generateWeighingProtocol(
            competitionId, weighingId);
      case 'ice_jig':
        return _iceJigGenerator.generateWeighingProtocol(
            competitionId, weighingId);
      case 'ice_spoon':
        return _iceSpoonGenerator.generateWeighingProtocol(
            competitionId, weighingId);
      case 'trout':
        return _troutGenerator.generateWeighingProtocol(
            competitionId, weighingId);
      case 'fly':
        return _flyGenerator.generateWeighingProtocol(competitionId, weighingId);
      default:
        print('⚠️ Unknown fishing type: ${competition.fishingType}');
        return null;
    }
  }

  Future<ProtocolLocal?> generateIntermediateProtocol(
      int competitionId, int upToWeighingNumber) async {
    final competition = await _isarService.getCompetition(competitionId);
    if (competition == null) return null;

    switch (competition.fishingType) {
      case 'carp':
        return _carpGenerator.generateIntermediateProtocol(
            competitionId, upToWeighingNumber);
      case 'float':
        return _floatGenerator.generateIntermediateProtocol(
            competitionId, upToWeighingNumber);
      case 'spinning':
        return _spinningGenerator.generateIntermediateProtocol(
            competitionId, upToWeighingNumber);
      case 'feeder':
        return _feederGenerator.generateIntermediateProtocol(
            competitionId, upToWeighingNumber);
      case 'ice_jig':
        return _iceJigGenerator.generateIntermediateProtocol(
            competitionId, upToWeighingNumber);
      case 'ice_spoon':
        return _iceSpoonGenerator.generateIntermediateProtocol(
            competitionId, upToWeighingNumber);
      case 'trout':
        return _troutGenerator.generateIntermediateProtocol(
            competitionId, upToWeighingNumber);
      case 'fly':
        return _flyGenerator.generateIntermediateProtocol(
            competitionId, upToWeighingNumber);
      default:
        print('⚠️ Unknown fishing type: ${competition.fishingType}');
        return null;
    }
  }

  Future<ProtocolLocal?> generateBigFishProtocol(
      int competitionId, int dayNumber) async {
    final competition = await _isarService.getCompetition(competitionId);
    if (competition == null) return null;

    switch (competition.fishingType) {
      case 'carp':
        return _carpGenerator.generateBigFishProtocol(competitionId, dayNumber);
      case 'float':
        return _floatGenerator.generateBigFishProtocol(competitionId, dayNumber);
      case 'spinning':
        return _spinningGenerator.generateBigFishProtocol(
            competitionId, dayNumber);
      case 'feeder':
        return _feederGenerator.generateBigFishProtocol(competitionId, dayNumber);
      case 'ice_jig':
        return _iceJigGenerator.generateBigFishProtocol(competitionId, dayNumber);
      case 'ice_spoon':
        return _iceSpoonGenerator.generateBigFishProtocol(
            competitionId, dayNumber);
      case 'trout':
        return _troutGenerator.generateBigFishProtocol(competitionId, dayNumber);
      case 'fly':
        return _flyGenerator.generateBigFishProtocol(competitionId, dayNumber);
      default:
        print('⚠️ Unknown fishing type: ${competition.fishingType}');
        return null;
    }
  }

  Future<ProtocolLocal?> generateSummaryProtocol(int competitionId) async {
    final competition = await _isarService.getCompetition(competitionId);
    if (competition == null) return null;

    switch (competition.fishingType) {
      case 'carp':
        return _carpGenerator.generateSummaryProtocol(competitionId);
      case 'float':
        return _floatGenerator.generateSummaryProtocol(competitionId);
      case 'spinning':
        return _spinningGenerator.generateSummaryProtocol(competitionId);
      case 'feeder':
        return _feederGenerator.generateSummaryProtocol(competitionId);
      case 'ice_jig':
        return _iceJigGenerator.generateSummaryProtocol(competitionId);
      case 'ice_spoon':
        return _iceSpoonGenerator.generateSummaryProtocol(competitionId);
      case 'trout':
        return _troutGenerator.generateSummaryProtocol(competitionId);
      case 'fly':
        return _flyGenerator.generateSummaryProtocol(competitionId);
      default:
        print('⚠️ Unknown fishing type: ${competition.fishingType}');
        return null;
    }
  }

  Future<ProtocolLocal?> generateFinalProtocol(int competitionId) async {
    final competition = await _isarService.getCompetition(competitionId);
    if (competition == null) return null;

    switch (competition.fishingType) {
      case 'carp':
        return _carpGenerator.generateFinalProtocol(competitionId);
      case 'float':
        return _floatGenerator.generateFinalProtocol(competitionId);
      case 'spinning':
        return _spinningGenerator.generateFinalProtocol(competitionId);
      case 'feeder':
        return _feederGenerator.generateFinalProtocol(competitionId);
      case 'ice_jig':
        return _iceJigGenerator.generateFinalProtocol(competitionId);
      case 'ice_spoon':
        return _iceSpoonGenerator.generateFinalProtocol(competitionId);
      case 'trout':
        return _troutGenerator.generateFinalProtocol(competitionId);
      case 'fly':
        return _flyGenerator.generateFinalProtocol(competitionId);
      default:
        print('⚠️ Unknown fishing type: ${competition.fishingType}');
        return null;
    }
  }

  // ========== ГЕНЕРАЦИЯ ПРОТОКОЛОВ: ЗИМНЯЯ МОРМЫШКА ==========

  Future<ProtocolLocal?> generateIceSpoonTourProtocol(
      int competitionId, int tourNumber) async {
    final competition = await _isarService.getCompetition(competitionId);
    if (competition == null) return null;

    if (competition.fishingType == 'ice_spoon' &&
        competition.scoringMethod == 'zoned_placement') {
      return _iceSpoonGenerator.generateIceSpoonTourProtocol(
          competitionId, tourNumber);
    }

    print('⚠️ Not a zonal ice_spoon competition');
    return null;
  }

  Future<ProtocolLocal?> generateIceSpoonFinalProtocol(int competitionId) async {
    final competition = await _isarService.getCompetition(competitionId);
    if (competition == null) return null;

    if (competition.fishingType == 'ice_spoon' &&
        competition.scoringMethod == 'zoned_placement') {
      return _iceSpoonGenerator.generateIceSpoonFinalProtocol(competitionId);
    }

    print('⚠️ Not a zonal ice_spoon competition');
    return null;
  }
}

// ========== PROVIDER ==========

final protocolProvider =
StateNotifierProvider<ProtocolNotifier, ProtocolState>((ref) {
  final syncService = ref.watch(syncServiceProvider);
  return ProtocolNotifier(IsarService(), syncService);
});