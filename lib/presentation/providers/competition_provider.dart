import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import '../../data/models/local/competition_local.dart';
import '../../data/services/sync_service.dart';
import '../../data/services/isar_service.dart';

final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('Isar instance must be overridden');
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService();
});

final competitionProvider = StateNotifierProvider<CompetitionNotifier, AsyncValue<List<CompetitionLocal>>>((ref) {
  final isar = ref.watch(isarProvider);
  final syncService = ref.watch(syncServiceProvider);
  return CompetitionNotifier(isar, syncService);
});

class CompetitionNotifier extends StateNotifier<AsyncValue<List<CompetitionLocal>>> {
  final Isar isar;
  final SyncService syncService;

  CompetitionNotifier(this.isar, this.syncService) : super(const AsyncValue.loading()) {
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

  // ✅ ОБНОВЛЁННЫЙ МЕТОД: Проверка существования кода (ищет в Firebase + Isar)
  Future<List<CompetitionLocal>> checkCodeExists(String accessCode) async {
    print('🔍 checkCodeExists() called with code: $accessCode');
    final normalizedCode = accessCode.trim().toUpperCase();
    print('🔍 Normalized code: "$normalizedCode"');

    try {
      // 1️⃣ Сначала пытаемся загрузить из Firebase
      print('🔍 Searching in Firebase...');
      try {
        final competitions = await syncService.getCompetitionsByCode(normalizedCode);
        if (competitions.isNotEmpty) {
          print('✅ Found ${competitions.length} competition(s) in Firebase');
          for (var comp in competitions) {
            print('   - ${comp.name} (Code: "${comp.accessCode}", Status: ${comp.status})');
          }
          return competitions;
        }
      } catch (e) {
        print('⚠️ Firebase unavailable or error: $e');
      }

      // 2️⃣ Если Firebase недоступен или не нашли - ищем локально
      print('🔍 Searching in local database (Isar)...');
      final allCompetitions = await isar.competitionLocals.where().findAll();
      print('🔍 Total competitions in local database: ${allCompetitions.length}');

      final existingCompetitions = allCompetitions
          .where((c) => (c.accessCode ?? '').trim().toUpperCase() == normalizedCode)
          .toList();

      print('🔍 Found ${existingCompetitions.length} competition(s) locally with code: $normalizedCode');
      for (var comp in existingCompetitions) {
        print('   - ${comp.name} (ID: ${comp.id}, Code: "${comp.accessCode}", Status: ${comp.status})');
      }

      return existingCompetitions;
    } catch (e) {
      print('❌ Error checking code existence: $e');
      return [];
    }
  }

  // ✅ НОВЫЙ МЕТОД: Обновить использование кода в Firebase
  Future<void> _updateAccessCodeInFirebase(String code, String competitionId) async {
    if (competitionId.isEmpty) {
      print('⚠️ No competitionId - skipping code update');
      return;
    }

    try {
      print('🔄 Updating access code in Firebase: $code');

      final snapshot = await FirebaseFirestore.instance
          .collection('access_codes')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        print('⚠️ Code not found in Firestore: $code');
        return;
      }

      final deviceId = await _getDeviceId();

      await snapshot.docs.first.reference.update({
        'currentUses': FieldValue.increment(1),
        'competitions': FieldValue.arrayUnion([competitionId]),
        'usedBy': FieldValue.arrayUnion([deviceId]),
      });

      print('✅ Access code updated successfully');
      print('   Code: $code');
      print('   Competition ID: $competitionId');
      print('   Device ID: $deviceId');
    } catch (e) {
      print('❌ Error updating access code: $e');
      // Не падаем, если обновление не удалось
    }
  }

  // Загрузить ВСЕ соревнования этого устройства
  Future<void> loadAllCompetitionsForDevice() async {
    print('🔵 loadAllCompetitionsForDevice() called');
    state = const AsyncValue.loading();
    try {
      final deviceId = await _getDeviceId();

      final competitions = await isar.competitionLocals
          .filter()
          .createdByDeviceIdEqualTo(deviceId)
          .sortByStartTimeDesc()
          .findAll();

      print('✅ All competitions for device loaded: ${competitions.length} items');
      for (var comp in competitions) {
        print('   - ${comp.name} (Code: ${comp.accessCode}, Status: ${comp.status}, Synced: ${comp.isSynced})');
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

  // Синхронизировать все соревнования из Firebase
  Future<void> syncAllCompetitionsFromFirebase() async {
    print('🔵 syncAllCompetitionsFromFirebase() called');
    try {
      await syncService.syncAllCompetitions();
      print('✅ All competitions synced from Firebase');
      await loadAllCompetitionsForDevice();
    } catch (e, stack) {
      print('❌ Error syncing competitions from Firebase: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  // ✅ ОБНОВЛЁННЫЙ МЕТОД: Создание соревнования с обновлением кода
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
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();

      print('✅ Competition object created');

      // Сохраняем в Isar
      await isar.writeTxn(() async {
        final id = await isar.competitionLocals.put(competition);
        print('✅ Competition saved to Isar with ID: $id');
      });

      // ✅ Синхронизация с Firebase
      print('🔄 Syncing competition to Firebase...');
      String? firebaseCompetitionId;
      try {
        firebaseCompetitionId = await syncService.syncCompetitionToFirebase(competition);
        print('✅ Competition synced to Firebase with ID: $firebaseCompetitionId');
      } catch (e) {
        print('⚠️ Error syncing to Firebase (will retry later): $e');
      }

      // ✅ НОВОЕ: Обновить код в Firebase
      if (firebaseCompetitionId != null && firebaseCompetitionId.isNotEmpty) {
        print('🔄 Updating access code usage...');
        try {
          await _updateAccessCodeInFirebase(accessCode, firebaseCompetitionId);
          print('✅ Access code updated');
        } catch (e) {
          print('⚠️ Error updating access code: $e');
        }
      } else {
        print('⚠️ No Firebase ID - skipping code update');
      }

      print('🔵 Calling loadAllCompetitionsForDevice() after save');
      await loadAllCompetitionsForDevice();
    } catch (e, stack) {
      print('❌ Error creating competition: $e');
      print('Stack: $stack');
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  // Обновление соревнования с синхронизацией
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
      CompetitionLocal? updatedCompetition;

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
        competition.updatedAt = DateTime.now();
        competition.isSynced = false;

        await isar.competitionLocals.put(competition);
        print('✅ Competition updated successfully');

        updatedCompetition = competition;
      });

      // Синхронизация с Firebase
      if (updatedCompetition != null) {
        print('🔄 Syncing updated competition to Firebase...');
        try {
          await syncService.syncCompetitionToFirebase(updatedCompetition!);
          print('✅ Competition synced to Firebase successfully');
        } catch (e) {
          print('⚠️ Error syncing to Firebase (will retry later): $e');
        }
      }

      print('🔵 Reloading competitions after update');
      await loadAllCompetitionsForDevice();
    } catch (e, stack) {
      print('❌ Error updating competition: $e');
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  // Удаление соревнования с синхронизацией
  Future<void> deleteCompetition(int id) async {
    print('🔵 deleteCompetition() called with ID: $id');
    try {
      // Получаем serverId перед удалением
      final competition = await isar.competitionLocals.get(id);
      final serverId = competition?.serverId;

      // ✅ Каскадное удаление: соревнование + команды + жеребьёвка + взвешивания + протоколы
      await IsarService().deleteCompetition(id);
      print('✅ Competition and all related data deleted locally');

      // Удаление из Firebase
      if (serverId != null && serverId.isNotEmpty) {
        print('🔄 Deleting competition from Firebase...');
        try {
          await syncService.deleteCompetitionFromFirebase(serverId);
          print('✅ Competition deleted from Firebase successfully');
        } catch (e) {
          print('⚠️ Error deleting from Firebase: $e');
        }
      } else {
        print('⚠️ No serverId found - competition was not synced to Firebase');
      }

      await loadAllCompetitionsForDevice();
    } catch (e, stack) {
      print('❌ Error deleting competition: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  // Обновление статуса с синхронизацией
  Future<void> updateCompetitionStatus(int id, String newStatus) async {
    print('🔵 updateCompetitionStatus() called: ID=$id, Status=$newStatus');
    try {
      CompetitionLocal? updatedCompetition;

      await isar.writeTxn(() async {
        final competition = await isar.competitionLocals.get(id);
        if (competition != null) {
          competition.status = newStatus;
          competition.updatedAt = DateTime.now();
          competition.isSynced = false;
          if (newStatus == 'completed') {
            competition.finalizedAt = DateTime.now();
          }
          await isar.competitionLocals.put(competition);
          print('✅ Competition status updated locally');
          updatedCompetition = competition;
        }
      });

      // Синхронизация с Firebase
      if (updatedCompetition != null) {
        print('🔄 Syncing status update to Firebase...');
        try {
          await syncService.syncCompetitionToFirebase(updatedCompetition!);
          print('✅ Status synced to Firebase successfully');
        } catch (e) {
          print('⚠️ Error syncing status to Firebase (will retry later): $e');
        }
      }

      await loadAllCompetitionsForDevice();
    } catch (e, stack) {
      print('❌ Error updating competition status: $e');
      state = AsyncValue.error(e, stack);
    }
  }
}