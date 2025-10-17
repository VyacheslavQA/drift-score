import 'package:cloud_firestore/cloud_firestore.dart';
import '../local/casting_session_local.dart';

/// Remote модель для синхронизации CastingSessionLocal с Firestore
///
/// Структура в Firestore:
/// /competitions/{competitionId}/casting_sessions/{sessionId}
///   - sessionNumber, dayNumber
///   - sessionTime (Timestamp)
///   - createdAt, updatedAt (Timestamp)
///
/// Примечание: resultIds не хранятся в Firestore, т.к. результаты
/// хранятся в субколлекции /results/{resultId}
class CastingSessionRemote {
  final String id; // serverId в Firestore
  final String competitionId; // ID родительского соревнования
  final int sessionNumber;
  final int dayNumber;
  final DateTime sessionTime;

  final DateTime createdAt;
  final DateTime updatedAt;

  CastingSessionRemote({
    required this.id,
    required this.competitionId,
    required this.sessionNumber,
    required this.dayNumber,
    required this.sessionTime,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Конвертация в Map для сохранения в Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'competitionId': competitionId,
      'sessionNumber': sessionNumber,
      'dayNumber': dayNumber,
      'sessionTime': Timestamp.fromDate(sessionTime),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Создание из Firestore документа
  factory CastingSessionRemote.fromFirestore(
      Map<String, dynamic> data,
      String id,
      ) {
    return CastingSessionRemote(
      id: id,
      competitionId: data['competitionId'] as String,
      sessionNumber: data['sessionNumber'] as int,
      dayNumber: data['dayNumber'] as int,
      sessionTime: (data['sessionTime'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Создание из CastingSessionLocal (для синхронизации Local → Remote)
  factory CastingSessionRemote.fromLocal(
      CastingSessionLocal local,
      String competitionServerId,
      ) {
    return CastingSessionRemote(
      id: local.serverId ?? '', // Если serverId == null, будет создан новый документ
      competitionId: competitionServerId,
      sessionNumber: local.sessionNumber,
      dayNumber: local.dayNumber,
      sessionTime: local.sessionTime,
      createdAt: local.createdAt,
      updatedAt: local.updatedAt,
    );
  }

  /// Конвертация обратно в CastingSessionLocal (для синхронизации Remote → Local)
  CastingSessionLocal toLocal(int competitionLocalId) {
    return CastingSessionLocal()
      ..id = 0
      ..serverId = id
      ..competitionId = competitionLocalId
      ..sessionNumber = sessionNumber
      ..dayNumber = dayNumber
      ..sessionTime = sessionTime
      ..resultIds = [] // Заполнится при синхронизации результатов
      ..isSynced = true
      ..lastSyncedAt = DateTime.now()
      ..createdAt = createdAt
      ..updatedAt = updatedAt;
  }
}