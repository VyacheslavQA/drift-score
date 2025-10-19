import '../../../data/models/local/protocol_local.dart';
import '../../../data/services/isar_service.dart';
import '../../../data/services/sync_service.dart';
import 'base_protocol_generator.dart';

/// Генератор протоколов для спиннинговой рыбалки
/// TODO: Реализовать генерацию протоколов
class SpinningProtocolGenerator extends BaseProtocolGenerator {
  SpinningProtocolGenerator(IsarService isarService, SyncService syncService)
      : super(isarService, syncService);

  Future<ProtocolLocal?> generateWeighingProtocol(
      int competitionId, int weighingId) async {
    print('⚠️ Spinning weighing protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateIntermediateProtocol(
      int competitionId, int upToWeighingNumber) async {
    print('⚠️ Spinning intermediate protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateBigFishProtocol(
      int competitionId, int dayNumber) async {
    print('⚠️ Spinning big fish protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateSummaryProtocol(int competitionId) async {
    print('⚠️ Spinning summary protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateFinalProtocol(int competitionId) async {
    print('⚠️ Spinning final protocol generation not implemented yet');
    return null;
  }
}