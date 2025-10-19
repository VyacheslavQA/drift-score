import 'dart:convert';
import '../../../data/models/local/protocol_local.dart';
import '../../../data/models/local/team_local.dart';
import '../../../data/services/isar_service.dart';
import '../../../data/services/sync_service.dart';
import 'base_protocol_generator.dart';

/// Генератор протоколов для кастинга
/// Генерирует: attempt, intermediate, final протоколы
class CastingProtocolGenerator extends BaseProtocolGenerator {
  CastingProtocolGenerator(IsarService isarService, SyncService syncService)
      : super(isarService, syncService);

  // ========== ПРОТОКОЛ ПОПЫТКИ ==========

  Future<ProtocolLocal?> generateCastingAttemptProtocol(
      int competitionId, int attemptNumber) async {
    try {
      print('🎯 Generating casting attempt protocol #$attemptNumber');

      // ✅ Проверка на существование
      final existingProtocols =
      await isarService.getProtocolsByType(competitionId, 'casting_attempt');
      final existingProtocol = existingProtocols
          .where((p) => p.weighingNumber == attemptNumber)
          .firstOrNull;

      if (existingProtocol != null) {
        print(
            'ℹ️ Casting attempt protocol #$attemptNumber already exists (id=${existingProtocol.id})');
        return existingProtocol;
      }

      final competition = await isarService.getCompetition(competitionId);
      final teams = await isarService.getTeamsByCompetition(competitionId);
      if (competition == null || teams.isEmpty) return null;

      final castingSessions =
      await isarService.getCastingSessionsByCompetition(competitionId);
      if (castingSessions.length < attemptNumber) return null;

      final session = castingSessions[attemptNumber - 1];
      final results = await isarService.getResultsByCastingSession(session.id);
      if (results.isEmpty) return null;

      final List<Map<String, dynamic>> participantsData = [];
      for (var result in results) {
        final distance =
        result.attempts.isNotEmpty ? result.attempts[0].distance : 0.0;
        TeamMember? participant;
        for (var team in teams) {
          try {
            participant = team.members.firstWhere((m) =>
            m.fullName.trim() == result.participantFullName.trim());
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

      participantsData.sort(
              (a, b) => (b['distance'] as double).compareTo(a['distance'] as double));
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
          'fishingType': competition.fishingType,
          'city': competition.cityOrRegion,
          'venue': competition.lakeName,
          'venueFormatted':
          formatVenue(competition.cityOrRegion, competition.lakeName),
          'competitionDates':
          formatCompetitionDates(competition.startTime, competition.finishTime),
          'dateKey': getDateKey(competition.startTime, competition.finishTime),
          'attemptNumber': attemptNumber,
          'sessionTime': session.sessionTime.toIso8601String(),
          'judges': competition.judges
              .map((j) => {'name': j.fullName, 'rank': translateRank(j.rank)})
              .toList(),
          'participantsData': participantsData,
        });

      await isarService.saveProtocol(protocol);
      await syncProtocolToFirebase(protocol, competitionId);
      print('✅ Casting attempt protocol #$attemptNumber generated');
      return protocol;
    } catch (e) {
      print('❌ Error generating casting attempt protocol: $e');
      return null;
    }
  }

  // ========== ПРОМЕЖУТОЧНЫЙ ПРОТОКОЛ ==========

  Future<ProtocolLocal?> generateCastingIntermediateProtocol(
      int competitionId, int upToAttempt) async {
    try {
      print('🎯 Generating casting intermediate protocol up to #$upToAttempt');

      // ✅ Проверка на существование
      final existingProtocols = await isarService.getProtocolsByType(
          competitionId, 'casting_intermediate');
      final existingProtocol = existingProtocols
          .where((p) => p.weighingNumber == upToAttempt)
          .firstOrNull;

      if (existingProtocol != null) {
        print(
            'ℹ️ Casting intermediate protocol up to #$upToAttempt already exists (id=${existingProtocol.id})');
        return existingProtocol;
      }

      final competition = await isarService.getCompetition(competitionId);
      final teams = await isarService.getTeamsByCompetition(competitionId);
      if (competition == null || teams.isEmpty) return null;

      final castingSessions =
      await isarService.getCastingSessionsByCompetition(competitionId);
      if (castingSessions.length < upToAttempt) return null;

      final Map<String, Map<String, dynamic>> participantsMap = {};
      for (int i = 0; i < upToAttempt; i++) {
        final session = castingSessions[i];
        final results = await isarService.getResultsByCastingSession(session.id);
        for (var result in results) {
          if (!participantsMap.containsKey(result.participantFullName)) {
            TeamMember? participant;
            for (var team in teams) {
              try {
                participant = team.members.firstWhere((m) =>
                m.fullName.trim() == result.participantFullName.trim());
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
          final distance =
          result.attempts.isNotEmpty ? result.attempts[0].distance : 0.0;
          (participantsMap[result.participantFullName]!['attempts']
          as List<double>)
              .add(distance);
        }
      }

      final List<Map<String, dynamic>> participantsData = [];
      final scoringMethod = competition.scoringMethod ?? 'average_distance';
      for (var participant in participantsMap.values) {
        final attempts = participant['attempts'] as List<double>;
        final bestDistance = attempts.reduce((a, b) => a > b ? a : b);
        final validAttempts = attempts.where((a) => a > 0).toList();
        final averageDistance = validAttempts.isNotEmpty
            ? validAttempts.reduce((a, b) => a + b) / validAttempts.length
            : 0.0;
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
        participantsData.sort((a, b) =>
            (b['bestDistance'] as double).compareTo(a['bestDistance'] as double));
      } else {
        participantsData.sort((a, b) => (b['averageDistance'] as double)
            .compareTo(a['averageDistance'] as double));
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
          'fishingType': competition.fishingType,
          'city': competition.cityOrRegion,
          'venue': competition.lakeName,
          'venueFormatted':
          formatVenue(competition.cityOrRegion, competition.lakeName),
          'competitionDates':
          formatCompetitionDates(competition.startTime, competition.finishTime),
          'dateKey': getDateKey(competition.startTime, competition.finishTime),
          'organizer': competition.organizerName,
          'upToAttempt': upToAttempt,
          'scoringMethod': scoringMethod,
          'commonLine': competition.commonLine,
          'judges': competition.judges
              .map((j) => {'name': j.fullName, 'rank': translateRank(j.rank)})
              .toList(),
          'participantsData': participantsData,
          'bestInAttempts': bestInAttempts,
        });

      await isarService.saveProtocol(protocol);
      await syncProtocolToFirebase(protocol, competitionId);
      print('✅ Casting intermediate protocol generated');
      return protocol;
    } catch (e) {
      print('❌ Error generating casting intermediate protocol: $e');
      return null;
    }
  }

  // ========== ФИНАЛЬНЫЙ ПРОТОКОЛ ==========

  Future<ProtocolLocal?> generateCastingFinalProtocol(int competitionId) async {
    try {
      print('🎯 Generating casting final protocol');

      // ✅ Проверка на существование
      final existingProtocols =
      await isarService.getProtocolsByType(competitionId, 'casting_final');
      if (existingProtocols.isNotEmpty) {
        print(
            'ℹ️ Casting final protocol already exists (id=${existingProtocols.first.id})');
        return existingProtocols.first;
      }

      final competition = await isarService.getCompetition(competitionId);
      if (competition == null) return null;

      final attemptsCount = competition.attemptsCount ?? 3;

      // Используем метод generateCastingIntermediateProtocol для всех попыток
      final intermediateProtocol =
      await generateCastingIntermediateProtocol(competitionId, attemptsCount);

      if (intermediateProtocol == null) return null;

      // Копируем данные из промежуточного протокола и меняем тип на 'casting_final'
      final protocol = ProtocolLocal()
        ..competitionId = competitionId.toString()
        ..type = 'casting_final'
        ..weighingNumber = attemptsCount
        ..createdAt = DateTime.now()
        ..dataJson = intermediateProtocol.dataJson;

      await isarService.saveProtocol(protocol);
      await syncProtocolToFirebase(protocol, competitionId);
      print('✅ Casting final protocol generated');
      return protocol;
    } catch (e) {
      print('❌ Error generating casting final protocol: $e');
      return null;
    }
  }
}