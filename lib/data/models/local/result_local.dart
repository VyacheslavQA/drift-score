import 'package:isar_community/isar.dart';

part 'result_local.g.dart';

@collection
class ResultLocal {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String? serverId;

  @Index()
  late int weighingLocalId;

  @Index()
  late int teamLocalId;

  List<FishEntry> fishEntries = [];

  late double totalWeight;
  late int fishCount;
  late double avgWeight;
  double? biggestFishWeight; // Самая крупная рыба в этом взвешивании

  late bool isConfirmed;
  String? confirmationMethod; // 'qr' | 'signature'
  String? signatureLocalPath;
  DateTime? confirmedAt;

  late bool isSynced;
  DateTime? lastSyncedAt;

  late DateTime createdAt;
  late DateTime updatedAt;
}

@embedded
class FishEntry {
  late String id; // UUID
  late double weight;
  double? length; // Длина опционально (для Big Fish протокола)
  late DateTime timestamp;
}