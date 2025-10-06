import 'package:isar/isar.dart';

part 'competition_local.g.dart';

@collection
class CompetitionLocal {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String? serverId;

  late String name;
  late String cityOrRegion;
  late String organizerName;
  late String lakeName;
  late int sectorsCount;

  late DateTime startDate;
  late DateTime endDate;

  late String scoringRules;
  late String status;
  late String accessCode;

  late bool isSynced;
  DateTime? lastSyncedAt;

  late DateTime createdAt;
  late DateTime updatedAt;
}