import 'package:isar/isar.dart';

part 'weighing_local.g.dart';

@collection
class WeighingLocal {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String? serverId;

  @Index()
  late int competitionLocalId;

  late int weighingNumber;
  late DateTime scheduledTime;

  late bool isCompleted;
  DateTime? completedAt;

  late bool isExtraordinary;

  late bool isSynced;
  DateTime? lastSyncedAt;

  late DateTime createdAt;
  late DateTime updatedAt;
}