import 'package:isar_community/isar.dart';

part 'casting_result_local.g.dart';

@collection
class CastingResultLocal {
  Id id = Isar.autoIncrement;

  @Index()
  String? serverId;

  @Index()
  late int castingSessionId; // Ссылка на сессию кастинга

  @Index()
  late int participantId; // ID участника (индивидуальный)

  // ФИО участника (дублируем для быстрого доступа)
  late String participantFullName;

  // 3 попытки заброса
  List<CastingAttempt> attempts = [];

  // Автоматически вычисляемые поля
  late double bestDistance; // Лучший результат из 3 попыток (метры)
  late int validAttemptsCount; // Сколько попыток засчитано

  String? qrCode; // QR-код подтверждения (опционально)
  String? signatureBase64; // Подпись судьи (base64)

  late bool isSynced;
  DateTime? lastSyncedAt;

  late DateTime createdAt;
  late DateTime updatedAt;
}

@embedded
class CastingAttempt {
  late String id; // UUID
  late int attemptNumber; // Номер попытки (1, 2, 3)
  late double distance; // Дальность в метрах (например 45.50)
  late bool isValid; // Засчитан ли заброс (true/false)
  String? note; // Примечание (например "заступ", "обрыв")
  late DateTime timestamp; // Время попытки
}