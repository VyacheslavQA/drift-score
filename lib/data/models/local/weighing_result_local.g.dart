// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weighing_result_local.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWeighingResultLocalCollection on Isar {
  IsarCollection<WeighingResultLocal> get weighingResultLocals =>
      this.collection();
}

const WeighingResultLocalSchema = CollectionSchema(
  name: r'WeighingResultLocal',
  id: 1599481098748827303,
  properties: {
    r'averageWeight': PropertySchema(
      id: 0,
      name: r'averageWeight',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'fishCount': PropertySchema(
      id: 2,
      name: r'fishCount',
      type: IsarType.long,
    ),
    r'fishes': PropertySchema(
      id: 3,
      name: r'fishes',
      type: IsarType.objectList,
      target: r'FishCatch',
    ),
    r'isSynced': PropertySchema(
      id: 4,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'lastSyncedAt': PropertySchema(
      id: 5,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    ),
    r'qrCode': PropertySchema(
      id: 6,
      name: r'qrCode',
      type: IsarType.string,
    ),
    r'serverId': PropertySchema(
      id: 7,
      name: r'serverId',
      type: IsarType.string,
    ),
    r'signatureBase64': PropertySchema(
      id: 8,
      name: r'signatureBase64',
      type: IsarType.string,
    ),
    r'teamLocalId': PropertySchema(
      id: 9,
      name: r'teamLocalId',
      type: IsarType.long,
    ),
    r'totalWeight': PropertySchema(
      id: 10,
      name: r'totalWeight',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 11,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'weighingLocalId': PropertySchema(
      id: 12,
      name: r'weighingLocalId',
      type: IsarType.long,
    )
  },
  estimateSize: _weighingResultLocalEstimateSize,
  serialize: _weighingResultLocalSerialize,
  deserialize: _weighingResultLocalDeserialize,
  deserializeProp: _weighingResultLocalDeserializeProp,
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
    r'weighingLocalId': IndexSchema(
      id: 3557233795986236563,
      name: r'weighingLocalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'weighingLocalId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'teamLocalId': IndexSchema(
      id: 7385318609880886167,
      name: r'teamLocalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'teamLocalId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'FishCatch': FishCatchSchema},
  getId: _weighingResultLocalGetId,
  getLinks: _weighingResultLocalGetLinks,
  attach: _weighingResultLocalAttach,
  version: '3.3.0-dev.3',
);

int _weighingResultLocalEstimateSize(
  WeighingResultLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.fishes.length * 3;
  {
    final offsets = allOffsets[FishCatch]!;
    for (var i = 0; i < object.fishes.length; i++) {
      final value = object.fishes[i];
      bytesCount += FishCatchSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  {
    final value = object.qrCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.serverId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.signatureBase64;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _weighingResultLocalSerialize(
  WeighingResultLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.averageWeight);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.fishCount);
  writer.writeObjectList<FishCatch>(
    offsets[3],
    allOffsets,
    FishCatchSchema.serialize,
    object.fishes,
  );
  writer.writeBool(offsets[4], object.isSynced);
  writer.writeDateTime(offsets[5], object.lastSyncedAt);
  writer.writeString(offsets[6], object.qrCode);
  writer.writeString(offsets[7], object.serverId);
  writer.writeString(offsets[8], object.signatureBase64);
  writer.writeLong(offsets[9], object.teamLocalId);
  writer.writeDouble(offsets[10], object.totalWeight);
  writer.writeDateTime(offsets[11], object.updatedAt);
  writer.writeLong(offsets[12], object.weighingLocalId);
}

WeighingResultLocal _weighingResultLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WeighingResultLocal();
  object.averageWeight = reader.readDouble(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.fishCount = reader.readLong(offsets[2]);
  object.fishes = reader.readObjectList<FishCatch>(
        offsets[3],
        FishCatchSchema.deserialize,
        allOffsets,
        FishCatch(),
      ) ??
      [];
  object.id = id;
  object.isSynced = reader.readBool(offsets[4]);
  object.lastSyncedAt = reader.readDateTimeOrNull(offsets[5]);
  object.qrCode = reader.readStringOrNull(offsets[6]);
  object.serverId = reader.readStringOrNull(offsets[7]);
  object.signatureBase64 = reader.readStringOrNull(offsets[8]);
  object.teamLocalId = reader.readLong(offsets[9]);
  object.totalWeight = reader.readDouble(offsets[10]);
  object.updatedAt = reader.readDateTime(offsets[11]);
  object.weighingLocalId = reader.readLong(offsets[12]);
  return object;
}

P _weighingResultLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readObjectList<FishCatch>(
            offset,
            FishCatchSchema.deserialize,
            allOffsets,
            FishCatch(),
          ) ??
          []) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _weighingResultLocalGetId(WeighingResultLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _weighingResultLocalGetLinks(
    WeighingResultLocal object) {
  return [];
}

void _weighingResultLocalAttach(
    IsarCollection<dynamic> col, Id id, WeighingResultLocal object) {
  object.id = id;
}

extension WeighingResultLocalQueryWhereSort
    on QueryBuilder<WeighingResultLocal, WeighingResultLocal, QWhere> {
  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhere>
      anyWeighingLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'weighingLocalId'),
      );
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhere>
      anyTeamLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'teamLocalId'),
      );
    });
  }
}

extension WeighingResultLocalQueryWhere
    on QueryBuilder<WeighingResultLocal, WeighingResultLocal, QWhereClause> {
  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhereClause>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhereClause>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhereClause>
      serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [null],
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhereClause>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhereClause>
      serverIdEqualTo(String? serverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [serverId],
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhereClause>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhereClause>
      weighingLocalIdEqualTo(int weighingLocalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'weighingLocalId',
        value: [weighingLocalId],
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhereClause>
      weighingLocalIdNotEqualTo(int weighingLocalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weighingLocalId',
              lower: [],
              upper: [weighingLocalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weighingLocalId',
              lower: [weighingLocalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weighingLocalId',
              lower: [weighingLocalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weighingLocalId',
              lower: [],
              upper: [weighingLocalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhereClause>
      weighingLocalIdGreaterThan(
    int weighingLocalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weighingLocalId',
        lower: [weighingLocalId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhereClause>
      weighingLocalIdLessThan(
    int weighingLocalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weighingLocalId',
        lower: [],
        upper: [weighingLocalId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhereClause>
      weighingLocalIdBetween(
    int lowerWeighingLocalId,
    int upperWeighingLocalId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weighingLocalId',
        lower: [lowerWeighingLocalId],
        includeLower: includeLower,
        upper: [upperWeighingLocalId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhereClause>
      teamLocalIdEqualTo(int teamLocalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'teamLocalId',
        value: [teamLocalId],
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhereClause>
      teamLocalIdNotEqualTo(int teamLocalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'teamLocalId',
              lower: [],
              upper: [teamLocalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'teamLocalId',
              lower: [teamLocalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'teamLocalId',
              lower: [teamLocalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'teamLocalId',
              lower: [],
              upper: [teamLocalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhereClause>
      teamLocalIdGreaterThan(
    int teamLocalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'teamLocalId',
        lower: [teamLocalId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhereClause>
      teamLocalIdLessThan(
    int teamLocalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'teamLocalId',
        lower: [],
        upper: [teamLocalId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterWhereClause>
      teamLocalIdBetween(
    int lowerTeamLocalId,
    int upperTeamLocalId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'teamLocalId',
        lower: [lowerTeamLocalId],
        includeLower: includeLower,
        upper: [upperTeamLocalId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WeighingResultLocalQueryFilter on QueryBuilder<WeighingResultLocal,
    WeighingResultLocal, QFilterCondition> {
  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      averageWeightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'averageWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      averageWeightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'averageWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      averageWeightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'averageWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      averageWeightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'averageWeight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      fishCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fishCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      fishCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fishCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      fishCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fishCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      fishCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fishCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      fishesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fishes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      fishesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fishes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      fishesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fishes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      fishesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fishes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      fishesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fishes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      fishesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fishes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      lastSyncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      qrCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'qrCode',
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      qrCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'qrCode',
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      qrCodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qrCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      qrCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'qrCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      qrCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'qrCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      qrCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qrCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      qrCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'qrCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      qrCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'qrCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      qrCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'qrCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      qrCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'qrCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      qrCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qrCode',
        value: '',
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      qrCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'qrCode',
        value: '',
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      serverIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      serverIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      serverIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serverId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      serverIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      serverIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      signatureBase64IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'signatureBase64',
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      signatureBase64IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'signatureBase64',
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      signatureBase64EqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signatureBase64',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      signatureBase64GreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'signatureBase64',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      signatureBase64LessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'signatureBase64',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      signatureBase64Between(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'signatureBase64',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      signatureBase64StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'signatureBase64',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      signatureBase64EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'signatureBase64',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      signatureBase64Contains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'signatureBase64',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      signatureBase64Matches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'signatureBase64',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      signatureBase64IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signatureBase64',
        value: '',
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      signatureBase64IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'signatureBase64',
        value: '',
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      teamLocalIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'teamLocalId',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      teamLocalIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'teamLocalId',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      teamLocalIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'teamLocalId',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      teamLocalIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'teamLocalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      totalWeightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      totalWeightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      totalWeightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      totalWeightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalWeight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      weighingLocalIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weighingLocalId',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      weighingLocalIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weighingLocalId',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      weighingLocalIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weighingLocalId',
        value: value,
      ));
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      weighingLocalIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weighingLocalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WeighingResultLocalQueryObject on QueryBuilder<WeighingResultLocal,
    WeighingResultLocal, QFilterCondition> {
  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterFilterCondition>
      fishesElement(FilterQuery<FishCatch> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'fishes');
    });
  }
}

extension WeighingResultLocalQueryLinks on QueryBuilder<WeighingResultLocal,
    WeighingResultLocal, QFilterCondition> {}

extension WeighingResultLocalQuerySortBy
    on QueryBuilder<WeighingResultLocal, WeighingResultLocal, QSortBy> {
  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByAverageWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageWeight', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByAverageWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageWeight', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByFishCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fishCount', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByFishCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fishCount', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByQrCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrCode', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByQrCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrCode', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortBySignatureBase64() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureBase64', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortBySignatureBase64Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureBase64', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByTeamLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamLocalId', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByTeamLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamLocalId', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByTotalWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWeight', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByTotalWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWeight', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByWeighingLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingLocalId', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      sortByWeighingLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingLocalId', Sort.desc);
    });
  }
}

extension WeighingResultLocalQuerySortThenBy
    on QueryBuilder<WeighingResultLocal, WeighingResultLocal, QSortThenBy> {
  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByAverageWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageWeight', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByAverageWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageWeight', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByFishCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fishCount', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByFishCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fishCount', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByQrCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrCode', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByQrCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrCode', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenBySignatureBase64() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureBase64', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenBySignatureBase64Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureBase64', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByTeamLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamLocalId', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByTeamLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamLocalId', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByTotalWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWeight', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByTotalWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWeight', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByWeighingLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingLocalId', Sort.asc);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QAfterSortBy>
      thenByWeighingLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingLocalId', Sort.desc);
    });
  }
}

extension WeighingResultLocalQueryWhereDistinct
    on QueryBuilder<WeighingResultLocal, WeighingResultLocal, QDistinct> {
  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QDistinct>
      distinctByAverageWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageWeight');
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QDistinct>
      distinctByFishCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fishCount');
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QDistinct>
      distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QDistinct>
      distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QDistinct>
      distinctByQrCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qrCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QDistinct>
      distinctByServerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QDistinct>
      distinctBySignatureBase64({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signatureBase64',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QDistinct>
      distinctByTeamLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'teamLocalId');
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QDistinct>
      distinctByTotalWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalWeight');
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<WeighingResultLocal, WeighingResultLocal, QDistinct>
      distinctByWeighingLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weighingLocalId');
    });
  }
}

extension WeighingResultLocalQueryProperty
    on QueryBuilder<WeighingResultLocal, WeighingResultLocal, QQueryProperty> {
  QueryBuilder<WeighingResultLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WeighingResultLocal, double, QQueryOperations>
      averageWeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageWeight');
    });
  }

  QueryBuilder<WeighingResultLocal, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<WeighingResultLocal, int, QQueryOperations> fishCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fishCount');
    });
  }

  QueryBuilder<WeighingResultLocal, List<FishCatch>, QQueryOperations>
      fishesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fishes');
    });
  }

  QueryBuilder<WeighingResultLocal, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<WeighingResultLocal, DateTime?, QQueryOperations>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<WeighingResultLocal, String?, QQueryOperations>
      qrCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qrCode');
    });
  }

  QueryBuilder<WeighingResultLocal, String?, QQueryOperations>
      serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<WeighingResultLocal, String?, QQueryOperations>
      signatureBase64Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signatureBase64');
    });
  }

  QueryBuilder<WeighingResultLocal, int, QQueryOperations>
      teamLocalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'teamLocalId');
    });
  }

  QueryBuilder<WeighingResultLocal, double, QQueryOperations>
      totalWeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalWeight');
    });
  }

  QueryBuilder<WeighingResultLocal, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<WeighingResultLocal, int, QQueryOperations>
      weighingLocalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weighingLocalId');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const FishCatchSchema = Schema(
  name: r'FishCatch',
  id: 3779689265230512071,
  properties: {
    r'fishType': PropertySchema(
      id: 0,
      name: r'fishType',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.string,
    ),
    r'length': PropertySchema(
      id: 2,
      name: r'length',
      type: IsarType.double,
    ),
    r'weight': PropertySchema(
      id: 3,
      name: r'weight',
      type: IsarType.double,
    )
  },
  estimateSize: _fishCatchEstimateSize,
  serialize: _fishCatchSerialize,
  deserialize: _fishCatchDeserialize,
  deserializeProp: _fishCatchDeserializeProp,
);

int _fishCatchEstimateSize(
  FishCatch object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.fishType.length * 3;
  bytesCount += 3 + object.id.length * 3;
  return bytesCount;
}

void _fishCatchSerialize(
  FishCatch object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.fishType);
  writer.writeString(offsets[1], object.id);
  writer.writeDouble(offsets[2], object.length);
  writer.writeDouble(offsets[3], object.weight);
}

FishCatch _fishCatchDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FishCatch();
  object.fishType = reader.readString(offsets[0]);
  object.id = reader.readString(offsets[1]);
  object.length = reader.readDouble(offsets[2]);
  object.weight = reader.readDouble(offsets[3]);
  return object;
}

P _fishCatchDeserializeProp<P>(
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
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension FishCatchQueryFilter
    on QueryBuilder<FishCatch, FishCatch, QFilterCondition> {
  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> fishTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fishType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> fishTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fishType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> fishTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fishType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> fishTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fishType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> fishTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fishType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> fishTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fishType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> fishTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fishType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> fishTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fishType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> fishTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fishType',
        value: '',
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition>
      fishTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fishType',
        value: '',
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> idBetween(
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

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> idMatches(
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

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> lengthEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'length',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> lengthGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'length',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> lengthLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'length',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> lengthBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'length',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> weightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> weightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> weightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FishCatch, FishCatch, QAfterFilterCondition> weightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension FishCatchQueryObject
    on QueryBuilder<FishCatch, FishCatch, QFilterCondition> {}
