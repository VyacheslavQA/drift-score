import 'package:isar_community/isar.dart';

part 'protocol_local.g.dart';

@collection
class ProtocolLocal {
  Id id = Isar.autoIncrement;

  @Index()
  String? serverId;

  @Index()
  late String competitionId;

  // Тип протокола
  late String type; // 'weighing' | 'intermediate' | 'big_fish' | 'summary' | 'final'

  // Для протокола взвешивания и промежуточного
  String? weighingId;
  int? weighingNumber; // Номер взвешивания (1, 2, 3...)
  int? dayNumber; // День соревнования

  // Для Big Fish (номер суток)
  int? bigFishDay; // Сутки 1, 2, 3...

  // Дата и время формирования протокола
  late DateTime createdAt;

  // Данные протокола (JSON)
  late String dataJson;

  // Синхронизация
  bool isSynced = false;
  DateTime? lastSyncedAt;

  ProtocolLocal();
}