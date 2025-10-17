import 'package:cloud_firestore/cloud_firestore.dart';
import '../local/weighing_local.dart';

/// Remote модель для синхронизации WeighingLocal с Firestore
///
/// Структура в Firestore:
/// /competitions/{competitionId}/weighings/{weighingId}
///   - dayNumber, weighingNumber
///   - weighingTime (Timestamp)
///   - isCompleted, completedAt (Timestamp?)
///   - isExtraordinary
///   - createdAt, updatedAt (Timestamp)
class WeighingRemote {
  final String id; // serverId в Firestore
  final String competitionId; // ID родительского соревнования
  final int dayNumber;
  final DateTime weighingTime;
  final int weighingNumber;

  final bool isCompleted;
  final DateTime? completedAt;

  final bool isExtraordinary;

  final DateTime createdAt;
  final DateTime updatedAt;

  WeighingRemote({
    required this.id,
    required this.competitionId,
    required this.dayNumber,
    required this.weighingTime,
    required this.weighingNumber,
    required this.isCompleted,
    this.completedAt,
    required this.isExtraordinary,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Конвертация в Map для сохранения в Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'competitionId': competitionId,
      'dayNumber': dayNumber,
      'weighingTime': Timestamp.fromDate(weighingTime),
      'weighingNumber': weighingNumber,
      'isCompleted': isCompleted,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'isExtraordinary': isExtraordinary,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Создание из Firestore документа
  factory WeighingRemote.fromFirestore(
      Map<String, dynamic> data,
      String id,
      ) {
    return WeighingRemote(
      id: id,
      competitionId: data['competitionId'] as String,
      dayNumber: data['dayNumber'] as int,
      weighingTime: (data['weighingTime'] as Timestamp).toDate(),
      weighingNumber: data['weighingNumber'] as int,
      isCompleted: data['isCompleted'] as bool,
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      isExtraordinary: data['isExtraordinary'] as bool,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Создание из WeighingLocal (для синхронизации Local → Remote)
  factory WeighingRemote.fromLocal(WeighingLocal local, String competitionServerId) {
    return WeighingRemote(
      id: local.serverId ?? '', // Если serverId == null, будет создан новый документ
      competitionId: competitionServerId,
      dayNumber: local.dayNumber,
      weighingTime: local.weighingTime,
      weighingNumber: local.weighingNumber,
      isCompleted: local.isCompleted,
      completedAt: local.completedAt,
      isExtraordinary: local.isExtraordinary,
      createdAt: local.createdAt,
      updatedAt: local.updatedAt,
    );
  }

  /// Конвертация обратно в WeighingLocal (для синхронизации Remote → Local)
  WeighingLocal toLocal(int competitionLocalId) {
    return WeighingLocal()
      ..id = 0
      ..serverId = id
      ..competitionLocalId = competitionLocalId
      ..dayNumber = dayNumber
      ..weighingTime = weighingTime
      ..weighingNumber = weighingNumber
      ..isCompleted = isCompleted
      ..completedAt = completedAt
      ..isExtraordinary = isExtraordinary
      ..isSynced = true
      ..lastSyncedAt = DateTime.now()
      ..createdAt = createdAt
      ..updatedAt = updatedAt;
  }
}