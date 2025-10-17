import 'package:cloud_firestore/cloud_firestore.dart';
import '../local/weighing_result_local.dart';

/// Remote модель для синхронизации WeighingResultLocal с Firestore
///
/// Структура в Firestore:
/// /competitions/{competitionId}/weighings/{weighingId}/results/{resultId}
///   - teamId (String - serverId команды)
///   - fishes[] (массив Map с id, fishType, weight, length)
///   - totalWeight, averageWeight, fishCount
///   - qrCode, signatureBase64
///   - createdAt, updatedAt (Timestamp)
class WeighingResultRemote {
  final String id; // serverId в Firestore
  final String weighingId; // ID родительского взвешивания
  final String teamId; // serverId команды

  final List<FishCatchRemote> fishes;

  final double totalWeight;
  final double averageWeight;
  final int fishCount;

  final String? qrCode;
  final String? signatureBase64;

  final DateTime createdAt;
  final DateTime updatedAt;

  WeighingResultRemote({
    required this.id,
    required this.weighingId,
    required this.teamId,
    this.fishes = const [],
    required this.totalWeight,
    required this.averageWeight,
    required this.fishCount,
    this.qrCode,
    this.signatureBase64,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Конвертация в Map для сохранения в Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'weighingId': weighingId,
      'teamId': teamId,
      'fishes': fishes.map((f) => f.toMap()).toList(),
      'totalWeight': totalWeight,
      'averageWeight': averageWeight,
      'fishCount': fishCount,
      'qrCode': qrCode,
      'signatureBase64': signatureBase64,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Создание из Firestore документа
  factory WeighingResultRemote.fromFirestore(
      Map<String, dynamic> data,
      String id,
      ) {
    return WeighingResultRemote(
      id: id,
      weighingId: data['weighingId'] as String,
      teamId: data['teamId'] as String,
      fishes: (data['fishes'] as List<dynamic>?)
          ?.map((f) => FishCatchRemote.fromMap(f as Map<String, dynamic>))
          .toList() ?? [],
      totalWeight: (data['totalWeight'] as num).toDouble(),
      averageWeight: (data['averageWeight'] as num).toDouble(),
      fishCount: data['fishCount'] as int,
      qrCode: data['qrCode'] as String?,
      signatureBase64: data['signatureBase64'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Создание из WeighingResultLocal (для синхронизации Local → Remote)
  factory WeighingResultRemote.fromLocal(
      WeighingResultLocal local,
      String weighingServerId,
      String teamServerId,
      ) {
    return WeighingResultRemote(
      id: local.serverId ?? '', // Если serverId == null, будет создан новый документ
      weighingId: weighingServerId,
      teamId: teamServerId,
      fishes: local.fishes.map((f) => FishCatchRemote.fromLocal(f)).toList(),
      totalWeight: local.totalWeight,
      averageWeight: local.averageWeight,
      fishCount: local.fishCount,
      qrCode: local.qrCode,
      signatureBase64: local.signatureBase64,
      createdAt: local.createdAt,
      updatedAt: local.updatedAt,
    );
  }

  /// Конвертация обратно в WeighingResultLocal (для синхронизации Remote → Local)
  WeighingResultLocal toLocal(int weighingLocalId, int teamLocalId) {
    return WeighingResultLocal()
      ..id = 0
      ..serverId = id
      ..weighingLocalId = weighingLocalId
      ..teamLocalId = teamLocalId
      ..fishes = fishes.map((f) => f.toLocal()).toList()
      ..totalWeight = totalWeight
      ..averageWeight = averageWeight
      ..fishCount = fishCount
      ..qrCode = qrCode
      ..signatureBase64 = signatureBase64
      ..isSynced = true
      ..lastSyncedAt = DateTime.now()
      ..createdAt = createdAt
      ..updatedAt = updatedAt;
  }
}

/// Remote модель для FishCatch (embedded в WeighingResult)
class FishCatchRemote {
  final String id;
  final String fishType;
  final double weight;
  final double length;

  FishCatchRemote({
    required this.id,
    required this.fishType,
    required this.weight,
    required this.length,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fishType': fishType,
      'weight': weight,
      'length': length,
    };
  }

  factory FishCatchRemote.fromMap(Map<String, dynamic> map) {
    return FishCatchRemote(
      id: map['id'] as String,
      fishType: map['fishType'] as String,
      weight: (map['weight'] as num).toDouble(),
      length: (map['length'] as num).toDouble(),
    );
  }

  factory FishCatchRemote.fromLocal(FishCatch local) {
    return FishCatchRemote(
      id: local.id,
      fishType: local.fishType,
      weight: local.weight,
      length: local.length,
    );
  }

  FishCatch toLocal() {
    return FishCatch()
      ..id = id
      ..fishType = fishType
      ..weight = weight
      ..length = length;
  }
}