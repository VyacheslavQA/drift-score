import 'package:isar_community/isar.dart';

part 'weighing_result_local.g.dart';

@collection
class WeighingResultLocal {
  Id id = Isar.autoIncrement;

  @Index()
  String? serverId;

  @Index()
  late int weighingLocalId; // Ссылка на WeighingLocal

  @Index()
  late int teamLocalId; // Какая команда

  List<FishCatch> fishes = []; // Список рыб

  late double totalWeight; // Общий вес (автоматически)
  late double averageWeight; // Средний вес (автоматически)
  late int fishCount; // Количество рыб (автоматически)

  String? qrCode; // QR-код подтверждения
  String? signatureBase64; // Подпись (base64)

  // --- INSERT START: Поля для зимней мормышки (зональная система) ---
  int? placeInZone;  // Место в зоне (1, 2, 3, 4, ... без ограничения)
  int? memberIndex;  // Индекс участника команды (0, 1, 2)
  String? zone;      // Зона участника (A, B, C)
  // --- INSERT END ---

  late bool isSynced;
  DateTime? lastSyncedAt;

  late DateTime createdAt;
  late DateTime updatedAt;
}

@embedded
class FishCatch {
  late String id; // UUID
  late String fishType; // Вид рыбы (карп, сазан, амур и т.д.)
  late double weight; // кг (например 2.350)
  late double length; // см (например 45.5)
}