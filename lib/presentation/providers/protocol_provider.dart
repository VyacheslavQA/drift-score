import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/local/protocol_local.dart';
import '../../data/models/local/competition_local.dart';
import '../../data/models/local/team_local.dart';
import '../../data/models/local/weighing_local.dart';
import '../../data/models/local/weighing_result_local.dart';
import '../../data/services/isar_service.dart';

class ProtocolState {
  final List<ProtocolLocal> protocols;
  final bool isLoading;
  final String? error;

  ProtocolState({
    this.protocols = const [],
    this.isLoading = false,
    this.error,
  });

  ProtocolState copyWith({
    List<ProtocolLocal>? protocols,
    bool? isLoading,
    String? error,
  }) {
    return ProtocolState(
      protocols: protocols ?? this.protocols,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProtocolNotifier extends StateNotifier<ProtocolState> {
  final IsarService _isarService;

  ProtocolNotifier(this._isarService) : super(ProtocolState());

  // Функция перевода вида рыбы
  String _getFishTypeName(String fishType) {
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
        return fishType; // Если свой вариант
    }
  }

  Future<void> loadProtocols(int competitionId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final protocols = await _isarService.getProtocolsByCompetition(competitionId);
      state = state.copyWith(protocols: protocols, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<List<ProtocolLocal>> loadProtocolsByType(
      int competitionId,
      String type,
      ) async {
    try {
      return await _isarService.getProtocolsByType(competitionId, type);
    } catch (e) {
      print('❌ Error loading protocols by type: $e');
      return [];
    }
  }

  Future<ProtocolLocal?> generateWeighingProtocol(
      int competitionId,
      int weighingId,
      ) async {
    try {
      final competition = await _isarService.getCompetition(competitionId);
      final weighing = await _isarService.getWeighing(weighingId);
      final teams = await _isarService.getTeamsByCompetition(competitionId);
      final results = await _isarService.getResultsByWeighing(weighingId);

      if (competition == null || weighing == null) {
        print('❌ Competition or weighing not found');
        return null;
      }

      final sortedResults = [...results];
      sortedResults.sort((a, b) => b.totalWeight.compareTo(a.totalWeight));

      final List<Map<String, dynamic>> tableData = [];

      for (int i = 0; i < sortedResults.length; i++) {
        final result = sortedResults[i];
        final team = teams.firstWhere(
              (t) => t.id == result.teamLocalId,
          orElse: () => TeamLocal()..name = 'Unknown',
        );

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
          'city': competition.cityOrRegion,
          'lake': competition.lakeName,
          'organizer': competition.organizerName,
          'startTime': competition.startTime.toIso8601String(),
          'finishTime': competition.finishTime.toIso8601String(),
          'judges': competition.judges.map((j) => {
            'name': j.fullName,
            'rank': j.rank,
          }).toList(),
          'weighingNumber': weighing.weighingNumber,
          'dayNumber': weighing.dayNumber,
          'weighingTime': weighing.weighingTime.toIso8601String(),
          'tableData': tableData,
        });

      await _isarService.saveProtocol(protocol);
      print('✅ Weighing protocol generated: Day ${weighing.dayNumber}, #${weighing.weighingNumber}');

      return protocol;
    } catch (e) {
      print('❌ Error generating weighing protocol: $e');
      return null;
    }
  }

  Future<ProtocolLocal?> generateIntermediateProtocol(
      int competitionId,
      int upToWeighingNumber,
      ) async {
    try {
      final competition = await _isarService.getCompetition(competitionId);
      final teams = await _isarService.getTeamsByCompetition(competitionId);
      final allWeighings = await _isarService.getWeighingsByCompetition(competitionId);

      if (competition == null) {
        print('❌ Competition not found');
        return null;
      }

      final weighings = allWeighings
          .where((w) => w.weighingNumber <= upToWeighingNumber)
          .toList();

      if (weighings.isEmpty) {
        print('❌ No weighings found');
        return null;
      }

      final Map<int, Map<String, dynamic>> teamTotals = {};

      for (var team in teams) {
        teamTotals[team.id!] = {
          'teamName': team.name,
          'sector': team.sector ?? 0,
          'totalFishCount': 0,
          'totalWeight': 0.0,
          'biggestFish': 0.0,
        };
      }

      for (var weighing in weighings) {
        final results = await _isarService.getResultsByWeighing(weighing.id!);

        for (var result in results) {
          if (teamTotals.containsKey(result.teamLocalId)) {
            teamTotals[result.teamLocalId]!['totalFishCount'] += result.fishCount;
            teamTotals[result.teamLocalId]!['totalWeight'] += result.totalWeight;

            if (result.fishes.isNotEmpty) {
              final maxWeight = result.fishes
                  .map((c) => c.weight)
                  .reduce((a, b) => a > b ? a : b);

              if (maxWeight > teamTotals[result.teamLocalId]!['biggestFish']) {
                teamTotals[result.teamLocalId]!['biggestFish'] = maxWeight;
              }
            }
          }
        }
      }

      final sortedTeams = teamTotals.entries.toList()
        ..sort((a, b) => b.value['totalWeight'].compareTo(a.value['totalWeight']));

      final List<Map<String, dynamic>> tableData = [];

      for (int i = 0; i < sortedTeams.length; i++) {
        final entry = sortedTeams[i];
        tableData.add({
          'order': i + 1,
          'teamName': entry.value['teamName'],
          'sector': entry.value['sector'],
          'fishCount': entry.value['totalFishCount'],
          'totalWeight': entry.value['totalWeight'],
          'place': i + 1,
        });
      }

      String bigFishTeam = '';
      double bigFishWeight = 0.0;

      for (var entry in sortedTeams) {
        if (entry.value['biggestFish'] > bigFishWeight) {
          bigFishWeight = entry.value['biggestFish'];
          bigFishTeam = entry.value['teamName'];
        }
      }

      final protocol = ProtocolLocal()
        ..competitionId = competitionId.toString()
        ..type = 'intermediate'
        ..weighingNumber = upToWeighingNumber
        ..createdAt = DateTime.now()
        ..dataJson = jsonEncode({
          'competitionName': competition.name,
          'city': competition.cityOrRegion,
          'lake': competition.lakeName,
          'organizer': competition.organizerName,
          'startTime': competition.startTime.toIso8601String(),
          'finishTime': competition.finishTime.toIso8601String(),
          'judges': competition.judges.map((j) => {
            'name': j.fullName,
            'rank': j.rank,
          }).toList(),
          'weighingNumber': upToWeighingNumber,
          'weighingTime': weighings.last.weighingTime.toIso8601String(),
          'tableData': tableData,
          'bigFish': {
            'team': bigFishTeam,
            'weight': bigFishWeight,
          },
        });

      await _isarService.saveProtocol(protocol);
      print('✅ Intermediate protocol generated for weighing #$upToWeighingNumber');

      return protocol;
    } catch (e) {
      print('❌ Error generating intermediate protocol: $e');
      return null;
    }
  }

  Future<ProtocolLocal?> generateBigFishProtocol(
      int competitionId,
      int dayNumber,
      ) async {
    try {
      final competition = await _isarService.getCompetition(competitionId);
      final teams = await _isarService.getTeamsByCompetition(competitionId);
      final allWeighings = await _isarService.getWeighingsByCompetition(competitionId);

      if (competition == null) {
        print('❌ Competition not found');
        return null;
      }

      final startTime = competition.startTime;
      final dayStart = startTime.add(Duration(days: dayNumber - 1));
      final dayEnd = dayStart.add(Duration(days: 1));

      final dayWeighings = allWeighings
          .where((w) =>
      w.weighingTime.isAfter(dayStart) &&
          w.weighingTime.isBefore(dayEnd))
          .toList();

      if (dayWeighings.isEmpty) {
        print('❌ No weighings found for day $dayNumber');
        return null;
      }

      final List<Map<String, dynamic>> allFish = [];

      for (var weighing in dayWeighings) {
        final results = await _isarService.getResultsByWeighing(weighing.id!);

        for (var result in results) {
          final team = teams.firstWhere(
                (t) => t.id == result.teamLocalId,
            orElse: () => TeamLocal()..name = 'Unknown',
          );

          for (var fish in result.fishes) {
            allFish.add({
              'teamName': team.name,
              'fishType': _getFishTypeName(fish.fishType),
              'weight': fish.weight,
              'length': fish.length,
              'sector': team.sector ?? 0,
              'weighingTime': weighing.weighingTime.toIso8601String(),
            });
          }
        }
      }

      allFish.sort((a, b) => b['weight'].compareTo(a['weight']));

      final bigFishData = allFish.isNotEmpty ? allFish.first : null;

      if (bigFishData == null) {
        print('❌ No fish found for day $dayNumber');
        return null;
      }

      // ✅ ПРОВЕРЯЕМ: есть ли уже протокол Big Fish для этого дня?
      final existingProtocols = await _isarService.getProtocolsByCompetition(competitionId);
      final existingBigFish = existingProtocols.firstWhere(
            (p) => p.type == 'big_fish' && p.bigFishDay == dayNumber,
        orElse: () => ProtocolLocal(),
      );

      final protocolData = {
        'competitionName': competition.name,
        'city': competition.cityOrRegion,
        'lake': competition.lakeName,
        'organizer': competition.organizerName,
        'startTime': competition.startTime.toIso8601String(),
        'finishTime': competition.finishTime.toIso8601String(),
        'judges': competition.judges.map((j) => {
          'name': j.fullName,
          'rank': j.rank,
        }).toList(),
        'dayNumber': dayNumber,
        'dayStart': dayStart.toIso8601String(),
        'dayEnd': dayEnd.toIso8601String(),
        'bigFish': bigFishData,
      };

      ProtocolLocal protocol;

      if (existingBigFish.id != null) {
        // ✅ ОБНОВЛЯЕМ существующий протокол
        print('🔄 Updating existing Big Fish protocol for day $dayNumber (ID: ${existingBigFish.id})');
        protocol = existingBigFish
          ..dataJson = jsonEncode(protocolData)
          ..createdAt = DateTime.now(); // Обновляем время создания
      } else {
        // ✅ СОЗДАЁМ новый протокол
        print('➕ Creating new Big Fish protocol for day $dayNumber');
        protocol = ProtocolLocal()
          ..competitionId = competitionId.toString()
          ..type = 'big_fish'
          ..bigFishDay = dayNumber
          ..createdAt = DateTime.now()
          ..dataJson = jsonEncode(protocolData);
      }

      await _isarService.saveProtocol(protocol);

      if (existingBigFish.id != null) {
        print('✅ Big Fish protocol updated for day $dayNumber');
      } else {
        print('✅ Big Fish protocol created for day $dayNumber');
      }

      return protocol;
    } catch (e) {
      print('❌ Error generating Big Fish protocol: $e');
      return null;
    }
  }

  Future<ProtocolLocal?> generateSummaryProtocol(int competitionId) async {
    try {
      final competition = await _isarService.getCompetition(competitionId);
      final teams = await _isarService.getTeamsByCompetition(competitionId);
      final allWeighings = await _isarService.getWeighingsByCompetition(competitionId);

      if (competition == null || teams.isEmpty) {
        print('❌ Competition not found or no teams');
        return null;
      }

      final List<Map<String, dynamic>> summaryData = [];

      for (var team in teams) {
        final members = team.members.map((m) => {
          'fullName': m.fullName,
          'rank': m.rank.isEmpty || m.rank == 'none' ? 'б/р' : m.rank,
        }).toList();

        final Map<String, dynamic> teamData = {
          'teamName': team.name,
          'sector': team.sector ?? 0,
          'members': members,
          'weighings': <Map<String, dynamic>>[],
          'penalties': team.penalties.length,
          'totalFishCount': 0,
          'biggestFish': 0.0,
          'totalWeight': 0.0,
        };

        for (var weighing in allWeighings) {
          final results = await _isarService.getResultsByWeighing(weighing.id!);
          final teamResult = results.firstWhere(
                (r) => r.teamLocalId == team.id,
            orElse: () => WeighingResultLocal()
              ..fishCount = 0
              ..totalWeight = 0.0
              ..fishes = [],
          );

          teamData['weighings'].add({
            'weighingNumber': weighing.weighingNumber,
            'dayNumber': weighing.dayNumber,
            'weighingTime': weighing.weighingTime.toIso8601String(),
            'fishCount': teamResult.fishCount,
            'totalWeight': teamResult.totalWeight,
          });

          teamData['totalFishCount'] += teamResult.fishCount;
          teamData['totalWeight'] += teamResult.totalWeight;

          if (teamResult.fishes.isNotEmpty) {
            final maxWeight = teamResult.fishes
                .map((f) => f.weight)
                .reduce((a, b) => a > b ? a : b);
            if (maxWeight > teamData['biggestFish']) {
              teamData['biggestFish'] = maxWeight;
            }
          }
        }

        summaryData.add(teamData);
      }

      summaryData.sort((a, b) => b['totalWeight'].compareTo(a['totalWeight']));

      for (int i = 0; i < summaryData.length; i++) {
        summaryData[i]['place'] = i + 1;
      }

      final protocol = ProtocolLocal()
        ..competitionId = competitionId.toString()
        ..type = 'summary'
        ..createdAt = DateTime.now()
        ..dataJson = jsonEncode({
          'competitionName': competition.name,
          'city': competition.cityOrRegion,
          'lake': competition.lakeName,
          'organizer': competition.organizerName,
          'startTime': competition.startTime.toIso8601String(),
          'finishTime': competition.finishTime.toIso8601String(),
          'judges': competition.judges.map((j) => {
            'name': j.fullName,
            'rank': j.rank,
          }).toList(),
          'summaryData': summaryData,
        });

      await _isarService.saveProtocol(protocol);
      print('✅ Summary protocol generated');

      return protocol;
    } catch (e) {
      print('❌ Error generating summary protocol: $e');
      return null;
    }
  }

  Future<ProtocolLocal?> generateFinalProtocol(int competitionId) async {
    try {
      final competition = await _isarService.getCompetition(competitionId);

      if (competition == null) {
        print('❌ Competition not found');
        return null;
      }

      final teams = await _isarService.getTeamsByCompetition(competitionId);
      final allWeighings = await _isarService.getWeighingsByCompetition(competitionId);

      if (teams.isEmpty) {
        print('❌ No teams found');
        return null;
      }

      final Map<int, Map<String, dynamic>> teamTotals = {};

      for (var team in teams) {
        teamTotals[team.id!] = {
          'teamName': team.name,
          'city': team.city,
          'club': team.club,
          'sector': team.sector ?? 0,
          'members': team.members.map((m) => {
            'fullName': m.fullName,
            'rank': m.rank.isEmpty || m.rank == 'none' ? 'б/р' : m.rank,
            'isCaptain': m.isCaptain,
          }).toList(),
          'totalFishCount': 0,
          'totalWeight': 0.0,
          'biggestFish': 0.0,
          'penalties': team.penalties.length,
        };
      }

      for (var weighing in allWeighings) {
        final results = await _isarService.getResultsByWeighing(weighing.id!);
        for (var result in results) {
          if (teamTotals.containsKey(result.teamLocalId)) {
            teamTotals[result.teamLocalId]!['totalFishCount'] += result.fishCount;
            teamTotals[result.teamLocalId]!['totalWeight'] += result.totalWeight;
            if (result.fishes.isNotEmpty) {
              final maxWeight = result.fishes
                  .map((f) => f.weight)
                  .reduce((a, b) => a > b ? a : b);
              if (maxWeight > teamTotals[result.teamLocalId]!['biggestFish']) {
                teamTotals[result.teamLocalId]!['biggestFish'] = maxWeight;
              }
            }
          }
        }
      }

      final sortedTeams = teamTotals.entries.toList()
        ..sort((a, b) => b.value['totalWeight'].compareTo(a.value['totalWeight']));

      final List<Map<String, dynamic>> finalData = [];
      for (int i = 0; i < sortedTeams.length; i++) {
        final entry = sortedTeams[i];
        finalData.add({
          'place': i + 1,
          'teamName': entry.value['teamName'],
          'city': entry.value['city'],
          'club': entry.value['club'],
          'sector': entry.value['sector'],
          'members': entry.value['members'],
          'totalFishCount': entry.value['totalFishCount'],
          'totalWeight': entry.value['totalWeight'],
          'biggestFish': entry.value['biggestFish'],
          'penalties': entry.value['penalties'],
        });
      }

      final protocol = ProtocolLocal()
        ..competitionId = competitionId.toString()
        ..type = 'final'
        ..createdAt = DateTime.now()
        ..dataJson = jsonEncode({
          'competitionName': competition.name,
          'city': competition.cityOrRegion,
          'lake': competition.lakeName,
          'organizer': competition.organizerName,
          'startTime': competition.startTime.toIso8601String(),
          'finishTime': competition.finishTime.toIso8601String(),
          'judges': competition.judges.map((j) => {
            'name': j.fullName,
            'rank': j.rank,
          }).toList(),
          'finalData': finalData,
        });

      await _isarService.saveProtocol(protocol);
      print('✅ Final protocol generated');

      return protocol;
    } catch (e) {
      print('❌ Error generating final protocol: $e');
      return null;
    }
  }

  Future<void> deleteProtocol(int id) async {
    try {
      await _isarService.deleteProtocol(id);
      final updatedProtocols = state.protocols.where((p) => p.id != id).toList();
      state = state.copyWith(protocols: updatedProtocols);
      print('✅ Protocol deleted: $id');
    } catch (e) {
      print('❌ Error deleting protocol: $e');
    }
  }
}

final protocolProvider = StateNotifierProvider<ProtocolNotifier, ProtocolState>((ref) {
  return ProtocolNotifier(IsarService());
});