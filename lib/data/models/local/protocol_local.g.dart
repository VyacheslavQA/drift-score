// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocol_local.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProtocolLocalCollection on Isar {
  IsarCollection<ProtocolLocal> get protocolLocals => this.collection();
}

const ProtocolLocalSchema = CollectionSchema(
  name: r'ProtocolLocal',
  id: -4052671514854831842,
  properties: {
    r'bigFishDay': PropertySchema(
      id: 0,
      name: r'bigFishDay',
      type: IsarType.long,
    ),
    r'competitionId': PropertySchema(
      id: 1,
      name: r'competitionId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dataJson': PropertySchema(
      id: 3,
      name: r'dataJson',
      type: IsarType.string,
    ),
    r'dayNumber': PropertySchema(
      id: 4,
      name: r'dayNumber',
      type: IsarType.long,
    ),
    r'isSynced': PropertySchema(
      id: 5,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'lastSyncedAt': PropertySchema(
      id: 6,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    ),
    r'serverId': PropertySchema(
      id: 7,
      name: r'serverId',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 8,
      name: r'type',
      type: IsarType.string,
    ),
    r'weighingId': PropertySchema(
      id: 9,
      name: r'weighingId',
      type: IsarType.string,
    ),
    r'weighingNumber': PropertySchema(
      id: 10,
      name: r'weighingNumber',
      type: IsarType.long,
    )
  },
  estimateSize: _protocolLocalEstimateSize,
  serialize: _protocolLocalSerialize,
  deserialize: _protocolLocalDeserialize,
  deserializeProp: _protocolLocalDeserializeProp,
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
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _protocolLocalGetId,
  getLinks: _protocolLocalGetLinks,
  attach: _protocolLocalAttach,
  version: '3.1.0+1',
);

int _protocolLocalEstimateSize(
  ProtocolLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.competitionId.length * 3;
  bytesCount += 3 + object.dataJson.length * 3;
  {
    final value = object.serverId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.type.length * 3;
  {
    final value = object.weighingId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _protocolLocalSerialize(
  ProtocolLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bigFishDay);
  writer.writeString(offsets[1], object.competitionId);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.dataJson);
  writer.writeLong(offsets[4], object.dayNumber);
  writer.writeBool(offsets[5], object.isSynced);
  writer.writeDateTime(offsets[6], object.lastSyncedAt);
  writer.writeString(offsets[7], object.serverId);
  writer.writeString(offsets[8], object.type);
  writer.writeString(offsets[9], object.weighingId);
  writer.writeLong(offsets[10], object.weighingNumber);
}

ProtocolLocal _protocolLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProtocolLocal();
  object.bigFishDay = reader.readLongOrNull(offsets[0]);
  object.competitionId = reader.readString(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.dataJson = reader.readString(offsets[3]);
  object.dayNumber = reader.readLongOrNull(offsets[4]);
  object.id = id;
  object.isSynced = reader.readBool(offsets[5]);
  object.lastSyncedAt = reader.readDateTimeOrNull(offsets[6]);
  object.serverId = reader.readStringOrNull(offsets[7]);
  object.type = reader.readString(offsets[8]);
  object.weighingId = reader.readStringOrNull(offsets[9]);
  object.weighingNumber = reader.readLongOrNull(offsets[10]);
  return object;
}

P _protocolLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _protocolLocalGetId(ProtocolLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _protocolLocalGetLinks(ProtocolLocal object) {
  return [];
}

void _protocolLocalAttach(
    IsarCollection<dynamic> col, Id id, ProtocolLocal object) {
  object.id = id;
}

extension ProtocolLocalQueryWhereSort
    on QueryBuilder<ProtocolLocal, ProtocolLocal, QWhere> {
  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProtocolLocalQueryWhere
    on QueryBuilder<ProtocolLocal, ProtocolLocal, QWhereClause> {
  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterWhereClause> idBetween(
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterWhereClause>
      serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [null],
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterWhereClause>
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterWhereClause> serverIdEqualTo(
      String? serverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [serverId],
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterWhereClause>
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterWhereClause>
      competitionIdEqualTo(String competitionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'competitionId',
        value: [competitionId],
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterWhereClause>
      competitionIdNotEqualTo(String competitionId) {
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
}

extension ProtocolLocalQueryFilter
    on QueryBuilder<ProtocolLocal, ProtocolLocal, QFilterCondition> {
  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      bigFishDayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bigFishDay',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      bigFishDayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bigFishDay',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      bigFishDayEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bigFishDay',
        value: value,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      bigFishDayGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bigFishDay',
        value: value,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      bigFishDayLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bigFishDay',
        value: value,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      bigFishDayBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bigFishDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      competitionIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'competitionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      competitionIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'competitionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      competitionIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'competitionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      competitionIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'competitionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      competitionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'competitionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      competitionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'competitionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      competitionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'competitionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      competitionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'competitionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      competitionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'competitionId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      competitionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'competitionId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      dataJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      dataJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      dataJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      dataJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      dataJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      dataJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      dataJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      dataJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dataJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      dataJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataJson',
        value: '',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      dataJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dataJson',
        value: '',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      dayNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dayNumber',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      dayNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dayNumber',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      dayNumberEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      dayNumberGreaterThan(
    int? value, {
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      dayNumberLessThan(
    int? value, {
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      dayNumberBetween(
    int? lower,
    int? upper, {
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      lastSyncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      serverIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      serverIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      serverIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serverId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      serverIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      serverIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      weighingIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weighingId',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      weighingIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weighingId',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      weighingIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weighingId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      weighingIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weighingId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      weighingIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weighingId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      weighingIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weighingId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      weighingIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'weighingId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      weighingIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'weighingId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      weighingIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'weighingId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      weighingIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'weighingId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      weighingIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weighingId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      weighingIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'weighingId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      weighingNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weighingNumber',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      weighingNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weighingNumber',
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      weighingNumberEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weighingNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      weighingNumberGreaterThan(
    int? value, {
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      weighingNumberLessThan(
    int? value, {
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

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterFilterCondition>
      weighingNumberBetween(
    int? lower,
    int? upper, {
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
}

extension ProtocolLocalQueryObject
    on QueryBuilder<ProtocolLocal, ProtocolLocal, QFilterCondition> {}

extension ProtocolLocalQueryLinks
    on QueryBuilder<ProtocolLocal, ProtocolLocal, QFilterCondition> {}

extension ProtocolLocalQuerySortBy
    on QueryBuilder<ProtocolLocal, ProtocolLocal, QSortBy> {
  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> sortByBigFishDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bigFishDay', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      sortByBigFishDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bigFishDay', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      sortByCompetitionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'competitionId', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      sortByCompetitionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'competitionId', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> sortByDataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataJson', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      sortByDataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataJson', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> sortByDayNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      sortByDayNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> sortByWeighingId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingId', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      sortByWeighingIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingId', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      sortByWeighingNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingNumber', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      sortByWeighingNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingNumber', Sort.desc);
    });
  }
}

extension ProtocolLocalQuerySortThenBy
    on QueryBuilder<ProtocolLocal, ProtocolLocal, QSortThenBy> {
  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> thenByBigFishDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bigFishDay', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      thenByBigFishDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bigFishDay', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      thenByCompetitionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'competitionId', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      thenByCompetitionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'competitionId', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> thenByDataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataJson', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      thenByDataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataJson', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> thenByDayNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      thenByDayNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy> thenByWeighingId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingId', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      thenByWeighingIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingId', Sort.desc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      thenByWeighingNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingNumber', Sort.asc);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QAfterSortBy>
      thenByWeighingNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingNumber', Sort.desc);
    });
  }
}

extension ProtocolLocalQueryWhereDistinct
    on QueryBuilder<ProtocolLocal, ProtocolLocal, QDistinct> {
  QueryBuilder<ProtocolLocal, ProtocolLocal, QDistinct> distinctByBigFishDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bigFishDay');
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QDistinct> distinctByCompetitionId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'competitionId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QDistinct> distinctByDataJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QDistinct> distinctByDayNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayNumber');
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QDistinct> distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QDistinct>
      distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QDistinct> distinctByServerId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QDistinct> distinctByWeighingId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weighingId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolLocal, ProtocolLocal, QDistinct>
      distinctByWeighingNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weighingNumber');
    });
  }
}

extension ProtocolLocalQueryProperty
    on QueryBuilder<ProtocolLocal, ProtocolLocal, QQueryProperty> {
  QueryBuilder<ProtocolLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProtocolLocal, int?, QQueryOperations> bigFishDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bigFishDay');
    });
  }

  QueryBuilder<ProtocolLocal, String, QQueryOperations>
      competitionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'competitionId');
    });
  }

  QueryBuilder<ProtocolLocal, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ProtocolLocal, String, QQueryOperations> dataJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataJson');
    });
  }

  QueryBuilder<ProtocolLocal, int?, QQueryOperations> dayNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayNumber');
    });
  }

  QueryBuilder<ProtocolLocal, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<ProtocolLocal, DateTime?, QQueryOperations>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<ProtocolLocal, String?, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<ProtocolLocal, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<ProtocolLocal, String?, QQueryOperations> weighingIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weighingId');
    });
  }

  QueryBuilder<ProtocolLocal, int?, QQueryOperations> weighingNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weighingNumber');
    });
  }
}
