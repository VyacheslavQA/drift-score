// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weighing_local.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWeighingLocalCollection on Isar {
  IsarCollection<WeighingLocal> get weighingLocals => this.collection();
}

const WeighingLocalSchema = CollectionSchema(
  name: r'WeighingLocal',
  id: 2977338877922732282,
  properties: {
    r'competitionLocalId': PropertySchema(
      id: 0,
      name: r'competitionLocalId',
      type: IsarType.long,
    ),
    r'completedAt': PropertySchema(
      id: 1,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dayNumber': PropertySchema(
      id: 3,
      name: r'dayNumber',
      type: IsarType.long,
    ),
    r'isCompleted': PropertySchema(
      id: 4,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'isExtraordinary': PropertySchema(
      id: 5,
      name: r'isExtraordinary',
      type: IsarType.bool,
    ),
    r'isSynced': PropertySchema(
      id: 6,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'lastSyncedAt': PropertySchema(
      id: 7,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    ),
    r'serverId': PropertySchema(
      id: 8,
      name: r'serverId',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'weighingNumber': PropertySchema(
      id: 10,
      name: r'weighingNumber',
      type: IsarType.long,
    ),
    r'weighingTime': PropertySchema(
      id: 11,
      name: r'weighingTime',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _weighingLocalEstimateSize,
  serialize: _weighingLocalSerialize,
  deserialize: _weighingLocalDeserialize,
  deserializeProp: _weighingLocalDeserializeProp,
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
    r'competitionLocalId': IndexSchema(
      id: -3899377665316137251,
      name: r'competitionLocalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'competitionLocalId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _weighingLocalGetId,
  getLinks: _weighingLocalGetLinks,
  attach: _weighingLocalAttach,
  version: '3.1.0+1',
);

int _weighingLocalEstimateSize(
  WeighingLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.serverId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _weighingLocalSerialize(
  WeighingLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.competitionLocalId);
  writer.writeDateTime(offsets[1], object.completedAt);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeLong(offsets[3], object.dayNumber);
  writer.writeBool(offsets[4], object.isCompleted);
  writer.writeBool(offsets[5], object.isExtraordinary);
  writer.writeBool(offsets[6], object.isSynced);
  writer.writeDateTime(offsets[7], object.lastSyncedAt);
  writer.writeString(offsets[8], object.serverId);
  writer.writeDateTime(offsets[9], object.updatedAt);
  writer.writeLong(offsets[10], object.weighingNumber);
  writer.writeDateTime(offsets[11], object.weighingTime);
}

WeighingLocal _weighingLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WeighingLocal();
  object.competitionLocalId = reader.readLong(offsets[0]);
  object.completedAt = reader.readDateTimeOrNull(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.dayNumber = reader.readLong(offsets[3]);
  object.id = id;
  object.isCompleted = reader.readBool(offsets[4]);
  object.isExtraordinary = reader.readBool(offsets[5]);
  object.isSynced = reader.readBool(offsets[6]);
  object.lastSyncedAt = reader.readDateTimeOrNull(offsets[7]);
  object.serverId = reader.readStringOrNull(offsets[8]);
  object.updatedAt = reader.readDateTime(offsets[9]);
  object.weighingNumber = reader.readLong(offsets[10]);
  object.weighingTime = reader.readDateTime(offsets[11]);
  return object;
}

P _weighingLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _weighingLocalGetId(WeighingLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _weighingLocalGetLinks(WeighingLocal object) {
  return [];
}

void _weighingLocalAttach(
    IsarCollection<dynamic> col, Id id, WeighingLocal object) {
  object.id = id;
}

extension WeighingLocalQueryWhereSort
    on QueryBuilder<WeighingLocal, WeighingLocal, QWhere> {
  QueryBuilder<WeighingLocal, WeighingLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterWhere>
      anyCompetitionLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'competitionLocalId'),
      );
    });
  }
}

extension WeighingLocalQueryWhere
    on QueryBuilder<WeighingLocal, WeighingLocal, QWhereClause> {
  QueryBuilder<WeighingLocal, WeighingLocal, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterWhereClause> idBetween(
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterWhereClause>
      serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [null],
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterWhereClause>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterWhereClause> serverIdEqualTo(
      String? serverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [serverId],
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterWhereClause>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterWhereClause>
      competitionLocalIdEqualTo(int competitionLocalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'competitionLocalId',
        value: [competitionLocalId],
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterWhereClause>
      competitionLocalIdNotEqualTo(int competitionLocalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'competitionLocalId',
              lower: [],
              upper: [competitionLocalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'competitionLocalId',
              lower: [competitionLocalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'competitionLocalId',
              lower: [competitionLocalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'competitionLocalId',
              lower: [],
              upper: [competitionLocalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterWhereClause>
      competitionLocalIdGreaterThan(
    int competitionLocalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'competitionLocalId',
        lower: [competitionLocalId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterWhereClause>
      competitionLocalIdLessThan(
    int competitionLocalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'competitionLocalId',
        lower: [],
        upper: [competitionLocalId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterWhereClause>
      competitionLocalIdBetween(
    int lowerCompetitionLocalId,
    int upperCompetitionLocalId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'competitionLocalId',
        lower: [lowerCompetitionLocalId],
        includeLower: includeLower,
        upper: [upperCompetitionLocalId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WeighingLocalQueryFilter
    on QueryBuilder<WeighingLocal, WeighingLocal, QFilterCondition> {
  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      competitionLocalIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'competitionLocalId',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      competitionLocalIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'competitionLocalId',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      competitionLocalIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'competitionLocalId',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      competitionLocalIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'competitionLocalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      dayNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      isCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      isExtraordinaryEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isExtraordinary',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      lastSyncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      serverIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      serverIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      serverIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serverId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      serverIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      serverIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      weighingNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weighingNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      weighingNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weighingNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      weighingNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weighingNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      weighingNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weighingNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      weighingTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weighingTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      weighingTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weighingTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      weighingTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weighingTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterFilterCondition>
      weighingTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weighingTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WeighingLocalQueryObject
    on QueryBuilder<WeighingLocal, WeighingLocal, QFilterCondition> {}

extension WeighingLocalQueryLinks
    on QueryBuilder<WeighingLocal, WeighingLocal, QFilterCondition> {}

extension WeighingLocalQuerySortBy
    on QueryBuilder<WeighingLocal, WeighingLocal, QSortBy> {
  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      sortByCompetitionLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'competitionLocalId', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      sortByCompetitionLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'competitionLocalId', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy> sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy> sortByDayNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      sortByDayNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy> sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      sortByIsExtraordinary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExtraordinary', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      sortByIsExtraordinaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExtraordinary', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy> sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      sortByWeighingNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingNumber', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      sortByWeighingNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingNumber', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      sortByWeighingTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingTime', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      sortByWeighingTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingTime', Sort.desc);
    });
  }
}

extension WeighingLocalQuerySortThenBy
    on QueryBuilder<WeighingLocal, WeighingLocal, QSortThenBy> {
  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      thenByCompetitionLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'competitionLocalId', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      thenByCompetitionLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'competitionLocalId', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy> thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy> thenByDayNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      thenByDayNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy> thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      thenByIsExtraordinary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExtraordinary', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      thenByIsExtraordinaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExtraordinary', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy> thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      thenByWeighingNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingNumber', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      thenByWeighingNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingNumber', Sort.desc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      thenByWeighingTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingTime', Sort.asc);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QAfterSortBy>
      thenByWeighingTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingTime', Sort.desc);
    });
  }
}

extension WeighingLocalQueryWhereDistinct
    on QueryBuilder<WeighingLocal, WeighingLocal, QDistinct> {
  QueryBuilder<WeighingLocal, WeighingLocal, QDistinct>
      distinctByCompetitionLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'competitionLocalId');
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QDistinct> distinctByDayNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayNumber');
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QDistinct>
      distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QDistinct>
      distinctByIsExtraordinary() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isExtraordinary');
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QDistinct> distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QDistinct>
      distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QDistinct> distinctByServerId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QDistinct>
      distinctByWeighingNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weighingNumber');
    });
  }

  QueryBuilder<WeighingLocal, WeighingLocal, QDistinct>
      distinctByWeighingTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weighingTime');
    });
  }
}

extension WeighingLocalQueryProperty
    on QueryBuilder<WeighingLocal, WeighingLocal, QQueryProperty> {
  QueryBuilder<WeighingLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WeighingLocal, int, QQueryOperations>
      competitionLocalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'competitionLocalId');
    });
  }

  QueryBuilder<WeighingLocal, DateTime?, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<WeighingLocal, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<WeighingLocal, int, QQueryOperations> dayNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayNumber');
    });
  }

  QueryBuilder<WeighingLocal, bool, QQueryOperations> isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<WeighingLocal, bool, QQueryOperations>
      isExtraordinaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isExtraordinary');
    });
  }

  QueryBuilder<WeighingLocal, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<WeighingLocal, DateTime?, QQueryOperations>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<WeighingLocal, String?, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<WeighingLocal, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<WeighingLocal, int, QQueryOperations> weighingNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weighingNumber');
    });
  }

  QueryBuilder<WeighingLocal, DateTime, QQueryOperations>
      weighingTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weighingTime');
    });
  }
}
