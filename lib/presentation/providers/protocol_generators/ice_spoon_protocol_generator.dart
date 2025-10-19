import '../../../data/models/local/protocol_local.dart';
import '../../../data/services/isar_service.dart';
import '../../../data/services/sync_service.dart';
import 'base_protocol_generator.dart';

/// Генератор протоколов для зимней блесны
/// TODO: Реализовать генерацию протоколов
class IceSpoonProtocolGenerator extends BaseProtocolGenerator {
  IceSpoonProtocolGenerator(IsarService isarService, SyncService syncService)
      : super(isarService, syncService);

  Future<ProtocolLocal?> generateWeighingProtocol(
      int competitionId, int weighingId) async {
    print('⚠️ Ice spoon weighing protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateIntermediateProtocol(
      int competitionId, int upToWeighingNumber) async {
    print('⚠️ Ice spoon intermediate protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateBigFishProtocol(
      int competitionId, int dayNumber) async {
    print('⚠️ Ice spoon big fish protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateSummaryProtocol(int competitionId) async {
    print('⚠️ Ice spoon summary protocol generation not implemented yet');
    return null;
  }

  Future<ProtocolLocal?> generateFinalProtocol(int competitionId) async {
    print('⚠️ Ice spoon final protocol generation not implemented yet');
    return null;
  }
}