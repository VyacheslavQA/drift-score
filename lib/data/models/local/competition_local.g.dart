// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_local.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCompetitionLocalCollection on Isar {
  IsarCollection<CompetitionLocal> get competitionLocals => this.collection();
}

const CompetitionLocalSchema = CollectionSchema(
  name: r'CompetitionLocal',
  id: 3168741829174686923,
  properties: {
    r'accessCode': PropertySchema(
      id: 0,
      name: r'accessCode',
      type: IsarType.string,
    ),
    r'attemptsCount': PropertySchema(
      id: 1,
      name: r'attemptsCount',
      type: IsarType.long,
    ),
    r'cityOrRegion': PropertySchema(
      id: 2,
      name: r'cityOrRegion',
      type: IsarType.string,
    ),
    r'commonLine': PropertySchema(
      id: 3,
      name: r'commonLine',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'createdByDeviceId': PropertySchema(
      id: 5,
      name: r'createdByDeviceId',
      type: IsarType.string,
    ),
    r'durationDays': PropertySchema(
      id: 6,
      name: r'durationDays',
      type: IsarType.long,
    ),
    r'durationHours': PropertySchema(
      id: 7,
      name: r'durationHours',
      type: IsarType.long,
    ),
    r'editHistory': PropertySchema(
      id: 8,
      name: r'editHistory',
      type: IsarType.objectList,
      target: r'EditLog',
    ),
    r'finalizedAt': PropertySchema(
      id: 9,
      name: r'finalizedAt',
      type: IsarType.dateTime,
    ),
    r'finishTime': PropertySchema(
      id: 10,
      name: r'finishTime',
      type: IsarType.dateTime,
    ),
    r'fishingType': PropertySchema(
      id: 11,
      name: r'fishingType',
      type: IsarType.string,
    ),
    r'isFinal': PropertySchema(
      id: 12,
      name: r'isFinal',
      type: IsarType.bool,
    ),
    r'isSynced': PropertySchema(
      id: 13,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'judges': PropertySchema(
      id: 14,
      name: r'judges',
      type: IsarType.objectList,
      target: r'Judge',
    ),
    r'lakeName': PropertySchema(
      id: 15,
      name: r'lakeName',
      type: IsarType.string,
    ),
    r'lakeNames': PropertySchema(
      id: 16,
      name: r'lakeNames',
      type: IsarType.stringList,
    ),
    r'lastSyncedAt': PropertySchema(
      id: 17,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(
      id: 18,
      name: r'name',
      type: IsarType.string,
    ),
    r'organizerName': PropertySchema(
      id: 19,
      name: r'organizerName',
      type: IsarType.string,
    ),
    r'scoringMethod': PropertySchema(
      id: 20,
      name: r'scoringMethod',
      type: IsarType.string,
    ),
    r'sectorStructure': PropertySchema(
      id: 21,
      name: r'sectorStructure',
      type: IsarType.string,
    ),
    r'sectorsCount': PropertySchema(
      id: 22,
      name: r'sectorsCount',
      type: IsarType.long,
    ),
    r'sectorsPerZone': PropertySchema(
      id: 23,
      name: r'sectorsPerZone',
      type: IsarType.long,
    ),
    r'serverId': PropertySchema(
      id: 24,
      name: r'serverId',
      type: IsarType.string,
    ),
    r'startTime': PropertySchema(
      id: 25,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 26,
      name: r'status',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 27,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'zonedType': PropertySchema(
      id: 28,
      name: r'zonedType',
      type: IsarType.string,
    ),
    r'zonesCount': PropertySchema(
      id: 29,
      name: r'zonesCount',
      type: IsarType.long,
    )
  },
  estimateSize: _competitionLocalEstimateSize,
  serialize: _competitionLocalSerialize,
  deserialize: _competitionLocalDeserialize,
  deserializeProp: _competitionLocalDeserializeProp,
  idName: r'id',
  indexes: {
    r'serverId': IndexSchema(
      id: -7950187970872907662,
      name: r'serverId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'serverId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'accessCode': IndexSchema(
      id: -4762309729008467959,
      name: r'accessCode',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'accessCode',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'Judge': JudgeSchema, r'EditLog': EditLogSchema},
  getId: _competitionLocalGetId,
  getLinks: _competitionLocalGetLinks,
  attach: _competitionLocalAttach,
  version: '3.3.0-dev.3',
);

int _competitionLocalEstimateSize(
  CompetitionLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.accessCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.cityOrRegion.length * 3;
  {
    final value = object.commonLine;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.createdByDeviceId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.editHistory.length * 3;
  {
    final offsets = allOffsets[EditLog]!;
    for (var i = 0; i < object.editHistory.length; i++) {
      final value = object.editHistory[i];
      bytesCount += EditLogSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.fishingType.length * 3;
  bytesCount += 3 + object.judges.length * 3;
  {
    final offsets = allOffsets[Judge]!;
    for (var i = 0; i < object.judges.length; i++) {
      final value = object.judges[i];
      bytesCount += JudgeSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.lakeName.length * 3;
  bytesCount += 3 + object.lakeNames.length * 3;
  {
    for (var i = 0; i < object.lakeNames.length; i++) {
      final value = object.lakeNames[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.organizerName.length * 3;
  bytesCount += 3 + object.scoringMethod.length * 3;
  bytesCount += 3 + object.sectorStructure.length * 3;
  {
    final value = object.serverId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.status.length * 3;
  {
    final value = object.zonedType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _competitionLocalSerialize(
  CompetitionLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accessCode);
  writer.writeLong(offsets[1], object.attemptsCount);
  writer.writeString(offsets[2], object.cityOrRegion);
  writer.writeString(offsets[3], object.commonLine);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeString(offsets[5], object.createdByDeviceId);
  writer.writeLong(offsets[6], object.durationDays);
  writer.writeLong(offsets[7], object.durationHours);
  writer.writeObjectList<EditLog>(
    offsets[8],
    allOffsets,
    EditLogSchema.serialize,
    object.editHistory,
  );
  writer.writeDateTime(offsets[9], object.finalizedAt);
  writer.writeDateTime(offsets[10], object.finishTime);
  writer.writeString(offsets[11], object.fishingType);
  writer.writeBool(offsets[12], object.isFinal);
  writer.writeBool(offsets[13], object.isSynced);
  writer.writeObjectList<Judge>(
    offsets[14],
    allOffsets,
    JudgeSchema.serialize,
    object.judges,
  );
  writer.writeString(offsets[15], object.lakeName);
  writer.writeStringList(offsets[16], object.lakeNames);
  writer.writeDateTime(offsets[17], object.lastSyncedAt);
  writer.writeString(offsets[18], object.name);
  writer.writeString(offsets[19], object.organizerName);
  writer.writeString(offsets[20], object.scoringMethod);
  writer.writeString(offsets[21], object.sectorStructure);
  writer.writeLong(offsets[22], object.sectorsCount);
  writer.writeLong(offsets[23], object.sectorsPerZone);
  writer.writeString(offsets[24], object.serverId);
  writer.writeDateTime(offsets[25], object.startTime);
  writer.writeString(offsets[26], object.status);
  writer.writeDateTime(offsets[27], object.updatedAt);
  writer.writeString(offsets[28], object.zonedType);
  writer.writeLong(offsets[29], object.zonesCount);
}

CompetitionLocal _competitionLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CompetitionLocal();
  object.accessCode = reader.readStringOrNull(offsets[0]);
  object.attemptsCount = reader.readLongOrNull(offsets[1]);
  object.cityOrRegion = reader.readString(offsets[2]);
  object.commonLine = reader.readStringOrNull(offsets[3]);
  object.createdAt = reader.readDateTime(offsets[4]);
  object.createdByDeviceId = reader.readStringOrNull(offsets[5]);
  object.editHistory = reader.readObjectList<EditLog>(
        offsets[8],
        EditLogSchema.deserialize,
        allOffsets,
        EditLog(),
      ) ??
      [];
  object.finalizedAt = reader.readDateTimeOrNull(offsets[9]);
  object.finishTime = reader.readDateTime(offsets[10]);
  object.fishingType = reader.readString(offsets[11]);
  object.id = id;
  object.isFinal = reader.readBool(offsets[12]);
  object.isSynced = reader.readBool(offsets[13]);
  object.judges = reader.readObjectList<Judge>(
        offsets[14],
        JudgeSchema.deserialize,
        allOffsets,
        Judge(),
      ) ??
      [];
  object.lakeName = reader.readString(offsets[15]);
  object.lakeNames = reader.readStringList(offsets[16]) ?? [];
  object.lastSyncedAt = reader.readDateTimeOrNull(offsets[17]);
  object.name = reader.readString(offsets[18]);
  object.organizerName = reader.readString(offsets[19]);
  object.scoringMethod = reader.readString(offsets[20]);
  object.sectorStructure = reader.readString(offsets[21]);
  object.sectorsCount = reader.readLong(offsets[22]);
  object.sectorsPerZone = reader.readLongOrNull(offsets[23]);
  object.serverId = reader.readStringOrNull(offsets[24]);
  object.startTime = reader.readDateTime(offsets[25]);
  object.status = reader.readString(offsets[26]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[27]);
  object.zonedType = reader.readStringOrNull(offsets[28]);
  object.zonesCount = reader.readLongOrNull(offsets[29]);
  return object;
}

P _competitionLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readObjectList<EditLog>(
            offset,
            EditLogSchema.deserialize,
            allOffsets,
            EditLog(),
          ) ??
          []) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readObjectList<Judge>(
            offset,
            JudgeSchema.deserialize,
            allOffsets,
            Judge(),
          ) ??
          []) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readStringList(offset) ?? []) as P;
    case 17:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readString(offset)) as P;
    case 20:
      return (reader.readString(offset)) as P;
    case 21:
      return (reader.readString(offset)) as P;
    case 22:
      return (reader.readLong(offset)) as P;
    case 23:
      return (reader.readLongOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readDateTime(offset)) as P;
    case 26:
      return (reader.readString(offset)) as P;
    case 27:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 28:
      return (reader.readStringOrNull(offset)) as P;
    case 29:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _competitionLocalGetId(CompetitionLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _competitionLocalGetLinks(CompetitionLocal object) {
  return [];
}

void _competitionLocalAttach(
    IsarCollection<dynamic> col, Id id, CompetitionLocal object) {
  object.id = id;
}

extension CompetitionLocalByIndex on IsarCollection<CompetitionLocal> {
  Future<CompetitionLocal?> getByServerId(String? serverId) {
    return getByIndex(r'serverId', [serverId]);
  }

  CompetitionLocal? getByServerIdSync(String? serverId) {
    return getByIndexSync(r'serverId', [serverId]);
  }

  Future<bool> deleteByServerId(String? serverId) {
    return deleteByIndex(r'serverId', [serverId]);
  }

  bool deleteByServerIdSync(String? serverId) {
    return deleteByIndexSync(r'serverId', [serverId]);
  }

  Future<List<CompetitionLocal?>> getAllByServerId(
      List<String?> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'serverId', values);
  }

  List<CompetitionLocal?> getAllByServerIdSync(List<String?> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'serverId', values);
  }

  Future<int> deleteAllByServerId(List<String?> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'serverId', values);
  }

  int deleteAllByServerIdSync(List<String?> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'serverId', values);
  }

  Future<Id> putByServerId(CompetitionLocal object) {
    return putByIndex(r'serverId', object);
  }

  Id putByServerIdSync(CompetitionLocal object, {bool saveLinks = true}) {
    return putByIndexSync(r'serverId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByServerId(List<CompetitionLocal> objects) {
    return putAllByIndex(r'serverId', objects);
  }

  List<Id> putAllByServerIdSync(List<CompetitionLocal> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'serverId', objects, saveLinks: saveLinks);
  }

  Future<CompetitionLocal?> getByAccessCode(String? accessCode) {
    return getByIndex(r'accessCode', [accessCode]);
  }

  CompetitionLocal? getByAccessCodeSync(String? accessCode) {
    return getByIndexSync(r'accessCode', [accessCode]);
  }

  Future<bool> deleteByAccessCode(String? accessCode) {
    return deleteByIndex(r'accessCode', [accessCode]);
  }

  bool deleteByAccessCodeSync(String? accessCode) {
    return deleteByIndexSync(r'accessCode', [accessCode]);
  }

  Future<List<CompetitionLocal?>> getAllByAccessCode(
      List<String?> accessCodeValues) {
    final values = accessCodeValues.map((e) => [e]).toList();
    return getAllByIndex(r'accessCode', values);
  }

  List<CompetitionLocal?> getAllByAccessCodeSync(
      List<String?> accessCodeValues) {
    final values = accessCodeValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'accessCode', values);
  }

  Future<int> deleteAllByAccessCode(List<String?> accessCodeValues) {
    final values = accessCodeValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'accessCode', values);
  }

  int deleteAllByAccessCodeSync(List<String?> accessCodeValues) {
    final values = accessCodeValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'accessCode', values);
  }

  Future<Id> putByAccessCode(CompetitionLocal object) {
    return putByIndex(r'accessCode', object);
  }

  Id putByAccessCodeSync(CompetitionLocal object, {bool saveLinks = true}) {
    return putByIndexSync(r'accessCode', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAccessCode(List<CompetitionLocal> objects) {
    return putAllByIndex(r'accessCode', objects);
  }

  List<Id> putAllByAccessCodeSync(List<CompetitionLocal> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'accessCode', objects, saveLinks: saveLinks);
  }
}

extension CompetitionLocalQueryWhereSort
    on QueryBuilder<CompetitionLocal, CompetitionLocal, QWhere> {
  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CompetitionLocalQueryWhere
    on QueryBuilder<CompetitionLocal, CompetitionLocal, QWhereClause> {
  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterWhereClause>
      serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [null],
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterWhereClause>
      serverIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'serverId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterWhereClause>
      serverIdEqualTo(String? serverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [serverId],
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterWhereClause>
      serverIdNotEqualTo(String? serverId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverId',
              lower: [],
              upper: [serverId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverId',
              lower: [serverId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverId',
              lower: [serverId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverId',
              lower: [],
              upper: [serverId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterWhereClause>
      accessCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'accessCode',
        value: [null],
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterWhereClause>
      accessCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'accessCode',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterWhereClause>
      accessCodeEqualTo(String? accessCode) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'accessCode',
        value: [accessCode],
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterWhereClause>
      accessCodeNotEqualTo(String? accessCode) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'accessCode',
              lower: [],
              upper: [accessCode],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'accessCode',
              lower: [accessCode],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'accessCode',
              lower: [accessCode],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'accessCode',
              lower: [],
              upper: [accessCode],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CompetitionLocalQueryFilter
    on QueryBuilder<CompetitionLocal, CompetitionLocal, QFilterCondition> {
  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      accessCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'accessCode',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      accessCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'accessCode',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      accessCodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accessCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      accessCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accessCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      accessCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accessCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      accessCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accessCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      accessCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'accessCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      accessCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'accessCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      accessCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'accessCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      accessCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'accessCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      accessCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accessCode',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      accessCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'accessCode',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      attemptsCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'attemptsCount',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      attemptsCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'attemptsCount',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      attemptsCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'attemptsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      attemptsCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'attemptsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      attemptsCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'attemptsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      attemptsCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'attemptsCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      cityOrRegionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cityOrRegion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      cityOrRegionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cityOrRegion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      cityOrRegionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cityOrRegion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      cityOrRegionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cityOrRegion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      cityOrRegionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cityOrRegion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      cityOrRegionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cityOrRegion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      cityOrRegionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cityOrRegion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      cityOrRegionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cityOrRegion',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      cityOrRegionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cityOrRegion',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      cityOrRegionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cityOrRegion',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      commonLineIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'commonLine',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      commonLineIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'commonLine',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      commonLineEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commonLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      commonLineGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'commonLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      commonLineLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'commonLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      commonLineBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'commonLine',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      commonLineStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'commonLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      commonLineEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'commonLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      commonLineContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'commonLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      commonLineMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'commonLine',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      commonLineIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commonLine',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      commonLineIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'commonLine',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      createdByDeviceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdByDeviceId',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      createdByDeviceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdByDeviceId',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      createdByDeviceIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdByDeviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      createdByDeviceIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdByDeviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      createdByDeviceIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdByDeviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      createdByDeviceIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdByDeviceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      createdByDeviceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'createdByDeviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      createdByDeviceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'createdByDeviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      createdByDeviceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdByDeviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      createdByDeviceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdByDeviceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      createdByDeviceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdByDeviceId',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      createdByDeviceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createdByDeviceId',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      durationDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationDays',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      durationDaysGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationDays',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      durationDaysLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationDays',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      durationDaysBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      durationHoursEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationHours',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      durationHoursGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationHours',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      durationHoursLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationHours',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      durationHoursBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationHours',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      editHistoryLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'editHistory',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      editHistoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'editHistory',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      editHistoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'editHistory',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      editHistoryLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'editHistory',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      editHistoryLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'editHistory',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      editHistoryLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'editHistory',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      finalizedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'finalizedAt',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      finalizedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'finalizedAt',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      finalizedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'finalizedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      finalizedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'finalizedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      finalizedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'finalizedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      finalizedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'finalizedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      finishTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'finishTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      finishTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'finishTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      finishTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'finishTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      finishTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'finishTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      fishingTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fishingType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      fishingTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fishingType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      fishingTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fishingType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      fishingTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fishingType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      fishingTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fishingType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      fishingTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fishingType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      fishingTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fishingType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      fishingTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fishingType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      fishingTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fishingType',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      fishingTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fishingType',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      isFinalEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFinal',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      judgesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'judges',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      judgesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'judges',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      judgesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'judges',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      judgesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'judges',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      judgesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'judges',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      judgesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'judges',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lakeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lakeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lakeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lakeName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lakeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lakeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lakeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lakeName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lakeName',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lakeName',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNamesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lakeNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNamesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lakeNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNamesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lakeNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNamesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lakeNames',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNamesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lakeNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNamesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lakeNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNamesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lakeNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNamesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lakeNames',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNamesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lakeNames',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNamesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lakeNames',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNamesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lakeNames',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNamesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lakeNames',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNamesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lakeNames',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNamesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lakeNames',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNamesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lakeNames',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lakeNamesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lakeNames',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lastSyncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lastSyncedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lastSyncedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      lastSyncedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSyncedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      organizerNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'organizerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      organizerNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'organizerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      organizerNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'organizerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      organizerNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'organizerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      organizerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'organizerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      organizerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'organizerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      organizerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'organizerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      organizerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'organizerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      organizerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'organizerName',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      organizerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'organizerName',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      scoringMethodEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scoringMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      scoringMethodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scoringMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      scoringMethodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scoringMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      scoringMethodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scoringMethod',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      scoringMethodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'scoringMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      scoringMethodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'scoringMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      scoringMethodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'scoringMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      scoringMethodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'scoringMethod',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      scoringMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scoringMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      scoringMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'scoringMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorStructureEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sectorStructure',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorStructureGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sectorStructure',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorStructureLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sectorStructure',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorStructureBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sectorStructure',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorStructureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sectorStructure',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorStructureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sectorStructure',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorStructureContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sectorStructure',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorStructureMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sectorStructure',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorStructureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sectorStructure',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorStructureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sectorStructure',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorsCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sectorsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorsCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sectorsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorsCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sectorsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorsCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sectorsCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorsPerZoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sectorsPerZone',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorsPerZoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sectorsPerZone',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorsPerZoneEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sectorsPerZone',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorsPerZoneGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sectorsPerZone',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorsPerZoneLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sectorsPerZone',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      sectorsPerZoneBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sectorsPerZone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      serverIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      serverIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      serverIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      serverIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      serverIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serverId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      serverIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      serverIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      serverIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      serverIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serverId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      serverIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      serverIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      startTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      startTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      startTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      startTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      zonedTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'zonedType',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      zonedTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'zonedType',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      zonedTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zonedType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      zonedTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'zonedType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      zonedTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'zonedType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      zonedTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'zonedType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      zonedTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'zonedType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      zonedTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'zonedType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      zonedTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'zonedType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      zonedTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'zonedType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      zonedTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zonedType',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      zonedTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'zonedType',
        value: '',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      zonesCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'zonesCount',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      zonesCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'zonesCount',
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      zonesCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zonesCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      zonesCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'zonesCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      zonesCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'zonesCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      zonesCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'zonesCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CompetitionLocalQueryObject
    on QueryBuilder<CompetitionLocal, CompetitionLocal, QFilterCondition> {
  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      editHistoryElement(FilterQuery<EditLog> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'editHistory');
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterFilterCondition>
      judgesElement(FilterQuery<Judge> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'judges');
    });
  }
}

extension CompetitionLocalQueryLinks
    on QueryBuilder<CompetitionLocal, CompetitionLocal, QFilterCondition> {}

extension CompetitionLocalQuerySortBy
    on QueryBuilder<CompetitionLocal, CompetitionLocal, QSortBy> {
  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByAccessCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessCode', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByAccessCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessCode', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByAttemptsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptsCount', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByAttemptsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptsCount', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByCityOrRegion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityOrRegion', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByCityOrRegionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityOrRegion', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByCommonLine() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commonLine', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByCommonLineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commonLine', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByCreatedByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdByDeviceId', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByCreatedByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdByDeviceId', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByDurationDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationDays', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByDurationDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationDays', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByDurationHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationHours', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByDurationHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationHours', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByFinalizedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalizedAt', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByFinalizedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalizedAt', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByFinishTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishTime', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByFinishTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishTime', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByFishingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fishingType', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByFishingTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fishingType', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByIsFinal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFinal', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByIsFinalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFinal', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByLakeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lakeName', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByLakeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lakeName', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByOrganizerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organizerName', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByOrganizerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organizerName', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByScoringMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoringMethod', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByScoringMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoringMethod', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortBySectorStructure() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectorStructure', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortBySectorStructureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectorStructure', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortBySectorsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectorsCount', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortBySectorsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectorsCount', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortBySectorsPerZone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectorsPerZone', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortBySectorsPerZoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectorsPerZone', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByZonedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zonedType', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByZonedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zonedType', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByZonesCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zonesCount', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      sortByZonesCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zonesCount', Sort.desc);
    });
  }
}

extension CompetitionLocalQuerySortThenBy
    on QueryBuilder<CompetitionLocal, CompetitionLocal, QSortThenBy> {
  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByAccessCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessCode', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByAccessCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessCode', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByAttemptsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptsCount', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByAttemptsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptsCount', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByCityOrRegion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityOrRegion', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByCityOrRegionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityOrRegion', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByCommonLine() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commonLine', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByCommonLineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commonLine', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByCreatedByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdByDeviceId', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByCreatedByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdByDeviceId', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByDurationDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationDays', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByDurationDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationDays', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByDurationHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationHours', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByDurationHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationHours', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByFinalizedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalizedAt', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByFinalizedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalizedAt', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByFinishTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishTime', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByFinishTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishTime', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByFishingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fishingType', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByFishingTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fishingType', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByIsFinal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFinal', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByIsFinalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFinal', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByLakeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lakeName', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByLakeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lakeName', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByOrganizerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organizerName', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByOrganizerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organizerName', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByScoringMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoringMethod', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByScoringMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoringMethod', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenBySectorStructure() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectorStructure', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenBySectorStructureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectorStructure', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenBySectorsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectorsCount', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenBySectorsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectorsCount', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenBySectorsPerZone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectorsPerZone', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenBySectorsPerZoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectorsPerZone', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByZonedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zonedType', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByZonedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zonedType', Sort.desc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByZonesCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zonesCount', Sort.asc);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QAfterSortBy>
      thenByZonesCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zonesCount', Sort.desc);
    });
  }
}

extension CompetitionLocalQueryWhereDistinct
    on QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct> {
  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByAccessCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accessCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByAttemptsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'attemptsCount');
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByCityOrRegion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cityOrRegion', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByCommonLine({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'commonLine', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByCreatedByDeviceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdByDeviceId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByDurationDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationDays');
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByDurationHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationHours');
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByFinalizedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finalizedAt');
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByFinishTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finishTime');
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByFishingType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fishingType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByIsFinal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFinal');
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByLakeName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lakeName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByLakeNames() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lakeNames');
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByOrganizerName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'organizerName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByScoringMethod({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scoringMethod',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctBySectorStructure({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sectorStructure',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctBySectorsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sectorsCount');
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctBySectorsPerZone() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sectorsPerZone');
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByServerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByZonedType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'zonedType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompetitionLocal, CompetitionLocal, QDistinct>
      distinctByZonesCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'zonesCount');
    });
  }
}

extension CompetitionLocalQueryProperty
    on QueryBuilder<CompetitionLocal, CompetitionLocal, QQueryProperty> {
  QueryBuilder<CompetitionLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CompetitionLocal, String?, QQueryOperations>
      accessCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accessCode');
    });
  }

  QueryBuilder<CompetitionLocal, int?, QQueryOperations>
      attemptsCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attemptsCount');
    });
  }

  QueryBuilder<CompetitionLocal, String, QQueryOperations>
      cityOrRegionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cityOrRegion');
    });
  }

  QueryBuilder<CompetitionLocal, String?, QQueryOperations>
      commonLineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commonLine');
    });
  }

  QueryBuilder<CompetitionLocal, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<CompetitionLocal, String?, QQueryOperations>
      createdByDeviceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdByDeviceId');
    });
  }

  QueryBuilder<CompetitionLocal, int, QQueryOperations> durationDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationDays');
    });
  }

  QueryBuilder<CompetitionLocal, int, QQueryOperations>
      durationHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationHours');
    });
  }

  QueryBuilder<CompetitionLocal, List<EditLog>, QQueryOperations>
      editHistoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'editHistory');
    });
  }

  QueryBuilder<CompetitionLocal, DateTime?, QQueryOperations>
      finalizedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finalizedAt');
    });
  }

  QueryBuilder<CompetitionLocal, DateTime, QQueryOperations>
      finishTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finishTime');
    });
  }

  QueryBuilder<CompetitionLocal, String, QQueryOperations>
      fishingTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fishingType');
    });
  }

  QueryBuilder<CompetitionLocal, bool, QQueryOperations> isFinalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFinal');
    });
  }

  QueryBuilder<CompetitionLocal, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<CompetitionLocal, List<Judge>, QQueryOperations>
      judgesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'judges');
    });
  }

  QueryBuilder<CompetitionLocal, String, QQueryOperations> lakeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lakeName');
    });
  }

  QueryBuilder<CompetitionLocal, List<String>, QQueryOperations>
      lakeNamesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lakeNames');
    });
  }

  QueryBuilder<CompetitionLocal, DateTime?, QQueryOperations>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<CompetitionLocal, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<CompetitionLocal, String, QQueryOperations>
      organizerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'organizerName');
    });
  }

  QueryBuilder<CompetitionLocal, String, QQueryOperations>
      scoringMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scoringMethod');
    });
  }

  QueryBuilder<CompetitionLocal, String, QQueryOperations>
      sectorStructureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sectorStructure');
    });
  }

  QueryBuilder<CompetitionLocal, int, QQueryOperations> sectorsCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sectorsCount');
    });
  }

  QueryBuilder<CompetitionLocal, int?, QQueryOperations>
      sectorsPerZoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sectorsPerZone');
    });
  }

  QueryBuilder<CompetitionLocal, String?, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<CompetitionLocal, DateTime, QQueryOperations>
      startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<CompetitionLocal, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<CompetitionLocal, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<CompetitionLocal, String?, QQueryOperations>
      zonedTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'zonedType');
    });
  }

  QueryBuilder<CompetitionLocal, int?, QQueryOperations> zonesCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'zonesCount');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const JudgeSchema = Schema(
  name: r'Judge',
  id: -6365493751829595626,
  properties: {
    r'fullName': PropertySchema(
      id: 0,
      name: r'fullName',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.string,
    ),
    r'rank': PropertySchema(
      id: 2,
      name: r'rank',
      type: IsarType.string,
    )
  },
  estimateSize: _judgeEstimateSize,
  serialize: _judgeSerialize,
  deserialize: _judgeDeserialize,
  deserializeProp: _judgeDeserializeProp,
);

int _judgeEstimateSize(
  Judge object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.fullName.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.rank.length * 3;
  return bytesCount;
}

void _judgeSerialize(
  Judge object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.fullName);
  writer.writeString(offsets[1], object.id);
  writer.writeString(offsets[2], object.rank);
}

Judge _judgeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Judge();
  object.fullName = reader.readString(offsets[0]);
  object.id = reader.readString(offsets[1]);
  object.rank = reader.readString(offsets[2]);
  return object;
}

P _judgeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension JudgeQueryFilter on QueryBuilder<Judge, Judge, QFilterCondition> {
  QueryBuilder<Judge, Judge, QAfterFilterCondition> fullNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> fullNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> fullNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> fullNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fullName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> fullNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> fullNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> fullNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> fullNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fullName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> fullNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullName',
        value: '',
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> fullNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fullName',
        value: '',
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> idContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> idMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> rankEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rank',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> rankGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rank',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> rankLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rank',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> rankBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rank',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> rankStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rank',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> rankEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rank',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> rankContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rank',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> rankMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rank',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> rankIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rank',
        value: '',
      ));
    });
  }

  QueryBuilder<Judge, Judge, QAfterFilterCondition> rankIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rank',
        value: '',
      ));
    });
  }
}

extension JudgeQueryObject on QueryBuilder<Judge, Judge, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const EditLogSchema = Schema(
  name: r'EditLog',
  id: 3728511294334032363,
  properties: {
    r'action': PropertySchema(
      id: 0,
      name: r'action',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.string,
    ),
    r'judgeId': PropertySchema(
      id: 2,
      name: r'judgeId',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 3,
      name: r'timestamp',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _editLogEstimateSize,
  serialize: _editLogSerialize,
  deserialize: _editLogDeserialize,
  deserializeProp: _editLogDeserializeProp,
);

int _editLogEstimateSize(
  EditLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.action.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.judgeId.length * 3;
  return bytesCount;
}

void _editLogSerialize(
  EditLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.action);
  writer.writeString(offsets[1], object.id);
  writer.writeString(offsets[2], object.judgeId);
  writer.writeDateTime(offsets[3], object.timestamp);
}

EditLog _editLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EditLog();
  object.action = reader.readString(offsets[0]);
  object.id = reader.readString(offsets[1]);
  object.judgeId = reader.readString(offsets[2]);
  object.timestamp = reader.readDateTime(offsets[3]);
  return object;
}

P _editLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension EditLogQueryFilter
    on QueryBuilder<EditLog, EditLog, QFilterCondition> {
  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> actionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> actionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> actionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> actionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'action',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> actionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> actionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> actionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> actionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'action',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> actionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'action',
        value: '',
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> actionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'action',
        value: '',
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> idContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> judgeIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'judgeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> judgeIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'judgeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> judgeIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'judgeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> judgeIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'judgeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> judgeIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'judgeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> judgeIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'judgeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> judgeIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'judgeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> judgeIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'judgeId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> judgeIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'judgeId',
        value: '',
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> judgeIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'judgeId',
        value: '',
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> timestampEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<EditLog, EditLog, QAfterFilterCondition> timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension EditLogQueryObject
    on QueryBuilder<EditLog, EditLog, QFilterCondition> {}
