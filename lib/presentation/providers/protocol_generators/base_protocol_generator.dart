import 'package:intl/intl.dart';
import '../../../data/models/local/protocol_local.dart';
import '../../../data/services/isar_service.dart';
import '../../../data/services/sync_service.dart';

/// Базовый класс для генераторов протоколов
/// Содержит ТОЛЬКО общие методы, используемые ВСЕМИ типами генераторов
abstract class BaseProtocolGenerator {
  final IsarService isarService;
  final SyncService syncService;

  BaseProtocolGenerator(this.isarService, this.syncService);

  // ========== УТИЛИТЫ ДЛЯ РАБОТЫ С ДАННЫМИ ==========

  /// Получить serverId соревнования для синхронизации
  Future<String?> getCompetitionServerId(int competitionId) async {
    final competition = await isarService.getCompetition(competitionId);
    return competition?.serverId;
  }

  /// Синхронизировать протокол с Firebase
  Future<void> syncProtocolToFirebase(ProtocolLocal protocol, int competitionId) async {
    final competitionServerId = await getCompetitionServerId(competitionId);
    if (competitionServerId != null && competitionServerId.isNotEmpty) {
      try {
        await syncService.syncProtocolToFirebase(protocol, competitionServerId);
        print('✅ Protocol synced to Firebase');
      } catch (e) {
        print('⚠️ Error syncing protocol (will retry later): $e');
      }
    }
  }

  // ========== ФОРМАТИРОВАНИЕ (ИСПОЛЬЗУЕТСЯ ВЕЗДЕ) ==========

  /// Форматировать даты соревнования
  String formatCompetitionDates(DateTime startTime, DateTime finishTime) {
    final start = DateFormat('dd.MM.yyyy').format(startTime);
    final finish = DateFormat('dd.MM.yyyy').format(finishTime);
    return start == finish ? start : '$start - $finish';
  }

  /// Получить ключ для даты (для локализации)
  String getDateKey(DateTime startTime, DateTime finishTime) {
    final start = DateFormat('dd.MM.yyyy').format(startTime);
    final finish = DateFormat('dd.MM.yyyy').format(finishTime);
    return start == finish ? 'competition_date_single' : 'competition_dates_multiple';
  }

  /// Форматировать место проведения (город, озеро)
  String formatVenue(String? city, String? venue) {
    final parts = <String>[];
    if (city != null && city.isNotEmpty) parts.add('г. $city');
    if (venue != null && venue.isNotEmpty) parts.add('оз. $venue');
    return parts.join(', ');
  }

  /// Перевести разряд судьи (используется везде для judges)
  String translateRank(String rank) {
    if (rank.isEmpty || rank == 'none') return 'б/р';
    switch (rank) {
      case '3':
        return '3 разряд';
      case '2':
        return '2 разряд';
      case '1':
        return '1 разряд';
      case 'kms':
        return 'КМС';
      case 'ms':
        return 'МС';
      case 'msmk':
        return 'МСМК';
      default:
        return rank;
    }
  }
}