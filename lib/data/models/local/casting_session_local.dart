import 'package:isar_community/isar.dart';

part 'casting_session_local.g.dart';

@collection
class CastingSessionLocal {
  Id id = Isar.autoIncrement;

  @Index()
  String? serverId;

  @Index()
  late int competitionId; // К какому соревнованию относится

  late int sessionNumber; // Номер раунда/сессии (1, 2, 3...)
  late int dayNumber; // День соревнования (1, 2, 3...)

  late DateTime sessionTime; // Дата и время сессии

  // Список ID результатов участников в этой сессии
  List<int> resultIds = [];

  late bool isSynced;
  DateTime? lastSyncedAt;

  late DateTime createdAt;
  late DateTime updatedAt;
}