import 'package:isar_community/isar.dart';

part 'weighing_local.g.dart';

@collection
class WeighingLocal {
  Id id = Isar.autoIncrement;

  @Index()
  String? serverId;

  @Index()
  late int competitionLocalId;

  late int dayNumber; // День соревнования (1, 2, 3...)
  late DateTime weighingTime; // Точное время взвешивания
  late int weighingNumber; // Номер взвешивания (1, 2, 3...)

  late bool isCompleted;
  DateTime? completedAt;

  late bool isExtraordinary;

  late bool isSynced;
  DateTime? lastSyncedAt;

  late DateTime createdAt;
  late DateTime updatedAt;
}