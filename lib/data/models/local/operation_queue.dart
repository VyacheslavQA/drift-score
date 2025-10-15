import 'package:isar_community/isar.dart';

part 'operation_queue.g.dart';

@collection
class OperationQueue {
  Id id = Isar.autoIncrement;

  @Index()
  late String operationId;

  late String operationType;
  late String dataJson;

  late int retryCount;
  late DateTime createdAt;
  DateTime? lastAttemptAt;

  late bool isSynced;
  String? errorMessage;

  late int priority;
}