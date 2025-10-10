import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../data/models/local/team_local.dart';
import 'competition_provider.dart';

final teamProvider = StateNotifierProvider.family<TeamNotifier, AsyncValue<List<TeamLocal>>, int>(
      (ref, competitionId) {
    final isar = ref.watch(isarProvider);
    return TeamNotifier(isar, competitionId);
  },
);

class TeamNotifier extends StateNotifier<AsyncValue<List<TeamLocal>>> {
  final Isar isar;
  final int competitionId;

  TeamNotifier(this.isar, this.competitionId) : super(const AsyncValue.loading()) {
    loadTeams();
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
      state = AsyncValue.data(teams);
    } catch (e, stack) {
      print('❌ Error loading teams: $e');
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

      print('✅ Team created: ${team.name}, ID: ${team.id}');
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

      print('✅ Team updated: ${team.name}');
      await loadTeams();
    } catch (e, stack) {
      print('❌ Error updating team: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteTeam(int teamId) async {
    print('🔵 deleteTeam() called: ID $teamId');

    try {
      await isar.writeTxn(() async {
        final success = await isar.teamLocals.delete(teamId);
        print('✅ Team deleted: $success');
      });

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

      print('✅ Sector assigned');
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

      print('✅ Penalty added');
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
          }
        }
      });

      print('✅ Draw results saved successfully');
      await loadTeams();
    } catch (e, stack) {
      print('❌ Error saving draw results: $e');
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