import 'package:isar_community/isar.dart';

part 'team_local.g.dart';

@collection
class TeamLocal {
  Id id = Isar.autoIncrement;

  @Index()
  String? serverId;

  @Index()
  late int competitionLocalId;

  late String name;
  late String city;
  String? club;

  List<TeamMember> members = [];
  List<Penalty> penalties = []; // Штрафы (текстовые записи)

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
  late String rank; // КМС, МС, МСМК (для рыбалки) или б/р (для кастинга)

  // ✅ НОВЫЕ ПОЛЯ ДЛЯ КАСТИНГА:
  String? rod; // Удилище (модель/название)
  String? line; // Леска (диаметр/тип) — если не указана общая в соревновании
}

@embedded
class Penalty {
  late String id; // UUID
  late String description; // Свободный текст описания штрафа
  late DateTime createdAt;
  late String addedByJudgeId; // Кто добавил
}