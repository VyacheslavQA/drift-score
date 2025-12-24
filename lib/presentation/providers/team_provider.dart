import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import '../../data/models/local/team_local.dart';
import '../../data/models/local/competition_local.dart';
import '../../data/services/sync_service.dart';
import 'competition_provider.dart';

final teamProvider = StateNotifierProvider.family<TeamNotifier, AsyncValue<List<TeamLocal>>, int>(
      (ref, competitionId) {
    final isar = ref.watch(isarProvider);
    final syncService = ref.watch(syncServiceProvider);
    return TeamNotifier(isar, syncService, competitionId);
  },
);

class TeamNotifier extends StateNotifier<AsyncValue<List<TeamLocal>>> {
  final Isar isar;
  final SyncService syncService;
  final int competitionId;

  TeamNotifier(this.isar, this.syncService, this.competitionId) : super(const AsyncValue.loading()) {
    loadTeams();
  }

  /// Получить serverId соревнования
  Future<String?> _getCompetitionServerId() async {
    final competition = await isar.competitionLocals.get(competitionId);
    return competition?.serverId;
  }

  Future<void> loadTeams() async {
    print('🔵 loadTeams() called for competition: $competitionId');
    state = const AsyncValue.loading();

    try {
      final teams = await isar.teamLocals
          .filter()
          .competitionLocalIdEqualTo(competitionId)
          .sortByCreatedAt()
          .findAll();

      print('✅ Teams loaded: ${teams.length} teams');
      for (var team in teams) {
        print('   - ${team.name} (Synced: ${team.isSynced})');
      }
      state = AsyncValue.data(teams);
    } catch (e, stack) {
      print('❌ Error loading teams: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  /// ✅ НОВЫЙ МЕТОД: Синхронизировать команды из Firebase
  Future<void> syncTeamsFromFirebase() async {
    print('🔵 syncTeamsFromFirebase() called');
    try {
      final competitionServerId = await _getCompetitionServerId();
      if (competitionServerId == null || competitionServerId.isEmpty) {
        print('⚠️ Competition not synced to Firebase yet');
        return;
      }

      await syncService.syncTeamsFromFirebase(competitionServerId);
      print('✅ Teams synced from Firebase');
      await loadTeams();
    } catch (e, stack) {
      print('❌ Error syncing teams from Firebase: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createTeam({
    required String name,
    required String city,
    String? club,
    required List<TeamMember> members,
  }) async {
    print('🔵 createTeam() called: $name');

    try {
      final team = TeamLocal()
        ..competitionLocalId = competitionId
        ..name = name
        ..city = city
        ..club = club
        ..members = members
        ..isSynced = false
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();

      await isar.writeTxn(() async {
        await isar.teamLocals.put(team);
      });

      print('✅ Team created locally: ${team.name}, ID: ${team.id}');

      // ✅ НОВОЕ: Синхронизация с Firebase
      final competitionServerId = await _getCompetitionServerId();
      if (competitionServerId != null && competitionServerId.isNotEmpty) {
        print('🔄 Syncing team to Firebase...');
        try {
          await syncService.syncTeamToFirebase(team, competitionServerId);
          print('✅ Team synced to Firebase successfully');
        } catch (e) {
          print('⚠️ Error syncing team to Firebase (will retry later): $e');
        }
      } else {
        print('⚠️ Competition not synced to Firebase yet - team will sync later');
      }

      await loadTeams();
    } catch (e, stack) {
      print('❌ Error creating team: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateTeam({
    required int teamId,
    required String name,
    required String city,
    String? club,
    required List<TeamMember> members,
  }) async {
    print('🔵 updateTeam() called: ID $teamId');

    try {
      final team = await isar.teamLocals.get(teamId);

      if (team == null) {
        print('❌ Team not found: $teamId');
        return;
      }

      team
        ..name = name
        ..city = city
        ..club = club
        ..members = members
        ..isSynced = false
        ..updatedAt = DateTime.now();

      await isar.writeTxn(() async {
        await isar.teamLocals.put(team);
      });

      print('✅ Team updated locally: ${team.name}');

      // ✅ НОВОЕ: Синхронизация с Firebase
      final competitionServerId = await _getCompetitionServerId();
      if (competitionServerId != null && competitionServerId.isNotEmpty) {
        print('🔄 Syncing updated team to Firebase...');
        try {
          await syncService.syncTeamToFirebase(team, competitionServerId);
          print('✅ Team synced to Firebase successfully');
        } catch (e) {
          print('⚠️ Error syncing team to Firebase (will retry later): $e');
        }
      }

      await loadTeams();
    } catch (e, stack) {
      print('❌ Error updating team: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteTeam(int teamId) async {
    print('🔵 deleteTeam() called: ID $teamId');

    try {
      // Получаем serverId перед удалением
      final team = await isar.teamLocals.get(teamId);
      final teamServerId = team?.serverId;
      final competitionServerId = await _getCompetitionServerId();

      await isar.writeTxn(() async {
        final success = await isar.teamLocals.delete(teamId);
        print('✅ Team deleted locally: $success');
      });

      // ✅ НОВОЕ: Удаление из Firebase
      if (teamServerId != null &&
          teamServerId.isNotEmpty &&
          competitionServerId != null &&
          competitionServerId.isNotEmpty) {
        print('🔄 Deleting team from Firebase...');
        try {
          await syncService.deleteTeamFromFirebase(competitionServerId, teamServerId);
          print('✅ Team deleted from Firebase successfully');
        } catch (e) {
          print('⚠️ Error deleting team from Firebase: $e');
        }
      } else {
        print('⚠️ Team was not synced to Firebase');
      }

      await loadTeams();
    } catch (e, stack) {
      print('❌ Error deleting team: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> assignSector(int teamId, int sector) async {
    print('🔵 assignSector() called: Team $teamId → Sector $sector');

    try {
      final team = await isar.teamLocals.get(teamId);

      if (team == null) {
        print('❌ Team not found: $teamId');
        return;
      }

      team
        ..sector = sector
        ..isSynced = false
        ..updatedAt = DateTime.now();

      await isar.writeTxn(() async {
        await isar.teamLocals.put(team);
      });

      print('✅ Sector assigned locally');

      // ✅ НОВОЕ: Синхронизация с Firebase
      final competitionServerId = await _getCompetitionServerId();
      if (competitionServerId != null && competitionServerId.isNotEmpty) {
        print('🔄 Syncing sector assignment to Firebase...');
        try {
          await syncService.syncTeamToFirebase(team, competitionServerId);
          print('✅ Sector synced to Firebase successfully');
        } catch (e) {
          print('⚠️ Error syncing sector to Firebase (will retry later): $e');
        }
      }

      await loadTeams();
    } catch (e, stack) {
      print('❌ Error assigning sector: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addPenalty(int teamId, String description, String judgeId) async {
    print('🔵 addPenalty() called: Team $teamId');

    try {
      final team = await isar.teamLocals.get(teamId);

      if (team == null) {
        print('❌ Team not found: $teamId');
        return;
      }

      final penalty = Penalty()
        ..id = DateTime.now().millisecondsSinceEpoch.toString()
        ..description = description
        ..createdAt = DateTime.now()
        ..addedByJudgeId = judgeId;

      team.penalties.add(penalty);
      team.isSynced = false;
      team.updatedAt = DateTime.now();

      await isar.writeTxn(() async {
        await isar.teamLocals.put(team);
      });

      print('✅ Penalty added locally');

      // ✅ НОВОЕ: Синхронизация с Firebase
      final competitionServerId = await _getCompetitionServerId();
      if (competitionServerId != null && competitionServerId.isNotEmpty) {
        print('🔄 Syncing penalty to Firebase...');
        try {
          await syncService.syncTeamToFirebase(team, competitionServerId);
          print('✅ Penalty synced to Firebase successfully');
        } catch (e) {
          print('⚠️ Error syncing penalty to Firebase (will retry later): $e');
        }
      }

      await loadTeams();
    } catch (e, stack) {
      print('❌ Error adding penalty: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  /// Сохранение результатов жеребьёвки (очередность + сектор)
  Future<void> saveDrawResults(Map<int, DrawData> drawResults) async {
    print('🔵 saveDrawResults() called for ${drawResults.length} teams');

    try {
      final updatedTeams = <TeamLocal>[];

      await isar.writeTxn(() async {
        for (var entry in drawResults.entries) {
          final teamId = entry.key;
          final drawData = entry.value;

          final team = await isar.teamLocals.get(teamId);
          if (team != null) {
            team.drawOrder = drawData.drawOrder;
            team.sector = drawData.sector;
            team.isSynced = false;
            team.updatedAt = DateTime.now();
            await isar.teamLocals.put(team);
            print('  ✅ Team ${team.name}: order=${drawData.drawOrder}, sector=${drawData.sector}');
            updatedTeams.add(team);
          }
        }
      });

      print('✅ Draw results saved locally');

      // ✅ НОВОЕ: Синхронизация всех обновлённых команд с Firebase
      final competitionServerId = await _getCompetitionServerId();
      if (competitionServerId != null && competitionServerId.isNotEmpty) {
        print('🔄 Syncing draw results to Firebase...');
        for (var team in updatedTeams) {
          try {
            await syncService.syncTeamToFirebase(team, competitionServerId);
            print('  ✅ Team ${team.name} synced');
          } catch (e) {
            print('  ⚠️ Error syncing team ${team.name}: $e');
          }
        }
        print('✅ All draw results synced to Firebase');
      }

      await loadTeams();
    } catch (e, stack) {
      print('❌ Error saving draw results: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  /// Обновление зональной жеребьёвки (memberDraws)
  Future<void> updateTeamMemberDraws(int teamId, List<MemberDraw> memberDraws) async {
    print('🔵 updateTeamMemberDraws() called for team: $teamId');

    try {
      final team = await isar.teamLocals.get(teamId);

      if (team == null) {
        print('❌ Team not found: $teamId');
        return;
      }

      team.memberDraws = memberDraws;
      team.isSynced = false;
      team.updatedAt = DateTime.now();

      await isar.writeTxn(() async {
        await isar.teamLocals.put(team);
      });

      print('✅ Member draws updated locally');

      // Синхронизация с Firebase
      final competitionServerId = await _getCompetitionServerId();
      if (competitionServerId != null && competitionServerId.isNotEmpty) {
        print('🔄 Syncing member draws to Firebase...');
        try {
          await syncService.syncTeamToFirebase(team, competitionServerId);
          print('✅ Member draws synced to Firebase successfully');
        } catch (e) {
          print('⚠️ Error syncing member draws to Firebase: $e');
        }
      }

      await loadTeams();
    } catch (e, stack) {
      print('❌ Error updating member draws: $e');
      state = AsyncValue.error(e, stack);
    }
  }
}

/// Данные жеребьёвки для одной команды
class DrawData {
  final int? drawOrder;
  final int? sector;

  DrawData({this.drawOrder, this.sector});
}