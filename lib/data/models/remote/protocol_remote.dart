import 'package:cloud_firestore/cloud_firestore.dart';
import '../local/protocol_local.dart';

/// Remote модель для синхронизации ProtocolLocal с Firestore
///
/// Структура в Firestore:
/// /competitions/{competitionId}/protocols/{protocolId}
///   - type (weighing/intermediate/big_fish/summary/final)
///   - weighingId, weighingNumber, dayNumber (для weighing/intermediate)
///   - bigFishDay (для big_fish)
///   - dataJson (таблица результатов в JSON)
///   - createdAt (Timestamp)
///
/// Примечание: Протоколы обычно read-only после создания,
/// поэтому updatedAt не используется
class ProtocolRemote {
  final String id; // serverId в Firestore
  final String competitionId; // ID родительского соревнования
  final String type;

  final String? weighingId;
  final int? weighingNumber;
  final int? dayNumber;

  final int? bigFishDay;

  final DateTime createdAt;

  final String dataJson;

  ProtocolRemote({
    required this.id,
    required this.competitionId,
    required this.type,
    this.weighingId,
    this.weighingNumber,
    this.dayNumber,
    this.bigFishDay,
    required this.createdAt,
    required this.dataJson,
  });

  /// Конвертация в Map для сохранения в Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'competitionId': competitionId,
      'type': type,
      'weighingId': weighingId,
      'weighingNumber': weighingNumber,
      'dayNumber': dayNumber,
      'bigFishDay': bigFishDay,
      'createdAt': Timestamp.fromDate(createdAt),
      'dataJson': dataJson,
    };
  }

  /// Создание из Firestore документа
  factory ProtocolRemote.fromFirestore(
      Map<String, dynamic> data,
      String id,
      ) {
    return ProtocolRemote(
      id: id,
      competitionId: data['competitionId'] as String,
      type: data['type'] as String,
      weighingId: data['weighingId'] as String?,
      weighingNumber: data['weighingNumber'] as int?,
      dayNumber: data['dayNumber'] as int?,
      bigFishDay: data['bigFishDay'] as int?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      dataJson: data['dataJson'] as String,
    );
  }

  /// Создание из ProtocolLocal (для синхронизации Local → Remote)
  factory ProtocolRemote.fromLocal(
      ProtocolLocal local,
      String competitionServerId,
      ) {
    return ProtocolRemote(
      id: local.serverId ?? '', // Если serverId == null, будет создан новый документ
      competitionId: competitionServerId,
      type: local.type,
      weighingId: local.weighingId,
      weighingNumber: local.weighingNumber,
      dayNumber: local.dayNumber,
      bigFishDay: local.bigFishDay,
      createdAt: local.createdAt,
      dataJson: local.dataJson,
    );
  }

  /// Конвертация обратно в ProtocolLocal (для синхронизации Remote → Local)
  ProtocolLocal toLocal() {
    return ProtocolLocal()
      ..id = 0
      ..serverId = id
      ..competitionId = competitionId
      ..type = type
      ..weighingId = weighingId
      ..weighingNumber = weighingNumber
      ..dayNumber = dayNumber
      ..bigFishDay = bigFishDay
      ..createdAt = createdAt
      ..dataJson = dataJson
      ..isSynced = true
      ..lastSyncedAt = DateTime.now();
  }
}