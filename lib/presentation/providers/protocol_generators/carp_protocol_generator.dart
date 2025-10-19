import 'dart:convert';
import '../../../data/models/local/protocol_local.dart';
import '../../../data/models/local/team_local.dart';
import '../../../data/services/isar_service.dart';
import '../../../data/services/sync_service.dart';
import 'base_protocol_generator.dart';

/// Генератор протоколов для карповой рыбалки
/// Генерирует: weighing, intermediate, bigFish, summary, final, draw протоколы
class CarpProtocolGenerator extends BaseProtocolGenerator {
  CarpProtocolGenerator(IsarService isarService, SyncService syncService)
      : super(isarService, syncService);

  // ========== СПЕЦИФИЧНЫЕ МЕТОДЫ ДЛЯ РЫБАЛКИ ==========

  /// Получить название типа рыбы (используется только в рыбалке)
  String getFishTypeName(String fishType) {
    switch (fishType.toLowerCase()) {
      case 'carp':
        return 'Карп';
      case 'mirror_carp':
        return 'Зеркальный карп';
      case 'grass_carp':
        return 'Амур';
      case 'silver_carp':
        return 'Толстолобик';
      case 'other':
        return 'Другое';
      default:
        return fishType;
    }
  }

  // ========== ПРОТОКОЛ ВЗВЕШИВАНИЯ ==========

  Future<ProtocolLocal?> generateWeighingProtocol(
      int competitionId, int weighingId) async {
    try {
      print('🎯 Generating weighing protocol for weighing #$weighingId');

      // ✅ Проверка на существование протокола
      final existingProtocols =
      await isarService.getProtocolsByType(competitionId, 'weighing');
      final existingProtocol = existingProtocols
          .where((p) => p.weighingId == weighingId.toString())
          .firstOrNull;

      if (existingProtocol != null) {
        print(
            'ℹ️ Weighing protocol for weighing #$weighingId already exists (id=${existingProtocol.id})');
        return existingProtocol;
      }

      final competition = await isarService.getCompetition(competitionId);
      final weighing = await isarService.getWeighing(weighingId);
      final teams = await isarService.getTeamsByCompetition(competitionId);
      final results = await isarService.getResultsByWeighing(weighingId);
      if (competition == null || weighing == null) return null;

      final sortedResults = [...results];
      sortedResults.sort((a, b) => b.totalWeight.compareTo(a.totalWeight));

      final List<Map<String, dynamic>> tableData = [];
      for (int i = 0; i < sortedResults.length; i++) {
        final result = sortedResults[i];
        final team = teams.firstWhere((t) => t.id == result.teamLocalId,
            orElse: () => TeamLocal()..name = 'Unknown');
        tableData.add({
          'order': i + 1,
          'teamName': team.name,
          'sector': team.sector ?? 0,
          'fishCount': result.fishCount,
          'totalWeight': result.totalWeight,
        });
      }

      final protocol = ProtocolLocal()
        ..competitionId = competitionId.toString()
        ..type = 'weighing'
        ..weighingId = weighingId.toString()
        ..weighingNumber = weighing.weighingNumber
        ..dayNumber = weighing.dayNumber
        ..createdAt = DateTime.now()
        ..dataJson = jsonEncode({
          'competitionName': competition.name,
          'fishingType': competition.fishingType,
          'city': competition.cityOrRegion,
          'lake': competition.lakeName,
          'venueFormatted':
          formatVenue(competition.cityOrRegion, competition.lakeName),
          'competitionDates':
          formatCompetitionDates(competition.startTime, competition.finishTime),
          'dateKey': getDateKey(competition.startTime, competition.finishTime),
          'organizer': competition.organizerName,
          'startTime': competition.startTime.toIso8601String(),
          'finishTime': competition.finishTime.toIso8601String(),
          'judges': competition.judges
              .map((j) => {'name': j.fullName, 'rank': translateRank(j.rank)})
              .toList(),
          'weighingNumber': weighing.weighingNumber,
          'dayNumber': weighing.dayNumber,
          'weighingTime': weighing.weighingTime.toIso8601String(),
          'tableData': tableData,
        });

      await isarService.saveProtocol(protocol);
      await syncProtocolToFirebase(protocol, competitionId);
      print('✅ Weighing protocol generated');
      return protocol;
    } catch (e) {
      print('❌ Error generating weighing protocol: $e');
      return null;
    }
  }

  // ========== ПРОМЕЖУТОЧНЫЙ ПРОТОКОЛ ==========

  Future<ProtocolLocal?> generateIntermediateProtocol(
      int competitionId, int upToWeighingNumber) async {
    try {
      print('🎯 Generating intermediate protocol up to weighing #$upToWeighingNumber');

      // ✅ Проверка на существование
      final existingProtocols =
      await isarService.getProtocolsByType(competitionId, 'intermediate');
      final existingProtocol = existingProtocols
          .where((p) => p.weighingNumber == upToWeighingNumber)
          .firstOrNull;

      if (existingProtocol != null) {
        print(
            'ℹ️ Intermediate protocol up to weighing #$upToWeighingNumber already exists (id=${existingProtocol.id})');
        return existingProtocol;
      }

      final competition = await isarService.getCompetition(competitionId);
      final teams = await isarService.getTeamsByCompetition(competitionId);
      if (competition == null || teams.isEmpty) return null;

      final weighings = await isarService.getWeighingsByCompetition(competitionId);
      final relevantWeighings =
      weighings.where((w) => w.weighingNumber <= upToWeighingNumber).toList();

      if (relevantWeighings.isEmpty) return null;

      // Собираем результаты по командам
      final Map<int, Map<String, dynamic>> teamResults = {};
      for (var team in teams) {
        teamResults[team.id!] = {
          'teamName': team.name,
          'sector': team.sector ?? 0,
          'totalWeight': 0.0,
          'totalFishCount': 0,
        };
      }

      for (var weighing in relevantWeighings) {
        final results = await isarService.getResultsByWeighing(weighing.id);
        for (var result in results) {
          if (teamResults.containsKey(result.teamLocalId)) {
            teamResults[result.teamLocalId]!['totalWeight'] += result.totalWeight;
            teamResults[result.teamLocalId]!['totalFishCount'] += result.fishCount;
          }
        }
      }

      final sortedTeams = teamResults.values.toList();
      sortedTeams.sort((a, b) =>
          (b['totalWeight'] as double).compareTo(a['totalWeight'] as double));

      final List<Map<String, dynamic>> tableData = [];
      for (int i = 0; i < sortedTeams.length; i++) {
        final team = sortedTeams[i];
        tableData.add({
          'order': i + 1,
          'teamName': team['teamName'],
          'sector': team['sector'],
          'fishCount': team['totalFishCount'],
          'totalWeight': team['totalWeight'],
          'place': i + 1, // ✅ ИСПРАВЛЕНО: Добавлено поле place
        });
      }

      final protocol = ProtocolLocal()
        ..competitionId = competitionId.toString()
        ..type = 'intermediate'
        ..weighingNumber = upToWeighingNumber
        ..createdAt = DateTime.now()
        ..dataJson = jsonEncode({
          'competitionName': competition.name,
          'fishingType': competition.fishingType,
          'city': competition.cityOrRegion,
          'lake': competition.lakeName,
          'venueFormatted':
          formatVenue(competition.cityOrRegion, competition.lakeName),
          'competitionDates':
          formatCompetitionDates(competition.startTime, competition.finishTime),
          'dateKey': getDateKey(competition.startTime, competition.finishTime),
          'organizer': competition.organizerName,
          'upToWeighingNumber': upToWeighingNumber,
          'judges': competition.judges
              .map((j) => {'name': j.fullName, 'rank': translateRank(j.rank)})
              .toList(),
          'tableData': tableData,
        });

      await isarService.saveProtocol(protocol);
      await syncProtocolToFirebase(protocol, competitionId);
      print('✅ Intermediate protocol generated');
      return protocol;
    } catch (e) {
      print('❌ Error generating intermediate protocol: $e');
      return null;
    }
  }

  // ========== ПРОТОКОЛ БОЛЬШОЙ РЫБЫ ==========

  Future<ProtocolLocal?> generateBigFishProtocol(
      int competitionId, int dayNumber) async {
    try {
      print('🎯 Generating big fish protocol for day #$dayNumber');

      // ✅ Проверка на существование
      final existingProtocols =
      await isarService.getProtocolsByType(competitionId, 'big_fish');
      final existingProtocol =
          existingProtocols.where((p) => p.dayNumber == dayNumber).firstOrNull;

      if (existingProtocol != null) {
        print(
            'ℹ️ Big fish protocol for day #$dayNumber already exists (id=${existingProtocol.id})');
        return existingProtocol;
      }

      final competition = await isarService.getCompetition(competitionId);
      final teams = await isarService.getTeamsByCompetition(competitionId);
      if (competition == null || teams.isEmpty) return null;

      final weighings = await isarService.getWeighingsByCompetition(competitionId);
      final dayWeighings = weighings.where((w) => w.dayNumber == dayNumber).toList();

      if (dayWeighings.isEmpty) return null;

      // ✅ ИСПРАВЛЕНО: Ищем ОДНУ самую большую рыбу за день
      Map<String, dynamic>? biggestFish;
      double maxWeight = 0.0;

      for (var weighing in dayWeighings) {
        final results = await isarService.getResultsByWeighing(weighing.id);
        for (var result in results) {
          final team = teams.firstWhere((t) => t.id == result.teamLocalId,
              orElse: () => TeamLocal()..name = 'Unknown');

          for (var fish in result.fishes) {
            if (fish.weight > maxWeight) {
              maxWeight = fish.weight;
              biggestFish = {
                'teamName': team.name ?? 'Unknown', // ✅ Добавлена проверка на null
                'sector': team.sector ?? 0,
                'fishType': getFishTypeName(fish.fishType ?? ''), // ✅ Добавлена проверка на null
                'weight': fish.weight,
                'length': fish.length ?? 0,
                'weighingTime': weighing.weighingTime.toIso8601String(),
              };
            }
          }
        }
      }

      // Если не найдено ни одной рыбы
      if (biggestFish == null) {
        print('⚠️ No fish found for day #$dayNumber');
        return null;
      }

      final protocol = ProtocolLocal()
        ..competitionId = competitionId.toString()
        ..type = 'big_fish'
        ..dayNumber = dayNumber
        ..createdAt = DateTime.now()
        ..dataJson = jsonEncode({
          'competitionName': competition.name,
          'fishingType': competition.fishingType,
          'city': competition.cityOrRegion,
          'lake': competition.lakeName,
          'venueFormatted':
          formatVenue(competition.cityOrRegion, competition.lakeName),
          'competitionDates':
          formatCompetitionDates(competition.startTime, competition.finishTime),
          'dateKey': getDateKey(competition.startTime, competition.finishTime),
          'organizer': competition.organizerName,
          'dayNumber': dayNumber,
          'judges': competition.judges
              .map((j) => {'name': j.fullName, 'rank': translateRank(j.rank)})
              .toList(),
          'bigFish': biggestFish, // ✅ ИСПРАВЛЕНО: Один объект вместо массива topFish
        });

      await isarService.saveProtocol(protocol);
      await syncProtocolToFirebase(protocol, competitionId);
      print('✅ Big fish protocol generated');
      return protocol;
    } catch (e) {
      print('❌ Error generating big fish protocol: $e');
      return null;
    }
  }

  // ========== СВОДНЫЙ ПРОТОКОЛ ==========

  Future<ProtocolLocal?> generateSummaryProtocol(int competitionId) async {
    try {
      print('🎯 Generating summary protocol');

      // ✅ Проверка на существование
      final existingProtocols =
      await isarService.getProtocolsByType(competitionId, 'summary');
      if (existingProtocols.isNotEmpty) {
        print('ℹ️ Summary protocol already exists (id=${existingProtocols.first.id})');
        return existingProtocols.first;
      }

      final competition = await isarService.getCompetition(competitionId);
      final teams = await isarService.getTeamsByCompetition(competitionId);
      if (competition == null || teams.isEmpty) return null;

      final weighings = await isarService.getWeighingsByCompetition(competitionId);
      if (weighings.isEmpty) return null;

      // ✅ ИСПРАВЛЕНО: Собираем результаты с учётом members, biggestFish, penalties
      final Map<int, Map<String, dynamic>> teamResults = {};
      for (var team in teams) {
        teamResults[team.id!] = {
          'teamName': team.name,
          'sector': team.sector ?? 0,
          'members': team.members
              .map((m) => {
            'fullName': m.fullName,
            'rank': translateRank(m.rank),
          })
              .toList(),
          'dayResults': <Map<String, dynamic>>[],
          'totalWeight': 0.0,
          'totalFishCount': 0,
          'biggestFish': 0.0, // ✅ ДОБАВЛЕНО
          'penalties': 0, // ✅ ДОБАВЛЕНО
        };
      }

      // Группируем взвешивания по дням
      final dayNumbers = weighings.map((w) => w.dayNumber).toSet().toList()..sort();

      for (var dayNumber in dayNumbers) {
        final dayWeighings = weighings.where((w) => w.dayNumber == dayNumber).toList();

        for (var team in teams) {
          double dayWeight = 0.0;
          int dayFishCount = 0;

          for (var weighing in dayWeighings) {
            final results = await isarService.getResultsByWeighing(weighing.id);
            final teamResult = results.where((r) => r.teamLocalId == team.id).firstOrNull;
            if (teamResult != null) {
              dayWeight += teamResult.totalWeight;
              dayFishCount += teamResult.fishCount;

              // ✅ ИСПРАВЛЕНО: Находим самую большую рыбу команды
              for (var fish in teamResult.fishes) {
                if (fish.weight > teamResults[team.id]!['biggestFish']) {
                  teamResults[team.id]!['biggestFish'] = fish.weight;
                }
              }
            }
          }

          teamResults[team.id]!['dayResults'].add({
            'dayNumber': dayNumber,
            'weight': dayWeight,
            'fishCount': dayFishCount,
          });
          teamResults[team.id]!['totalWeight'] += dayWeight;
          teamResults[team.id]!['totalFishCount'] += dayFishCount;
        }
      }

      final sortedTeams = teamResults.values.toList();
      sortedTeams.sort((a, b) =>
          (b['totalWeight'] as double).compareTo(a['totalWeight'] as double));

      // ✅ ИСПРАВЛЕНО: Изменён ключ с tableData на summaryData
      final List<Map<String, dynamic>> summaryData = [];
      for (int i = 0; i < sortedTeams.length; i++) {
        final team = sortedTeams[i];
        summaryData.add({
          'order': i + 1,
          'teamName': team['teamName'],
          'sector': team['sector'],
          'members': team['members'], // ✅ ДОБАВЛЕНО
          'dayResults': team['dayResults'],
          'totalWeight': team['totalWeight'],
          'totalFishCount': team['totalFishCount'],
          'biggestFish': team['biggestFish'], // ✅ ДОБАВЛЕНО
          'penalties': team['penalties'], // ✅ ДОБАВЛЕНО
          'place': i + 1, // ✅ ДОБАВЛЕНО
        });
      }

      final protocol = ProtocolLocal()
        ..competitionId = competitionId.toString()
        ..type = 'summary'
        ..createdAt = DateTime.now()
        ..dataJson = jsonEncode({
          'competitionName': competition.name,
          'fishingType': competition.fishingType,
          'city': competition.cityOrRegion,
          'lake': competition.lakeName,
          'venueFormatted':
          formatVenue(competition.cityOrRegion, competition.lakeName),
          'competitionDates':
          formatCompetitionDates(competition.startTime, competition.finishTime),
          'dateKey': getDateKey(competition.startTime, competition.finishTime),
          'organizer': competition.organizerName,
          'dayCount': dayNumbers.length,
          'judges': competition.judges
              .map((j) => {'name': j.fullName, 'rank': translateRank(j.rank)})
              .toList(),
          'summaryData': summaryData, // ✅ ИСПРАВЛЕНО: Изменён ключ
        });

      await isarService.saveProtocol(protocol);
      await syncProtocolToFirebase(protocol, competitionId);
      print('✅ Summary protocol generated');
      return protocol;
    } catch (e) {
      print('❌ Error generating summary protocol: $e');
      return null;
    }
  }

  // ========== ФИНАЛЬНЫЙ ПРОТОКОЛ ==========

  Future<ProtocolLocal?> generateFinalProtocol(int competitionId) async {
    try {
      print('🎯 Generating final protocol');

      // ✅ Проверка на существование
      final existingProtocols =
      await isarService.getProtocolsByType(competitionId, 'final');
      if (existingProtocols.isNotEmpty) {
        print('ℹ️ Final protocol already exists (id=${existingProtocols.first.id})');
        return existingProtocols.first;
      }

      final competition = await isarService.getCompetition(competitionId);
      final teams = await isarService.getTeamsByCompetition(competitionId);
      if (competition == null || teams.isEmpty) return null;

      final weighings = await isarService.getWeighingsByCompetition(competitionId);
      if (weighings.isEmpty) return null;

      // ✅ ИСПРАВЛЕНО: Собираем результаты с полными данными для финального протокола
      final Map<int, Map<String, dynamic>> teamResults = {};
      for (var team in teams) {
        teamResults[team.id!] = {
          'teamName': team.name,
          'city': team.city ?? '', // ✅ ДОБАВЛЕНО
          'club': team.club ?? '', // ✅ ДОБАВЛЕНО
          'sector': team.sector ?? 0,
          'members': team.members
              .map((m) => {
            'fullName': m.fullName,
            'rank': translateRank(m.rank),
          })
              .toList(),
          'totalWeight': 0.0,
          'totalFishCount': 0,
          'biggestFish': 0.0, // ✅ ДОБАВЛЕНО
          'penalties': 0, // ✅ ДОБАВЛЕНО
        };
      }

      // Собираем все результаты
      for (var weighing in weighings) {
        final results = await isarService.getResultsByWeighing(weighing.id);
        for (var result in results) {
          if (teamResults.containsKey(result.teamLocalId)) {
            teamResults[result.teamLocalId]!['totalWeight'] += result.totalWeight;
            teamResults[result.teamLocalId]!['totalFishCount'] += result.fishCount;

            // ✅ ИСПРАВЛЕНО: Находим самую большую рыбу команды
            for (var fish in result.fishes) {
              if (fish.weight > teamResults[result.teamLocalId]!['biggestFish']) {
                teamResults[result.teamLocalId]!['biggestFish'] = fish.weight;
              }
            }
          }
        }
      }

      final sortedTeams = teamResults.values.toList();
      sortedTeams.sort((a, b) =>
          (b['totalWeight'] as double).compareTo(a['totalWeight'] as double));

      // ✅ ИСПРАВЛЕНО: Создаём finalData с полными данными
      final List<Map<String, dynamic>> finalData = [];
      for (int i = 0; i < sortedTeams.length; i++) {
        final team = sortedTeams[i];
        finalData.add({
          'order': i + 1,
          'teamName': team['teamName'],
          'city': team['city'], // ✅ ДОБАВЛЕНО
          'club': team['club'], // ✅ ДОБАВЛЕНО
          'sector': team['sector'],
          'members': team['members'], // ✅ ДОБАВЛЕНО
          'totalWeight': team['totalWeight'],
          'totalFishCount': team['totalFishCount'],
          'biggestFish': team['biggestFish'], // ✅ ДОБАВЛЕНО
          'penalties': team['penalties'], // ✅ ДОБАВЛЕНО
          'place': i + 1, // ✅ ДОБАВЛЕНО
        });
      }

      final protocol = ProtocolLocal()
        ..competitionId = competitionId.toString()
        ..type = 'final'
        ..createdAt = DateTime.now()
        ..dataJson = jsonEncode({
          'competitionName': competition.name,
          'fishingType': competition.fishingType,
          'city': competition.cityOrRegion,
          'lake': competition.lakeName,
          'venueFormatted':
          formatVenue(competition.cityOrRegion, competition.lakeName),
          'competitionDates':
          formatCompetitionDates(competition.startTime, competition.finishTime),
          'dateKey': getDateKey(competition.startTime, competition.finishTime),
          'organizer': competition.organizerName,
          'judges': competition.judges
              .map((j) => {'name': j.fullName, 'rank': translateRank(j.rank)})
              .toList(),
          'finalData': finalData, // ✅ ИСПРАВЛЕНО: Создаём finalData вместо копирования summaryData
        });

      await isarService.saveProtocol(protocol);
      await syncProtocolToFirebase(protocol, competitionId);
      print('✅ Final protocol generated');
      return protocol;
    } catch (e) {
      print('❌ Error generating final protocol: $e');
      return null;
    }
  }
}