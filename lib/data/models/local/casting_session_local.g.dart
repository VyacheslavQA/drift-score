// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'casting_session_local.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCastingSessionLocalCollection on Isar {
  IsarCollection<CastingSessionLocal> get castingSessionLocals =>
      this.collection();
}

const CastingSessionLocalSchema = CollectionSchema(
  name: r'CastingSessionLocal',
  id: -3015165344212325871,
  properties: {
    r'competitionId': PropertySchema(
      id: 0,
      name: r'competitionId',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dayNumber': PropertySchema(
      id: 2,
      name: r'dayNumber',
      type: IsarType.long,
    ),
    r'isSynced': PropertySchema(
      id: 3,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'lastSyncedAt': PropertySchema(
      id: 4,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    ),
    r'resultIds': PropertySchema(
      id: 5,
      name: r'resultIds',
      type: IsarType.longList,
    ),
    r'serverId': PropertySchema(
      id: 6,
      name: r'serverId',
      type: IsarType.string,
    ),
    r'sessionNumber': PropertySchema(
      id: 7,
      name: r'sessionNumber',
      type: IsarType.long,
    ),
    r'sessionTime': PropertySchema(
      id: 8,
      name: r'sessionTime',
      type: IsarType.dateTime,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _castingSessionLocalEstimateSize,
  serialize: _castingSessionLocalSerialize,
  deserialize: _castingSessionLocalDeserialize,
  deserializeProp: _castingSessionLocalDeserializeProp,
  idName: r'id',
  indexes: {
    r'serverId': IndexSchema(
      id: -7950187970872907662,
      name: r'serverId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'serverId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'competitionId': IndexSchema(
      id: 6246605434691385911,
      name: r'competitionId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'competitionId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _castingSessionLocalGetId,
  getLinks: _castingSessionLocalGetLinks,
  attach: _castingSessionLocalAttach,
  version: '3.3.0-dev.3',
);

int _castingSessionLocalEstimateSize(
  CastingSessionLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.resultIds.length * 8;
  {
    final value = object.serverId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _castingSessionLocalSerialize(
  CastingSessionLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.competitionId);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.dayNumber);
  writer.writeBool(offsets[3], object.isSynced);
  writer.writeDateTime(offsets[4], object.lastSyncedAt);
  writer.writeLongList(offsets[5], object.resultIds);
  writer.writeString(offsets[6], object.serverId);
  writer.writeLong(offsets[7], object.sessionNumber);
  writer.writeDateTime(offsets[8], object.sessionTime);
  writer.writeDateTime(offsets[9], object.updatedAt);
}

CastingSessionLocal _castingSessionLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CastingSessionLocal();
  object.competitionId = reader.readLong(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.dayNumber = reader.readLong(offsets[2]);
  object.id = id;
  object.isSynced = reader.readBool(offsets[3]);
  object.lastSyncedAt = reader.readDateTimeOrNull(offsets[4]);
  object.resultIds = reader.readLongList(offsets[5]) ?? [];
  object.serverId = reader.readStringOrNull(offsets[6]);
  object.sessionNumber = reader.readLong(offsets[7]);
  object.sessionTime = reader.readDateTime(offsets[8]);
  object.updatedAt = reader.readDateTime(offsets[9]);
  return object;
}

P _castingSessionLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readLongList(offset) ?? []) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _castingSessionLocalGetId(CastingSessionLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _castingSessionLocalGetLinks(
    CastingSessionLocal object) {
  return [];
}

void _castingSessionLocalAttach(
    IsarCollection<dynamic> col, Id id, CastingSessionLocal object) {
  object.id = id;
}

extension CastingSessionLocalQueryWhereSort
    on QueryBuilder<CastingSessionLocal, CastingSessionLocal, QWhere> {
  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterWhere>
      anyCompetitionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'competitionId'),
      );
    });
  }
}

extension CastingSessionLocalQueryWhere
    on QueryBuilder<CastingSessionLocal, CastingSessionLocal, QWhereClause> {
  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterWhereClause>
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterWhereClause>
      serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [null],
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterWhereClause>
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterWhereClause>
      serverIdEqualTo(String? serverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [serverId],
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterWhereClause>
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterWhereClause>
      competitionIdEqualTo(int competitionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'competitionId',
        value: [competitionId],
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterWhereClause>
      competitionIdNotEqualTo(int competitionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'competitionId',
              lower: [],
              upper: [competitionId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'competitionId',
              lower: [competitionId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'competitionId',
              lower: [competitionId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'competitionId',
              lower: [],
              upper: [competitionId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterWhereClause>
      competitionIdGreaterThan(
    int competitionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'competitionId',
        lower: [competitionId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterWhereClause>
      competitionIdLessThan(
    int competitionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'competitionId',
        lower: [],
        upper: [competitionId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterWhereClause>
      competitionIdBetween(
    int lowerCompetitionId,
    int upperCompetitionId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'competitionId',
        lower: [lowerCompetitionId],
        includeLower: includeLower,
        upper: [upperCompetitionId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CastingSessionLocalQueryFilter on QueryBuilder<CastingSessionLocal,
    CastingSessionLocal, QFilterCondition> {
  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      competitionIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'competitionId',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      competitionIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'competitionId',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      competitionIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'competitionId',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      competitionIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'competitionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      dayNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      dayNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      dayNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      dayNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      lastSyncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      resultIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resultIds',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      resultIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resultIds',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      resultIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resultIds',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      resultIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resultIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      resultIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'resultIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      resultIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'resultIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      resultIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'resultIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      resultIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'resultIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      resultIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'resultIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      resultIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'resultIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      serverIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      serverIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      serverIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serverId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      serverIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      serverIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      sessionNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      sessionNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      sessionNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      sessionNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      sessionTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      sessionTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      sessionTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      sessionTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
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

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
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
}

extension CastingSessionLocalQueryObject on QueryBuilder<CastingSessionLocal,
    CastingSessionLocal, QFilterCondition> {}

extension CastingSessionLocalQueryLinks on QueryBuilder<CastingSessionLocal,
    CastingSessionLocal, QFilterCondition> {}

extension CastingSessionLocalQuerySortBy
    on QueryBuilder<CastingSessionLocal, CastingSessionLocal, QSortBy> {
  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      sortByCompetitionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'competitionId', Sort.asc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      sortByCompetitionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'competitionId', Sort.desc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      sortByDayNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.asc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      sortByDayNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.desc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      sortBySessionNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionNumber', Sort.asc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      sortBySessionNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionNumber', Sort.desc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      sortBySessionTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionTime', Sort.asc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      sortBySessionTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionTime', Sort.desc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension CastingSessionLocalQuerySortThenBy
    on QueryBuilder<CastingSessionLocal, CastingSessionLocal, QSortThenBy> {
  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenByCompetitionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'competitionId', Sort.asc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenByCompetitionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'competitionId', Sort.desc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenByDayNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.asc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenByDayNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.desc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenBySessionNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionNumber', Sort.asc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenBySessionNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionNumber', Sort.desc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenBySessionTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionTime', Sort.asc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenBySessionTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionTime', Sort.desc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension CastingSessionLocalQueryWhereDistinct
    on QueryBuilder<CastingSessionLocal, CastingSessionLocal, QDistinct> {
  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QDistinct>
      distinctByCompetitionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'competitionId');
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QDistinct>
      distinctByDayNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayNumber');
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QDistinct>
      distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QDistinct>
      distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QDistinct>
      distinctByResultIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resultIds');
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QDistinct>
      distinctByServerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QDistinct>
      distinctBySessionNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionNumber');
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QDistinct>
      distinctBySessionTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionTime');
    });
  }

  QueryBuilder<CastingSessionLocal, CastingSessionLocal, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension CastingSessionLocalQueryProperty
    on QueryBuilder<CastingSessionLocal, CastingSessionLocal, QQueryProperty> {
  QueryBuilder<CastingSessionLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CastingSessionLocal, int, QQueryOperations>
      competitionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'competitionId');
    });
  }

  QueryBuilder<CastingSessionLocal, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<CastingSessionLocal, int, QQueryOperations> dayNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayNumber');
    });
  }

  QueryBuilder<CastingSessionLocal, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<CastingSessionLocal, DateTime?, QQueryOperations>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<CastingSessionLocal, List<int>, QQueryOperations>
      resultIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resultIds');
    });
  }

  QueryBuilder<CastingSessionLocal, String?, QQueryOperations>
      serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<CastingSessionLocal, int, QQueryOperations>
      sessionNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionNumber');
    });
  }

  QueryBuilder<CastingSessionLocal, DateTime, QQueryOperations>
      sessionTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionTime');
    });
  }

  QueryBuilder<CastingSessionLocal, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
