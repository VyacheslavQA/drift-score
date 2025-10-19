import '../../../data/models/local/protocol_local.dart';
import '../../../data/services/isar_service.dart';
import '../../../data/services/sync_service.dart';
import 'base_protocol_generator.dart';

/// Генератор протоколов для форелевой рыбалки
/// TODO: Реализовать генерацию протоколов
class TroutProtocolGenerator extends BaseProtocolGenerator {
  TroutProtocolGenerator(IsarService isarService, SyncService syncService)
      : super(isarService, syncService);

  Future<ProtocolLocal?> generateWeighingProtocol(
      int competitionId, int weighingId) async {
    print('⚠️ Trout weighing protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateIntermediateProtocol(
      int competitionId, int upToWeighingNumber) async {
    print('⚠️ Trout intermediate protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateBigFishProtocol(
      int competitionId, int dayNumber) async {
    print('⚠️ Trout big fish protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateSummaryProtocol(int competitionId) async {
    print('⚠️ Trout summary protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateFinalProtocol(int competitionId) async {
    print('⚠️ Trout final protocol generation not implemented yet');
    return null;
  }
}