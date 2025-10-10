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
  String status = 'draft'; // 'draft' | 'active' | 'completed'
  String? accessCode; // Код доступа организатора
  String? createdByDeviceId; // ID устройства, которое создало соревнование (для фильтрации "Мои соревнования")

  List<Judge> judges = []; // Список судей

  late bool isFinal; // Финальный протокол сформирован
  DateTime? finalizedAt; // Когда закрыли
  List<EditLog> editHistory = []; // История редактирований

  bool isSynced = false; // ← Инициализировали значением по умолчанию
  DateTime? lastSyncedAt;

  late DateTime createdAt;
  DateTime? updatedAt; // ← Сделали nullable (не всегда обновляется сразу)
}

@embedded
class Judge {
  String id = ''; // ← Инициализировали пустой строкой
  late String fullName;
  late String rank; // "Главный судья", "Судья", "Помощник судьи" или свободный ввод
}

@embedded
class EditLog {
  String id = ''; // ← Инициализировали пустой строкой
  late DateTime timestamp;
  late String judgeId; // Кто редактировал
  late String action; // Описание действия
}