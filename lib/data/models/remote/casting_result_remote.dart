import 'package:cloud_firestore/cloud_firestore.dart';
import '../local/casting_result_local.dart';

/// Remote модель для синхронизации CastingResultLocal с Firestore
///
/// Структура в Firestore:
/// /competitions/{competitionId}/casting_sessions/{sessionId}/results/{resultId}
///   - participantId (String - serverId участника/команды)
///   - participantFullName
///   - attempts[] (массив Map с id, attemptNumber, distance, isValid, note, timestamp)
///   - bestDistance, validAttemptsCount
///   - qrCode, signatureBase64
///   - createdAt, updatedAt (Timestamp)
class CastingResultRemote {
  final String id; // serverId в Firestore
  final String sessionId; // ID родительской сессии
  final String participantId; // serverId участника (TeamLocal.serverId)

  final String participantFullName;

  final List<CastingAttemptRemote> attempts;

  final double bestDistance;
  final int validAttemptsCount;

  final String? qrCode;
  final String? signatureBase64;

  final DateTime createdAt;
  final DateTime updatedAt;

  CastingResultRemote({
    required this.id,
    required this.sessionId,
    required this.participantId,
    required this.participantFullName,
    this.attempts = const [],
    required this.bestDistance,
    required this.validAttemptsCount,
    this.qrCode,
    this.signatureBase64,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Конвертация в Map для сохранения в Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'sessionId': sessionId,
      'participantId': participantId,
      'participantFullName': participantFullName,
      'attempts': attempts.map((a) => a.toMap()).toList(),
      'bestDistance': bestDistance,
      'validAttemptsCount': validAttemptsCount,
      'qrCode': qrCode,
      'signatureBase64': signatureBase64,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Создание из Firestore документа
  factory CastingResultRemote.fromFirestore(
      Map<String, dynamic> data,
      String id,
      ) {
    return CastingResultRemote(
      id: id,
      sessionId: data['sessionId'] as String,
      participantId: data['participantId'] as String,
      participantFullName: data['participantFullName'] as String,
      attempts: (data['attempts'] as List<dynamic>?)
          ?.map((a) => CastingAttemptRemote.fromMap(a as Map<String, dynamic>))
          .toList() ?? [],
      bestDistance: (data['bestDistance'] as num).toDouble(),
      validAttemptsCount: data['validAttemptsCount'] as int,
      qrCode: data['qrCode'] as String?,
      signatureBase64: data['signatureBase64'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Создание из CastingResultLocal (для синхронизации Local → Remote)
  factory CastingResultRemote.fromLocal(
      CastingResultLocal local,
      String sessionServerId,
      String participantServerId,
      ) {
    return CastingResultRemote(
      id: local.serverId ?? '', // Если serverId == null, будет создан новый документ
      sessionId: sessionServerId,
      participantId: participantServerId,
      participantFullName: local.participantFullName,
      attempts: local.attempts.map((a) => CastingAttemptRemote.fromLocal(a)).toList(),
      bestDistance: local.bestDistance,
      validAttemptsCount: local.validAttemptsCount,
      qrCode: local.qrCode,
      signatureBase64: local.signatureBase64,
      createdAt: local.createdAt,
      updatedAt: local.updatedAt,
    );
  }

  /// Конвертация обратно в CastingResultLocal (для синхронизации Remote → Local)
  CastingResultLocal toLocal(int sessionLocalId, int participantLocalId) {
    return CastingResultLocal()
      ..id = 0
      ..serverId = id
      ..castingSessionId = sessionLocalId
      ..participantId = participantLocalId
      ..participantFullName = participantFullName
      ..attempts = attempts.map((a) => a.toLocal()).toList()
      ..bestDistance = bestDistance
      ..validAttemptsCount = validAttemptsCount
      ..qrCode = qrCode
      ..signatureBase64 = signatureBase64
      ..isSynced = true
      ..lastSyncedAt = DateTime.now()
      ..createdAt = createdAt
      ..updatedAt = updatedAt;
  }
}

/// Remote модель для CastingAttempt (embedded в CastingResult)
class CastingAttemptRemote {
  final String id;
  final int attemptNumber;
  final double distance;
  final bool isValid;
  final String? note;
  final DateTime timestamp;

  CastingAttemptRemote({
    required this.id,
    required this.attemptNumber,
    required this.distance,
    required this.isValid,
    this.note,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'attemptNumber': attemptNumber,
      'distance': distance,
      'isValid': isValid,
      'note': note,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory CastingAttemptRemote.fromMap(Map<String, dynamic> map) {
    return CastingAttemptRemote(
      id: map['id'] as String,
      attemptNumber: map['attemptNumber'] as int,
      distance: (map['distance'] as num).toDouble(),
      isValid: map['isValid'] as bool,
      note: map['note'] as String?,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  factory CastingAttemptRemote.fromLocal(CastingAttempt local) {
    return CastingAttemptRemote(
      id: local.id,
      attemptNumber: local.attemptNumber,
      distance: local.distance,
      isValid: local.isValid,
      note: local.note,
      timestamp: local.timestamp,
    );
  }

  CastingAttempt toLocal() {
    return CastingAttempt()
      ..id = id
      ..attemptNumber = attemptNumber
      ..distance = distance
      ..isValid = isValid
      ..note = note
      ..timestamp = timestamp;
  }
}