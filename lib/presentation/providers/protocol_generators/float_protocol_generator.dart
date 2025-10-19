import '../../../data/models/local/protocol_local.dart';
import '../../../data/services/isar_service.dart';
import '../../../data/services/sync_service.dart';
import 'base_protocol_generator.dart';

/// Генератор протоколов для поплавочной рыбалки
/// TODO: Реализовать генерацию протоколов
class FloatProtocolGenerator extends BaseProtocolGenerator {
  FloatProtocolGenerator(IsarService isarService, SyncService syncService)
      : super(isarService, syncService);

  Future<ProtocolLocal?> generateWeighingProtocol(
      int competitionId, int weighingId) async {
    print('⚠️ Float weighing protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateIntermediateProtocol(
      int competitionId, int upToWeighingNumber) async {
    print('⚠️ Float intermediate protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateBigFishProtocol(
      int competitionId, int dayNumber) async {
    print('⚠️ Float big fish protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateSummaryProtocol(int competitionId) async {
    print('⚠️ Float summary protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateFinalProtocol(int competitionId) async {
    print('⚠️ Float final protocol generation not implemented yet');
    return null;
  }
}