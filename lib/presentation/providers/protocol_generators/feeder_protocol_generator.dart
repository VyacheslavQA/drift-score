import '../../../data/models/local/protocol_local.dart';
import '../../../data/services/isar_service.dart';
import '../../../data/services/sync_service.dart';
import 'base_protocol_generator.dart';

/// Генератор протоколов для фидерной рыбалки
/// TODO: Реализовать генерацию протоколов
class FeederProtocolGenerator extends BaseProtocolGenerator {
  FeederProtocolGenerator(IsarService isarService, SyncService syncService)
      : super(isarService, syncService);

  Future<ProtocolLocal?> generateWeighingProtocol(
      int competitionId, int weighingId) async {
    print('⚠️ Feeder weighing protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateIntermediateProtocol(
      int competitionId, int upToWeighingNumber) async {
    print('⚠️ Feeder intermediate protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateBigFishProtocol(
      int competitionId, int dayNumber) async {
    print('⚠️ Feeder big fish protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateSummaryProtocol(int competitionId) async {
    print('⚠️ Feeder summary protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateFinalProtocol(int competitionId) async {
    print('⚠️ Feeder final protocol generation not implemented yet');
    return null;
  }
}