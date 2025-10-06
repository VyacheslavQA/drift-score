import 'package:isar/isar.dart';

part 'team_local.g.dart';

@collection
class TeamLocal {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String? serverId;

  @Index()
  late int competitionLocalId;

  late String name;
  late String city;
  String? club;

  List<TeamMember> members = [];

  int? sector;
  int? drawOrder;

  late bool isSynced;
  DateTime? lastSyncedAt;

  late DateTime createdAt;
  late DateTime updatedAt;
}

@embedded
class TeamMember {
  late String fullName;
  late bool isCaptain;
  late String rank;
}