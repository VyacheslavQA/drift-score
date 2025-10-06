import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../data/models/local/competition_local.dart';


final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('Isar instance must be overridden');
});

final competitionProvider = StateNotifierProvider<CompetitionNotifier, AsyncValue<List<CompetitionLocal>>>((ref) {
  final isar = ref.watch(isarProvider);
  return CompetitionNotifier(isar);
});

class CompetitionNotifier extends StateNotifier<AsyncValue<List<CompetitionLocal>>> {
  final Isar isar;

  CompetitionNotifier(this.isar) : super(const AsyncValue.loading()) {
    loadCompetitions();
  }

  Future<void> loadCompetitions() async {
    state = const AsyncValue.loading();
    try {
      final competitions = await isar.competitionLocals.where().findAll();
      state = AsyncValue.data(competitions);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createCompetition({
    required String name,
    required String cityOrRegion,
    required String lakeName,
    required int sectorsCount,
    required DateTime startTime,
    required int durationHours,
    required String scoringRules,
    required String organizerName,
    required List<Judge> judges,
  }) async {
    try {
      final competition = CompetitionLocal()
        ..name = name
        ..cityOrRegion = cityOrRegion
        ..lakeName = lakeName
        ..sectorsCount = sectorsCount
        ..startTime = startTime
        ..durationHours = durationHours
        ..scoringRules = scoringRules
        ..organizerName = organizerName
        ..judges = judges
        ..isFinal = false
        ..createdAt = DateTime.now();

      await isar.writeTxn(() async {
        await isar.competitionLocals.put(competition);
      });

      await loadCompetitions();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteCompetition(int id) async {
    try {
      await isar.writeTxn(() async {
        await isar.competitionLocals.delete(id);
      });

      await loadCompetitions();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}