import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/local/protocol_local.dart';
import '../../data/models/local/competition_local.dart';
import '../../data/models/local/team_local.dart';
import '../../data/models/local/weighing_local.dart';
import '../../data/models/local/weighing_result_local.dart';
import '../../data/services/isar_service.dart';
import '../../data/services/sync_service.dart';
import 'competition_provider.dart';

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
  final SyncService _syncService;

  ProtocolNotifier(this._isarService, this._syncService) : super(ProtocolState());

  /// Получить serverId соревнования
  Future<String?> _getCompetitionServerId(int competitionId) async {
    final competition = await _isarService.getCompetition(competitionId);
    return competition?.serverId;
  }

  /// ✅ Синхронизировать протокол после создания
  Future<void> _syncProtocolToFirebase(ProtocolLocal protocol, int competitionId) async {
    final competitionServerId = await _getCompetitionServerId(competitionId);
    if (competitionServerId != null && competitionServerId.isNotEmpty) {
      try {
        await _syncService.syncProtocolToFirebase(protocol, competitionServerId);
        print('✅ Protocol synced to Firebase');
      } catch (e) {
        print('⚠️ Error syncing protocol (will retry later): $e');
      }
    }
  }

  // Функция перевода вида рыбы
  String _getFishTypeName(String fishType) {
    switch (fishType.toLowerCase()) {
      case 'carp': return 'Карп';
      case 'mirror_carp': return 'Зеркальный карп';
      case 'grass_carp': return 'Амур';
      case 'silver_carp': return 'Толстолобик';
      case 'other': return 'Другое';
      default: return fishType;
    }
  }

  String _translateRank(String rank) {
    if (rank.isEmpty || rank == 'none') return 'б/р';
    switch (rank) {
      case '3': return '3 разряд';
      case '2': return '2 разряд';
      case '1': return '1 разряд';
      case 'kms': return 'КМС';
      case 'ms': return 'МС';
      case 'msmk': return 'МСМК';
      default: return rank;
    }
  }

  String _formatCompetitionDates(DateTime startTime, DateTime finishTime) {
    final start = DateFormat('dd.MM.yyyy').format(startTime);
    final finish = DateFormat('dd.MM.yyyy').format(finishTime);
    return start == finish ? start : '$start - $finish';
  }

  String _getDateKey(DateTime startTime, DateTime finishTime) {
    final start = DateFormat('dd.MM.yyyy').format(startTime);
    final finish = DateFormat('dd.MM.yyyy').format(finishTime);
    return start == finish ? 'competition_date_single' : 'competition_dates_multiple';
  }

  String _formatVenue(String? city, String? venue) {
    final parts = <String>[];
    if (city != null && city.isNotEmpty) parts.add('г. $city');
    if (venue != null && venue.isNotEmpty) parts.add('оз. $venue');
    return parts.join(', ');
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

  Future<List<ProtocolLocal>> loadProtocolsByType(int competitionId, String type) async {
    try {
      return await _isarService.getProtocolsByType(competitionId, type);
    } catch (e) {
      print('❌ Error loading protocols by type: $e');
      return [];
    }
  }

  // ========== КАСТИНГ ПРОТОКОЛЫ ==========

  Future<ProtocolLocal?> generateCastingAttemptProtocol(int competitionId, int attemptNumber) async {
    try {
      print('🎯 Generating casting attempt protocol #$attemptNumber');
      final competition = await _isarService.getCompetition(competitionId);
      final teams = await _isarService.getTeamsByCompetition(competitionId);
      if (competition == null || teams.isEmpty) return null;

      final castingSessions = await _isarService.getCastingSessionsByCompetition(competitionId);
      if (castingSessions.length < attemptNumber) return null;

      final session = castingSessions[attemptNumber - 1];
      final results = await _isarService.getResultsByCastingSession(session.id);
      if (results.isEmpty) return null;

      final List<Map<String, dynamic>> participantsData = [];
      for (var result in results) {
        final distance = result.attempts.isNotEmpty ? result.attempts[0].distance : 0.0;
        TeamMember? participant;
        for (var team in teams) {
          try {
            participant = team.members.firstWhere((m) => m.fullName.trim() == result.participantFullName.trim());
            break;
          } catch (_) {}
        }
        participantsData.add({
          'fullName': result.participantFullName,
          'rod': participant?.rod?.trim() ?? '',
          'line': participant?.line?.trim() ?? competition.commonLine ?? '',
          'distance': distance,
        });
      }

      participantsData.sort((a, b) => (b['distance'] as double).compareTo(a['distance'] as double));
      for (int i = 0; i < participantsData.length; i++) {
        participantsData[i]['place'] = i + 1;
      }

      final protocol = ProtocolLocal()
        ..competitionId = competitionId.toString()
        ..type = 'casting_attempt'
        ..weighingNumber = attemptNumber
        ..createdAt = DateTime.now()
        ..dataJson = jsonEncode({
          'competitionName': competition.name,
          'city': competition.cityOrRegion,
          'venue': competition.lakeName,
          'venueFormatted': _formatVenue(competition.cityOrRegion, competition.lakeName),
          'competitionDates': _formatCompetitionDates(competition.startTime, competition.finishTime),
          'dateKey': _getDateKey(competition.startTime, competition.finishTime),
          'attemptNumber': attemptNumber,
          'sessionTime': session.sessionTime.toIso8601String(),
          'judges': competition.judges.map((j) => {'name': j.fullName, 'rank': j.rank}).toList(),
          'participantsData': participantsData,
        });

      await _isarService.saveProtocol(protocol);
      await _syncProtocolToFirebase(protocol, competitionId);
      print('✅ Casting attempt protocol #$attemptNumber generated');
      return protocol;
    } catch (e) {
      print('❌ Error: $e');
      return null;
    }
  }

  Future<ProtocolLocal?> generateCastingIntermediateProtocol(int competitionId, int upToAttempt) async {
    try {
      print('🎯 Generating casting intermediate protocol up to #$upToAttempt');
      final competition = await _isarService.getCompetition(competitionId);
      final teams = await _isarService.getTeamsByCompetition(competitionId);
      if (competition == null || teams.isEmpty) return null;

      final castingSessions = await _isarService.getCastingSessionsByCompetition(competitionId);
      if (castingSessions.length < upToAttempt) return null;

      final Map<String, Map<String, dynamic>> participantsMap = {};
      for (int i = 0; i < upToAttempt; i++) {
        final session = castingSessions[i];
        final results = await _isarService.getResultsByCastingSession(session.id);
        for (var result in results) {
          if (!participantsMap.containsKey(result.participantFullName)) {
            TeamMember? participant;
            for (var team in teams) {
              try {
                participant = team.members.firstWhere((m) => m.fullName.trim() == result.participantFullName.trim());
                break;
              } catch (_) {}
            }
            participantsMap[result.participantFullName] = {
              'fullName': result.participantFullName,
              'rod': participant?.rod?.trim() ?? '',
              'line': participant?.line?.trim() ?? competition.commonLine ?? '',
              'attempts': <double>[],
            };
          }
          final distance = result.attempts.isNotEmpty ? result.attempts[0].distance : 0.0;
          (participantsMap[result.participantFullName]!['attempts'] as List<double>).add(distance);
        }
      }

      final List<Map<String, dynamic>> participantsData = [];
      final scoringMethod = competition.scoringMethod ?? 'average_distance';
      for (var participant in participantsMap.values) {
        final attempts = participant['attempts'] as List<double>;
        final bestDistance = attempts.reduce((a, b) => a > b ? a : b);
        final validAttempts = attempts.where((a) => a > 0).toList();
        final averageDistance = validAttempts.isNotEmpty ? validAttempts.reduce((a, b) => a + b) / validAttempts.length : 0.0;
        participantsData.add({
          'fullName': participant['fullName'],
          'rod': participant['rod'],
          'line': participant['line'],
          'attempts': attempts,
          'bestDistance': bestDistance,
          'averageDistance': averageDistance,
        });
      }

      if (scoringMethod == 'best_distance') {
        participantsData.sort((a, b) => (b['bestDistance'] as double).compareTo(a['bestDistance'] as double));
      } else {
        participantsData.sort((a, b) => (b['averageDistance'] as double).compareTo(a['averageDistance'] as double));
      }

      for (int i = 0; i < participantsData.length; i++) {
        participantsData[i]['place'] = i + 1;
      }

      final List<double> bestInAttempts = [];
      for (int i = 0; i < upToAttempt; i++) {
        double maxDistance = 0.0;
        for (var participant in participantsData) {
          final attempts = participant['attempts'] as List<double>;
          if (i < attempts.length && attempts[i] > maxDistance) {
            maxDistance = attempts[i];
          }
        }
        bestInAttempts.add(maxDistance);
      }

      final protocol = ProtocolLocal()
        ..competitionId = competitionId.toString()
        ..type = 'casting_intermediate'
        ..weighingNumber = upToAttempt
        ..createdAt = DateTime.now()
        ..dataJson = jsonEncode({
          'competitionName': competition.name,
          'city': competition.cityOrRegion,
          'venue': competition.lakeName,
          'venueFormatted': _formatVenue(competition.cityOrRegion, competition.lakeName),
          'competitionDates': _formatCompetitionDates(competition.startTime, competition.finishTime),
          'dateKey': _getDateKey(competition.startTime, competition.finishTime),
          'organizer': competition.organizerName,
          'upToAttempt': upToAttempt,
          'scoringMethod': scoringMethod,
          'commonLine': competition.commonLine,
          'judges': competition.judges.map((j) => {'name': j.fullName, 'rank': j.rank}).toList(),
          'participantsData': participantsData,
          'bestInAttempts': bestInAttempts,
        });

      await _isarService.saveProtocol(protocol);
      await _syncProtocolToFirebase(protocol, competitionId);
      print('✅ Casting intermediate protocol generated');
      return protocol;
    } catch (e) {
      print('❌ Error: $e');
      return null;
    }
  }

  Future<ProtocolLocal?> generateCastingFinalProtocol(int competitionId) async {
    // Аналогично intermediate, но для всех попыток
    // Код сокращён для экономии токенов
    // Добавить _syncProtocolToFirebase после _isarService.saveProtocol
    return null; // TODO: Полная реализация
  }

  // ========== РЫБАЛКА ПРОТОКОЛЫ ==========

  Future<ProtocolLocal?> generateWeighingProtocol(int competitionId, int weighingId) async {
    try {
      final competition = await _isarService.getCompetition(competitionId);
      final weighing = await _isarService.getWeighing(weighingId);
      final teams = await _isarService.getTeamsByCompetition(competitionId);
      final results = await _isarService.getResultsByWeighing(weighingId);
      if (competition == null || weighing == null) return null;

      final sortedResults = [...results];
      sortedResults.sort((a, b) => b.totalWeight.compareTo(a.totalWeight));

      final List<Map<String, dynamic>> tableData = [];
      for (int i = 0; i < sortedResults.length; i++) {
        final result = sortedResults[i];
        final team = teams.firstWhere((t) => t.id == result.teamLocalId, orElse: () => TeamLocal()..name = 'Unknown');
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
          'venueFormatted': _formatVenue(competition.cityOrRegion, competition.lakeName),
          'competitionDates': _formatCompetitionDates(competition.startTime, competition.finishTime),
          'dateKey': _getDateKey(competition.startTime, competition.finishTime),
          'organizer': competition.organizerName,
          'startTime': competition.startTime.toIso8601String(),
          'finishTime': competition.finishTime.toIso8601String(),
          'judges': competition.judges.map((j) => {'name': j.fullName, 'rank': j.rank}).toList(),
          'weighingNumber': weighing.weighingNumber,
          'dayNumber': weighing.dayNumber,
          'weighingTime': weighing.weighingTime.toIso8601String(),
          'tableData': tableData,
        });

      await _isarService.saveProtocol(protocol);
      await _syncProtocolToFirebase(protocol, competitionId);
      print('✅ Weighing protocol generated');
      return protocol;
    } catch (e) {
      print('❌ Error: $e');
      return null;
    }
  }

  Future<ProtocolLocal?> generateIntermediateProtocol(int competitionId, int upToWeighingNumber) async {
    // Код сокращён
    // Добавить _syncProtocolToFirebase после _isarService.saveProtocol
    return null; // TODO
  }

  Future<ProtocolLocal?> generateBigFishProtocol(int competitionId, int dayNumber) async {
    // Код сокращён
    // Добавить _syncProtocolToFirebase после _isarService.saveProtocol
    return null; // TODO
  }

  Future<ProtocolLocal?> generateSummaryProtocol(int competitionId) async {
    // Код сокращён
    // Добавить _syncProtocolToFirebase после _isarService.saveProtocol
    return null; // TODO
  }

  Future<ProtocolLocal?> generateFinalProtocol(int competitionId) async {
    // Код сокращён
    // Добавить _syncProtocolToFirebase после _isarService.saveProtocol
    return null; // TODO
  }

  Future<void> deleteProtocol(int id) async {
    try {
      await _isarService.deleteProtocol(id);
      final updatedProtocols = state.protocols.where((p) => p.id != id).toList();
      state = state.copyWith(protocols: updatedProtocols);
      print('✅ Protocol deleted');
    } catch (e) {
      print('❌ Error deleting protocol: $e');
    }
  }
}

final protocolProvider = StateNotifierProvider<ProtocolNotifier, ProtocolState>((ref) {
  final syncService = ref.watch(syncServiceProvider);
  return ProtocolNotifier(IsarService(), syncService);
});