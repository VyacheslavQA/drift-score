import 'package:cloud_firestore/cloud_firestore.dart';
import '../local/competition_local.dart';

/// Remote модель для синхронизации CompetitionLocal с Firestore
///
/// Структура в Firestore:
/// /competitions/{competitionId}
///   - name, cityOrRegion, organizerName, lakeName
///   - startTime, finishTime (Timestamp)
///   - fishingType, scoringMethod, sectorStructure
///   - sectorsCount, attemptsCount, commonLine
///   - zonedType, zonesCount, sectorsPerZone, lakeNames
///   - status, accessCode, createdByDeviceId
///   - judges[] (массив Map)
///   - isFinal, finalizedAt (Timestamp?)
///   - editHistory[] (массив Map)
///   - createdAt, updatedAt (Timestamp)
class CompetitionRemote {
  final String id; // serverId в Firestore
  final String name;
  final String cityOrRegion;
  final String organizerName;
  final String lakeName;

  final DateTime startTime;
  final DateTime finishTime;

  final String fishingType;
  final String scoringMethod;
  final String sectorStructure;

  final String? zonedType;
  final int? zonesCount;
  final int? sectorsPerZone;
  final List<String> lakeNames;

  final int sectorsCount;
  final int? attemptsCount;
  final String? commonLine;

  final String status;
  final String? accessCode;
  final String? createdByDeviceId;

  final List<JudgeRemote> judges;

  final bool isFinal;
  final DateTime? finalizedAt;
  final List<EditLogRemote> editHistory;

  final DateTime createdAt;
  final DateTime? updatedAt;

  CompetitionRemote({
    required this.id,
    required this.name,
    required this.cityOrRegion,
    required this.organizerName,
    required this.lakeName,
    required this.startTime,
    required this.finishTime,
    required this.fishingType,
    required this.scoringMethod,
    required this.sectorStructure,
    this.zonedType,
    this.zonesCount,
    this.sectorsPerZone,
    this.lakeNames = const [],
    required this.sectorsCount,
    this.attemptsCount,
    this.commonLine,
    required this.status,
    this.accessCode,
    this.createdByDeviceId,
    this.judges = const [],
    required this.isFinal,
    this.finalizedAt,
    this.editHistory = const [],
    required this.createdAt,
    this.updatedAt,
  });

  /// Конвертация в Map для сохранения в Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'cityOrRegion': cityOrRegion,
      'organizerName': organizerName,
      'lakeName': lakeName,
      'startTime': Timestamp.fromDate(startTime),
      'finishTime': Timestamp.fromDate(finishTime),
      'fishingType': fishingType,
      'scoringMethod': scoringMethod,
      'sectorStructure': sectorStructure,
      'zonedType': zonedType,
      'zonesCount': zonesCount,
      'sectorsPerZone': sectorsPerZone,
      'lakeNames': lakeNames,
      'sectorsCount': sectorsCount,
      'attemptsCount': attemptsCount,
      'commonLine': commonLine,
      'status': status,
      'accessCode': accessCode,
      'createdByDeviceId': createdByDeviceId,
      'judges': judges.map((j) => j.toMap()).toList(),
      'isFinal': isFinal,
      'finalizedAt': finalizedAt != null ? Timestamp.fromDate(finalizedAt!) : null,
      'editHistory': editHistory.map((e) => e.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  /// Создание из Firestore документа
  factory CompetitionRemote.fromFirestore(
      Map<String, dynamic> data,
      String id,
      ) {
    return CompetitionRemote(
      id: id,
      name: data['name'] as String,
      cityOrRegion: data['cityOrRegion'] as String,
      organizerName: data['organizerName'] as String,
      lakeName: data['lakeName'] as String,
      startTime: (data['startTime'] as Timestamp).toDate(),
      finishTime: (data['finishTime'] as Timestamp).toDate(),
      fishingType: data['fishingType'] as String,
      scoringMethod: data['scoringMethod'] as String,
      sectorStructure: data['sectorStructure'] as String,
      zonedType: data['zonedType'] as String?,
      zonesCount: data['zonesCount'] as int?,
      sectorsPerZone: data['sectorsPerZone'] as int?,
      lakeNames: (data['lakeNames'] as List<dynamic>?)?.cast<String>() ?? [],
      sectorsCount: data['sectorsCount'] as int,
      attemptsCount: data['attemptsCount'] as int?,
      commonLine: data['commonLine'] as String?,
      status: data['status'] as String,
      accessCode: data['accessCode'] as String?,
      createdByDeviceId: data['createdByDeviceId'] as String?,
      judges: (data['judges'] as List<dynamic>?)
          ?.map((j) => JudgeRemote.fromMap(j as Map<String, dynamic>))
          .toList() ?? [],
      isFinal: data['isFinal'] as bool,
      finalizedAt: data['finalizedAt'] != null
          ? (data['finalizedAt'] as Timestamp).toDate()
          : null,
      editHistory: (data['editHistory'] as List<dynamic>?)
          ?.map((e) => EditLogRemote.fromMap(e as Map<String, dynamic>))
          .toList() ?? [],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Создание из CompetitionLocal (для синхронизации Local → Remote)
  factory CompetitionRemote.fromLocal(CompetitionLocal local) {
    return CompetitionRemote(
      id: local.serverId ?? '', // Если serverId == null, будет создан новый документ
      name: local.name,
      cityOrRegion: local.cityOrRegion,
      organizerName: local.organizerName,
      lakeName: local.lakeName,
      startTime: local.startTime,
      finishTime: local.finishTime,
      fishingType: local.fishingType,
      scoringMethod: local.scoringMethod,
      sectorStructure: local.sectorStructure,
      zonedType: local.zonedType,
      zonesCount: local.zonesCount,
      sectorsPerZone: local.sectorsPerZone,
      lakeNames: List<String>.from(local.lakeNames),
      sectorsCount: local.sectorsCount,
      attemptsCount: local.attemptsCount,
      commonLine: local.commonLine,
      status: local.status,
      accessCode: local.accessCode,
      createdByDeviceId: local.createdByDeviceId,
      judges: local.judges.map((j) => JudgeRemote.fromLocal(j)).toList(),
      isFinal: local.isFinal,
      finalizedAt: local.finalizedAt,
      editHistory: local.editHistory.map((e) => EditLogRemote.fromLocal(e)).toList(),
      createdAt: local.createdAt,
      updatedAt: local.updatedAt,
    );
  }

  /// Конвертация обратно в CompetitionLocal (для синхронизации Remote → Local)
  CompetitionLocal toLocal(int localId) {
    return CompetitionLocal()
      ..id = localId
      ..serverId = id
      ..name = name
      ..cityOrRegion = cityOrRegion
      ..organizerName = organizerName
      ..lakeName = lakeName
      ..startTime = startTime
      ..finishTime = finishTime
      ..fishingType = fishingType
      ..scoringMethod = scoringMethod
      ..sectorStructure = sectorStructure
      ..zonedType = zonedType
      ..zonesCount = zonesCount
      ..sectorsPerZone = sectorsPerZone
      ..lakeNames = List<String>.from(lakeNames)
      ..sectorsCount = sectorsCount
      ..attemptsCount = attemptsCount
      ..commonLine = commonLine
      ..status = status
      ..accessCode = accessCode
      ..createdByDeviceId = createdByDeviceId
      ..judges = judges.map((j) => j.toLocal()).toList()
      ..isFinal = isFinal
      ..finalizedAt = finalizedAt
      ..editHistory = editHistory.map((e) => e.toLocal()).toList()
      ..isSynced = true
      ..lastSyncedAt = DateTime.now()
      ..createdAt = createdAt
      ..updatedAt = updatedAt;
  }
}

/// Remote модель для Judge (embedded в Competition)
class JudgeRemote {
  final String id;
  final String fullName;
  final String rank;

  JudgeRemote({
    required this.id,
    required this.fullName,
    required this.rank,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'rank': rank,
    };
  }

  factory JudgeRemote.fromMap(Map<String, dynamic> map) {
    return JudgeRemote(
      id: map['id'] as String,
      fullName: map['fullName'] as String,
      rank: map['rank'] as String,
    );
  }

  factory JudgeRemote.fromLocal(Judge local) {
    return JudgeRemote(
      id: local.id,
      fullName: local.fullName,
      rank: local.rank,
    );
  }

  Judge toLocal() {
    return Judge()
      ..id = id
      ..fullName = fullName
      ..rank = rank;
  }
}

/// Remote модель для EditLog (embedded в Competition)
class EditLogRemote {
  final String id;
  final DateTime timestamp;
  final String judgeId;
  final String action;

  EditLogRemote({
    required this.id,
    required this.timestamp,
    required this.judgeId,
    required this.action,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': Timestamp.fromDate(timestamp),
      'judgeId': judgeId,
      'action': action,
    };
  }

  factory EditLogRemote.fromMap(Map<String, dynamic> map) {
    return EditLogRemote(
      id: map['id'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      judgeId: map['judgeId'] as String,
      action: map['action'] as String,
    );
  }

  factory EditLogRemote.fromLocal(EditLog local) {
    return EditLogRemote(
      id: local.id,
      timestamp: local.timestamp,
      judgeId: local.judgeId,
      action: local.action,
    );
  }

  EditLog toLocal() {
    return EditLog()
      ..id = id
      ..timestamp = timestamp
      ..judgeId = judgeId
      ..action = action;
  }
}