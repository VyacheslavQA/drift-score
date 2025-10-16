import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
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
    print('🔵 CompetitionNotifier initialized');
    loadAllCompetitionsForDevice();
  }

  // Получить Device ID
  Future<String> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown';
    }
    return 'unknown';
  }

  // ✅ МЕТОД: Проверка существования кода
  Future<List<CompetitionLocal>> checkCodeExists(String accessCode) async {
    print('🔍 checkCodeExists() called with code: $accessCode');
    print('🔍 Trimming and uppercasing: "${accessCode.trim().toUpperCase()}"');

    final normalizedCode = accessCode.trim().toUpperCase();

    try {
      // Проверяем ВСЕ соревнования (не только этого устройства!)
      final allCompetitions = await isar.competitionLocals.where().findAll();
      print('🔍 Total competitions in database: ${allCompetitions.length}');

      // Фильтруем по коду (с учётом регистра и пробелов)
      final existingCompetitions = allCompetitions
          .where((c) => (c.accessCode ?? '').trim().toUpperCase() == normalizedCode)
          .toList();

      print('🔍 Found ${existingCompetitions.length} competition(s) with code: $normalizedCode');
      for (var comp in existingCompetitions) {
        print('   - ${comp.name} (ID: ${comp.id}, Code: "${comp.accessCode}", Status: ${comp.status})');
      }

      return existingCompetitions;
    } catch (e) {
      print('❌ Error checking code existence: $e');
      return [];
    }
  }

  // Загрузить ВСЕ соревнования этого устройства (не фильтруем по коду!)
  Future<void> loadAllCompetitionsForDevice() async {
    print('🔵 loadAllCompetitionsForDevice() called');
    state = const AsyncValue.loading();
    try {
      final deviceId = await _getDeviceId();

      // Загружаем ВСЕ соревнования, созданные на этом устройстве
      final competitions = await isar.competitionLocals
          .filter()
          .createdByDeviceIdEqualTo(deviceId)
          .sortByStartTimeDesc()
          .findAll();

      print('✅ All competitions for device loaded: ${competitions.length} items');
      for (var comp in competitions) {
        print('   - ${comp.name} (Code: ${comp.accessCode}, Status: ${comp.status})');
      }

      state = AsyncValue.data(competitions);
    } catch (e, stack) {
      print('❌ Error loading competitions: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  // Загрузить ВСЕ соревнования (для публичного просмотра)
  Future<void> loadAllCompetitions() async {
    print('🔵 loadAllCompetitions() called');
    state = const AsyncValue.loading();
    try {
      final competitions = await isar.competitionLocals.where().findAll();
      print('✅ All competitions loaded: ${competitions.length} items');
      state = AsyncValue.data(competitions);
    } catch (e, stack) {
      print('❌ Error loading all competitions: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createCompetition({
    required String name,
    required String cityOrRegion,
    required String lakeName,
    required int sectorsCount,
    required DateTime startTime,
    required DateTime finishTime,
    required String scoringMethod,
    required String organizerName,
    required List<Judge> judges,
    required String accessCode,
    required String fishingType,
    required String sectorStructure,
    String? zonedType,
    int? zonesCount,
    int? sectorsPerZone,
    List<String>? lakeNames,
    int? attemptsCount,
    String? commonLine,
  }) async {
    print('🔵 createCompetition() called');
    print('   Name: $name');
    print('   Code: $accessCode');
    print('   Type: $fishingType');
    print('   Scoring: $scoringMethod');
    print('   Structure: $sectorStructure');
    if (sectorStructure == 'zoned') {
      print('   Zoned Type: $zonedType');
      print('   Zones Count: $zonesCount');
      print('   Sectors Per Zone: $sectorsPerZone');
      print('   Lake Names: $lakeNames');
    }
    if (fishingType == 'casting') {
      print('   Attempts Count: $attemptsCount');
      print('   Common Line: ${commonLine ?? "Not specified (individual lines)"}');
    }

    try {
      final deviceId = await _getDeviceId();

      print('📱 Device ID: $deviceId');

      // ⬇️ ПРОВЕРКА: Существует ли уже соревнование с этим кодом?
      print('🔍 Checking for existing competitions with code: $accessCode');

      final existingCompetitions = await checkCodeExists(accessCode);

      if (existingCompetitions.isNotEmpty) {
        print('❌ Competition with code $accessCode already exists!');
        for (var comp in existingCompetitions) {
          print('   Existing: ${comp.name} (ID: ${comp.id}, Code: "${comp.accessCode}")');
        }
        throw Exception('Соревнование с кодом $accessCode уже существует! Используйте другой код.');
      }

      print('✅ No existing competition found, creating new one');

      final competition = CompetitionLocal()
        ..name = name
        ..cityOrRegion = cityOrRegion
        ..lakeName = lakeName
        ..sectorsCount = sectorsCount
        ..startTime = startTime
        ..finishTime = finishTime
        ..scoringMethod = scoringMethod
        ..organizerName = organizerName
        ..judges = judges
        ..accessCode = accessCode
        ..createdByDeviceId = deviceId
        ..fishingType = fishingType
        ..sectorStructure = sectorStructure
        ..zonedType = zonedType
        ..zonesCount = zonesCount
        ..sectorsPerZone = sectorsPerZone
        ..lakeNames = lakeNames ?? []
        ..attemptsCount = attemptsCount
        ..commonLine = commonLine
        ..status = 'active'
        ..isFinal = false
        ..isSynced = false
        ..createdAt = DateTime.now();

      print('✅ Competition object created');
      print('   Name: ${competition.name}');
      print('   Access Code: ${competition.accessCode}');
      print('   Fishing Type: ${competition.fishingType}');
      print('   Scoring Method: ${competition.scoringMethod}');
      print('   Sector Structure: ${competition.sectorStructure}');
      print('   Attempts Count: ${competition.attemptsCount}');
      print('   Common Line: ${competition.commonLine ?? "null"}');
      print('   Device ID: ${competition.createdByDeviceId}');

      await isar.writeTxn(() async {
        final id = await isar.competitionLocals.put(competition);
        print('✅ Competition saved to Isar with ID: $id');
      });

      print('🔵 Calling loadAllCompetitionsForDevice() after save');
      await loadAllCompetitionsForDevice();
    } catch (e, stack) {
      print('❌ Error creating competition: $e');
      print('Stack: $stack');
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  // ✅ НОВЫЙ МЕТОД: Обновление соревнования
  Future<void> updateCompetition({
    required int id,
    required String name,
    required String cityOrRegion,
    required String lakeName,
    required int sectorsCount,
    required DateTime startTime,
    required DateTime finishTime,
    required String scoringMethod,
    required String organizerName,
    required List<Judge> judges,
    required String fishingType,
    required String sectorStructure,
    String? zonedType,
    int? zonesCount,
    int? sectorsPerZone,
    List<String>? lakeNames,
    int? attemptsCount,
    String? commonLine,
  }) async {
    print('🔵 updateCompetition() called');
    print('   ID: $id');
    print('   Name: $name');
    print('   Type: $fishingType');
    print('   Scoring: $scoringMethod');
    print('   Structure: $sectorStructure');
    if (sectorStructure == 'zoned') {
      print('   Zoned Type: $zonedType');
      print('   Zones Count: $zonesCount');
      print('   Sectors Per Zone: $sectorsPerZone');
      print('   Lake Names: $lakeNames');
    }
    if (fishingType == 'casting') {
      print('   Attempts Count: $attemptsCount');
      print('   Common Line: ${commonLine ?? "Not specified"}');
    }

    try {
      await isar.writeTxn(() async {
        final competition = await isar.competitionLocals.get(id);

        if (competition == null) {
          print('❌ Competition with ID $id not found!');
          throw Exception('Соревнование не найдено');
        }

        print('✅ Found competition to update: ${competition.name}');

        // Обновляем поля
        competition.name = name;
        competition.cityOrRegion = cityOrRegion;
        competition.lakeName = lakeName;
        competition.sectorsCount = sectorsCount;
        competition.startTime = startTime;
        competition.finishTime = finishTime;
        competition.scoringMethod = scoringMethod;
        competition.organizerName = organizerName;
        competition.judges = judges;
        competition.sectorStructure = sectorStructure;
        competition.zonedType = zonedType;
        competition.zonesCount = zonesCount;
        competition.sectorsPerZone = sectorsPerZone;
        competition.lakeNames = lakeNames ?? [];
        competition.attemptsCount = attemptsCount;
        competition.commonLine = commonLine;
        competition.isSynced = false; // Помечаем как несинхронизированное

        await isar.competitionLocals.put(competition);
        print('✅ Competition updated successfully');
        print('   Updated Name: ${competition.name}');
        print('   Updated Scoring: ${competition.scoringMethod}');
        print('   Updated Common Line: ${competition.commonLine ?? "null"}');
      });

      print('🔵 Reloading competitions after update');
      await loadAllCompetitionsForDevice();
    } catch (e, stack) {
      print('❌ Error updating competition: $e');
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> deleteCompetition(int id) async {
    print('🔵 deleteCompetition() called with ID: $id');
    try {
      await isar.writeTxn(() async {
        final deleted = await isar.competitionLocals.delete(id);
        print('✅ Competition deleted: $deleted');
      });

      await loadAllCompetitionsForDevice();
    } catch (e, stack) {
      print('❌ Error deleting competition: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateCompetitionStatus(int id, String newStatus) async {
    print('🔵 updateCompetitionStatus() called: ID=$id, Status=$newStatus');
    try {
      await isar.writeTxn(() async {
        final competition = await isar.competitionLocals.get(id);
        if (competition != null) {
          competition.status = newStatus;
          if (newStatus == 'completed') {
            competition.finalizedAt = DateTime.now();
          }
          await isar.competitionLocals.put(competition);
          print('✅ Competition status updated');
        }
      });

      await loadAllCompetitionsForDevice();
    } catch (e, stack) {
      print('❌ Error updating competition status: $e');
      state = AsyncValue.error(e, stack);
    }
  }
}