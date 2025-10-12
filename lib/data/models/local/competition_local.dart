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

  late DateTime startTime; // Дата и время старта
  late DateTime finishTime; // Дата и время финиша

  // Вычисляемое свойство - количество часов
  int get durationHours {
    return finishTime.difference(startTime).inHours;
  }

  // Вычисляемое свойство - количество календарных дней
  int get durationDays {
    final startDate = DateTime(startTime.year, startTime.month, startTime.day);
    final finishDate = DateTime(finishTime.year, finishTime.month, finishTime.day);
    return finishDate.difference(startDate).inDays + 1;
  }

  // ✅ Тип рыбалки
  late String fishingType; // 'float' | 'spinning' | 'carp' | 'feeder' | 'ice_jig' | 'ice_spoon' | 'trout' | 'fly'

  // ✅ Метод подсчета результатов
  late String scoringMethod;
  // 'total_weight' - общий вес
  // 'total_length' - общая длина (см)
  // 'total_count' - общее количество рыб
  // 'top_3_weight' - топ-3 по весу
  // 'top_5_weight' - топ-5 по весу
  // 'top_3_length' - топ-3 по длине
  // 'top_5_length' - топ-5 по длине

  // ✅ Структура секторов
  late String sectorStructure; // 'simple' | 'zoned'

  // ✅ Для зональной структуры
  String? zonedType; // 'single_lake' | 'multiple_lakes' (null если simple)
  int? zonesCount; // Количество зон (null если simple)
  int? sectorsPerZone; // Секторов в каждой зоне (только для multiple_lakes)
  List<String> lakeNames = []; // Названия озёр для каждой зоны (только для multiple_lakes)

  // ✅ Общее количество секторов
  late int sectorsCount;

  String status = 'draft'; // 'draft' | 'active' | 'completed'
  String? accessCode; // Код доступа организатора
  String? createdByDeviceId; // ID устройства, которое создало соревнование

  List<Judge> judges = []; // Список судей

  late bool isFinal; // Финальный протокол сформирован
  DateTime? finalizedAt; // Когда закрыли
  List<EditLog> editHistory = []; // История редактирований

  bool isSynced = false;
  DateTime? lastSyncedAt;

  late DateTime createdAt;
  DateTime? updatedAt;
}

@embedded
class Judge {
  String id = '';
  late String fullName;
  late String rank; // "Главный судья", "Судья", "Помощник судьи"
}

@embedded
class EditLog {
  String id = '';
  late DateTime timestamp;
  late String judgeId; // Кто редактировал
  late String action; // Описание действия
}