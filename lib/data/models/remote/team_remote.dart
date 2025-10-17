import 'package:cloud_firestore/cloud_firestore.dart';
import '../local/team_local.dart';

/// Remote модель для синхронизации TeamLocal с Firestore
///
/// Структура в Firestore:
/// /competitions/{competitionId}/teams/{teamId}
///   - name, city, club
///   - members[] (массив Map с fullName, isCaptain, rank, rod?, line?)
///   - penalties[] (массив Map)
///   - sector, drawOrder
///   - createdAt, updatedAt (Timestamp)
class TeamRemote {
  final String id; // serverId в Firestore
  final String competitionId; // ID родительского соревнования
  final String name;
  final String city;
  final String? club;

  final List<TeamMemberRemote> members;
  final List<PenaltyRemote> penalties;

  final int? sector;
  final int? drawOrder;

  final DateTime createdAt;
  final DateTime updatedAt;

  TeamRemote({
    required this.id,
    required this.competitionId,
    required this.name,
    required this.city,
    this.club,
    this.members = const [],
    this.penalties = const [],
    this.sector,
    this.drawOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Конвертация в Map для сохранения в Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'competitionId': competitionId,
      'name': name,
      'city': city,
      'club': club,
      'members': members.map((m) => m.toMap()).toList(),
      'penalties': penalties.map((p) => p.toMap()).toList(),
      'sector': sector,
      'drawOrder': drawOrder,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Создание из Firestore документа
  factory TeamRemote.fromFirestore(
      Map<String, dynamic> data,
      String id,
      ) {
    return TeamRemote(
      id: id,
      competitionId: data['competitionId'] as String,
      name: data['name'] as String,
      city: data['city'] as String,
      club: data['club'] as String?,
      members: (data['members'] as List<dynamic>?)
          ?.map((m) => TeamMemberRemote.fromMap(m as Map<String, dynamic>))
          .toList() ?? [],
      penalties: (data['penalties'] as List<dynamic>?)
          ?.map((p) => PenaltyRemote.fromMap(p as Map<String, dynamic>))
          .toList() ?? [],
      sector: data['sector'] as int?,
      drawOrder: data['drawOrder'] as int?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Создание из TeamLocal (для синхронизации Local → Remote)
  factory TeamRemote.fromLocal(TeamLocal local, String competitionServerId) {
    return TeamRemote(
      id: local.serverId ?? '', // Если serverId == null, будет создан новый документ
      competitionId: competitionServerId,
      name: local.name,
      city: local.city,
      club: local.club,
      members: local.members.map((m) => TeamMemberRemote.fromLocal(m)).toList(),
      penalties: local.penalties.map((p) => PenaltyRemote.fromLocal(p)).toList(),
      sector: local.sector,
      drawOrder: local.drawOrder,
      createdAt: local.createdAt,
      updatedAt: local.updatedAt,
    );
  }

  /// Конвертация обратно в TeamLocal (для синхронизации Remote → Local)
  TeamLocal toLocal(int competitionLocalId) {
    return TeamLocal()
      ..id = 0
      ..serverId = id
      ..competitionLocalId = competitionLocalId
      ..name = name
      ..city = city
      ..club = club
      ..members = members.map((m) => m.toLocal()).toList()
      ..penalties = penalties.map((p) => p.toLocal()).toList()
      ..sector = sector
      ..drawOrder = drawOrder
      ..isSynced = true
      ..lastSyncedAt = DateTime.now()
      ..createdAt = createdAt
      ..updatedAt = updatedAt;
  }
}

/// Remote модель для TeamMember (embedded в Team)
class TeamMemberRemote {
  final String fullName;
  final bool isCaptain;
  final String rank;
  final String? rod; // Для кастинга
  final String? line; // Для кастинга

  TeamMemberRemote({
    required this.fullName,
    required this.isCaptain,
    required this.rank,
    this.rod,
    this.line,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'isCaptain': isCaptain,
      'rank': rank,
      'rod': rod,
      'line': line,
    };
  }

  factory TeamMemberRemote.fromMap(Map<String, dynamic> map) {
    return TeamMemberRemote(
      fullName: map['fullName'] as String,
      isCaptain: map['isCaptain'] as bool,
      rank: map['rank'] as String,
      rod: map['rod'] as String?,
      line: map['line'] as String?,
    );
  }

  factory TeamMemberRemote.fromLocal(TeamMember local) {
    return TeamMemberRemote(
      fullName: local.fullName,
      isCaptain: local.isCaptain,
      rank: local.rank,
      rod: local.rod,
      line: local.line,
    );
  }

  TeamMember toLocal() {
    return TeamMember()
      ..fullName = fullName
      ..isCaptain = isCaptain
      ..rank = rank
      ..rod = rod
      ..line = line;
  }
}

/// Remote модель для Penalty (embedded в Team)
class PenaltyRemote {
  final String id;
  final String description;
  final DateTime createdAt;
  final String addedByJudgeId;

  PenaltyRemote({
    required this.id,
    required this.description,
    required this.createdAt,
    required this.addedByJudgeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'addedByJudgeId': addedByJudgeId,
    };
  }

  factory PenaltyRemote.fromMap(Map<String, dynamic> map) {
    return PenaltyRemote(
      id: map['id'] as String,
      description: map['description'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      addedByJudgeId: map['addedByJudgeId'] as String,
    );
  }

  factory PenaltyRemote.fromLocal(Penalty local) {
    return PenaltyRemote(
      id: local.id,
      description: local.description,
      createdAt: local.createdAt,
      addedByJudgeId: local.addedByJudgeId,
    );
  }

  Penalty toLocal() {
    return Penalty()
      ..id = id
      ..description = description
      ..createdAt = createdAt
      ..addedByJudgeId = addedByJudgeId;
  }
}