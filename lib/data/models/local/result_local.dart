import 'package:isar/isar.dart';

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
  double? biggestFishWeight;

  late bool isConfirmed;
  String? confirmationMethod;
  String? signatureLocalPath;
  DateTime? confirmedAt;

  late bool isSynced;
  DateTime? lastSyncedAt;

  late DateTime createdAt;
  late DateTime updatedAt;
}

@embedded
class FishEntry {
  late String id;
  late double weight;
  late DateTime timestamp;
}