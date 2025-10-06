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

  late DateTime startTime; // С точным временем (например 24.08.2025 12:00)
  late int durationHours; // 72, 48, 96 и т.д.

  late String scoringRules; // 'total_weight' | 'top_3' | 'top_5'
  late String status; // 'draft' | 'active' | 'completed'
  late String accessCode;

  List<Judge> judges = []; // Список судей

  late bool isFinal; // Финальный протокол сформирован
  DateTime? finalizedAt; // Когда закрыли
  List<EditLog> editHistory = []; // История редактирований

  late bool isSynced;
  DateTime? lastSyncedAt;

  late DateTime createdAt;
  late DateTime updatedAt;
}

@embedded
class Judge {
  late String id; // UUID
  late String fullName;
  late String rank; // "Главный судья", "Судья", "Помощник судьи" или свободный ввод
}

@embedded
class EditLog {
  late String id; // UUID
  late DateTime timestamp;
  late String judgeId; // Кто редактировал
  late String action; // Описание действия
}