import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/local/competition_local.dart';
import '../models/local/team_local.dart';
import '../models/local/weighing_local.dart';
import '../models/local/result_local.dart';
import '../models/local/operation_queue.dart';

class IsarService {
  static Isar? _isar;

  /// Получить инстанс Isar (singleton)
  static Future<Isar> getInstance() async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }

    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [
        CompetitionLocalSchema,
        TeamLocalSchema,
        WeighingLocalSchema,
        ResultLocalSchema,
        OperationQueueSchema,
      ],
      directory: dir.path,
      name: 'drift_score',
    );

    return _isar!;
  }

  /// Закрыть Isar (при необходимости)
  static Future<void> close() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
      _isar = null;
    }
  }
}