// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_local.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetResultLocalCollection on Isar {
  IsarCollection<ResultLocal> get resultLocals => this.collection();
}

const ResultLocalSchema = CollectionSchema(
  name: r'ResultLocal',
  id: -2383970383311193447,
  properties: {
    r'avgWeight': PropertySchema(
      id: 0,
      name: r'avgWeight',
      type: IsarType.double,
    ),
    r'biggestFishWeight': PropertySchema(
      id: 1,
      name: r'biggestFishWeight',
      type: IsarType.double,
    ),
    r'confirmationMethod': PropertySchema(
      id: 2,
      name: r'confirmationMethod',
      type: IsarType.string,
    ),
    r'confirmedAt': PropertySchema(
      id: 3,
      name: r'confirmedAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'fishCount': PropertySchema(
      id: 5,
      name: r'fishCount',
      type: IsarType.long,
    ),
    r'fishEntries': PropertySchema(
      id: 6,
      name: r'fishEntries',
      type: IsarType.objectList,
      target: r'FishEntry',
    ),
    r'isConfirmed': PropertySchema(
      id: 7,
      name: r'isConfirmed',
      type: IsarType.bool,
    ),
    r'isSynced': PropertySchema(
      id: 8,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'lastSyncedAt': PropertySchema(
      id: 9,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    ),
    r'serverId': PropertySchema(
      id: 10,
      name: r'serverId',
      type: IsarType.string,
    ),
    r'signatureLocalPath': PropertySchema(
      id: 11,
      name: r'signatureLocalPath',
      type: IsarType.string,
    ),
    r'teamLocalId': PropertySchema(
      id: 12,
      name: r'teamLocalId',
      type: IsarType.long,
    ),
    r'totalWeight': PropertySchema(
      id: 13,
      name: r'totalWeight',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 14,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'weighingLocalId': PropertySchema(
      id: 15,
      name: r'weighingLocalId',
      type: IsarType.long,
    )
  },
  estimateSize: _resultLocalEstimateSize,
  serialize: _resultLocalSerialize,
  deserialize: _resultLocalDeserialize,
  deserializeProp: _resultLocalDeserializeProp,
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
  embeddedSchemas: {r'FishEntry': FishEntrySchema},
  getId: _resultLocalGetId,
  getLinks: _resultLocalGetLinks,
  attach: _resultLocalAttach,
  version: '3.1.0+1',
);

int _resultLocalEstimateSize(
  ResultLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.confirmationMethod;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.fishEntries.length * 3;
  {
    final offsets = allOffsets[FishEntry]!;
    for (var i = 0; i < object.fishEntries.length; i++) {
      final value = object.fishEntries[i];
      bytesCount += FishEntrySchema.estimateSize(value, offsets, allOffsets);
    }
  }
  {
    final value = object.serverId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.signatureLocalPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _resultLocalSerialize(
  ResultLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.avgWeight);
  writer.writeDouble(offsets[1], object.biggestFishWeight);
  writer.writeString(offsets[2], object.confirmationMethod);
  writer.writeDateTime(offsets[3], object.confirmedAt);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeLong(offsets[5], object.fishCount);
  writer.writeObjectList<FishEntry>(
    offsets[6],
    allOffsets,
    FishEntrySchema.serialize,
    object.fishEntries,
  );
  writer.writeBool(offsets[7], object.isConfirmed);
  writer.writeBool(offsets[8], object.isSynced);
  writer.writeDateTime(offsets[9], object.lastSyncedAt);
  writer.writeString(offsets[10], object.serverId);
  writer.writeString(offsets[11], object.signatureLocalPath);
  writer.writeLong(offsets[12], object.teamLocalId);
  writer.writeDouble(offsets[13], object.totalWeight);
  writer.writeDateTime(offsets[14], object.updatedAt);
  writer.writeLong(offsets[15], object.weighingLocalId);
}

ResultLocal _resultLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ResultLocal();
  object.avgWeight = reader.readDouble(offsets[0]);
  object.biggestFishWeight = reader.readDoubleOrNull(offsets[1]);
  object.confirmationMethod = reader.readStringOrNull(offsets[2]);
  object.confirmedAt = reader.readDateTimeOrNull(offsets[3]);
  object.createdAt = reader.readDateTime(offsets[4]);
  object.fishCount = reader.readLong(offsets[5]);
  object.fishEntries = reader.readObjectList<FishEntry>(
        offsets[6],
        FishEntrySchema.deserialize,
        allOffsets,
        FishEntry(),
      ) ??
      [];
  object.id = id;
  object.isConfirmed = reader.readBool(offsets[7]);
  object.isSynced = reader.readBool(offsets[8]);
  object.lastSyncedAt = reader.readDateTimeOrNull(offsets[9]);
  object.serverId = reader.readStringOrNull(offsets[10]);
  object.signatureLocalPath = reader.readStringOrNull(offsets[11]);
  object.teamLocalId = reader.readLong(offsets[12]);
  object.totalWeight = reader.readDouble(offsets[13]);
  object.updatedAt = reader.readDateTime(offsets[14]);
  object.weighingLocalId = reader.readLong(offsets[15]);
  return object;
}

P _resultLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readObjectList<FishEntry>(
            offset,
            FishEntrySchema.deserialize,
            allOffsets,
            FishEntry(),
          ) ??
          []) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readDateTime(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _resultLocalGetId(ResultLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _resultLocalGetLinks(ResultLocal object) {
  return [];
}

void _resultLocalAttach(
    IsarCollection<dynamic> col, Id id, ResultLocal object) {
  object.id = id;
}

extension ResultLocalByIndex on IsarCollection<ResultLocal> {
  Future<ResultLocal?> getByServerId(String? serverId) {
    return getByIndex(r'serverId', [serverId]);
  }

  ResultLocal? getByServerIdSync(String? serverId) {
    return getByIndexSync(r'serverId', [serverId]);
  }

  Future<bool> deleteByServerId(String? serverId) {
    return deleteByIndex(r'serverId', [serverId]);
  }

  bool deleteByServerIdSync(String? serverId) {
    return deleteByIndexSync(r'serverId', [serverId]);
  }

  Future<List<ResultLocal?>> getAllByServerId(List<String?> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'serverId', values);
  }

  List<ResultLocal?> getAllByServerIdSync(List<String?> serverIdValues) {
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

  Future<Id> putByServerId(ResultLocal object) {
    return putByIndex(r'serverId', object);
  }

  Id putByServerIdSync(ResultLocal object, {bool saveLinks = true}) {
    return putByIndexSync(r'serverId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByServerId(List<ResultLocal> objects) {
    return putAllByIndex(r'serverId', objects);
  }

  List<Id> putAllByServerIdSync(List<ResultLocal> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'serverId', objects, saveLinks: saveLinks);
  }
}

extension ResultLocalQueryWhereSort
    on QueryBuilder<ResultLocal, ResultLocal, QWhere> {
  QueryBuilder<ResultLocal, ResultLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhere> anyWeighingLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'weighingLocalId'),
      );
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhere> anyTeamLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'teamLocalId'),
      );
    });
  }
}

extension ResultLocalQueryWhere
    on QueryBuilder<ResultLocal, ResultLocal, QWhereClause> {
  QueryBuilder<ResultLocal, ResultLocal, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhereClause> idBetween(
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhereClause> serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [null],
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhereClause>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhereClause> serverIdEqualTo(
      String? serverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [serverId],
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhereClause> serverIdNotEqualTo(
      String? serverId) {
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhereClause>
      weighingLocalIdEqualTo(int weighingLocalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'weighingLocalId',
        value: [weighingLocalId],
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhereClause>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhereClause>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhereClause>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhereClause>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhereClause> teamLocalIdEqualTo(
      int teamLocalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'teamLocalId',
        value: [teamLocalId],
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhereClause>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhereClause>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhereClause> teamLocalIdLessThan(
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterWhereClause> teamLocalIdBetween(
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

extension ResultLocalQueryFilter
    on QueryBuilder<ResultLocal, ResultLocal, QFilterCondition> {
  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      avgWeightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avgWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      avgWeightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avgWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      avgWeightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avgWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      avgWeightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avgWeight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      biggestFishWeightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'biggestFishWeight',
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      biggestFishWeightIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'biggestFishWeight',
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      biggestFishWeightEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'biggestFishWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      biggestFishWeightGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'biggestFishWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      biggestFishWeightLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'biggestFishWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      biggestFishWeightBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'biggestFishWeight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      confirmationMethodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'confirmationMethod',
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      confirmationMethodIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'confirmationMethod',
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      confirmationMethodEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confirmationMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      confirmationMethodGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'confirmationMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      confirmationMethodLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'confirmationMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      confirmationMethodBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'confirmationMethod',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      confirmationMethodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'confirmationMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      confirmationMethodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'confirmationMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      confirmationMethodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'confirmationMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      confirmationMethodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'confirmationMethod',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      confirmationMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confirmationMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      confirmationMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'confirmationMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      confirmedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'confirmedAt',
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      confirmedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'confirmedAt',
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      confirmedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confirmedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      confirmedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'confirmedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      confirmedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'confirmedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      confirmedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'confirmedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      fishCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fishCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      fishEntriesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fishEntries',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      fishEntriesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fishEntries',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      fishEntriesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fishEntries',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      fishEntriesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fishEntries',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      fishEntriesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fishEntries',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      fishEntriesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fishEntries',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      isConfirmedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isConfirmed',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition> isSyncedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      lastSyncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      serverIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition> serverIdEqualTo(
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition> serverIdBetween(
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      serverIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition> serverIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serverId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      serverIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      serverIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      signatureLocalPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'signatureLocalPath',
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      signatureLocalPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'signatureLocalPath',
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      signatureLocalPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signatureLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      signatureLocalPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'signatureLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      signatureLocalPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'signatureLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      signatureLocalPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'signatureLocalPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      signatureLocalPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'signatureLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      signatureLocalPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'signatureLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      signatureLocalPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'signatureLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      signatureLocalPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'signatureLocalPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      signatureLocalPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signatureLocalPath',
        value: '',
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      signatureLocalPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'signatureLocalPath',
        value: '',
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      teamLocalIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'teamLocalId',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      weighingLocalIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weighingLocalId',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
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

extension ResultLocalQueryObject
    on QueryBuilder<ResultLocal, ResultLocal, QFilterCondition> {
  QueryBuilder<ResultLocal, ResultLocal, QAfterFilterCondition>
      fishEntriesElement(FilterQuery<FishEntry> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'fishEntries');
    });
  }
}

extension ResultLocalQueryLinks
    on QueryBuilder<ResultLocal, ResultLocal, QFilterCondition> {}

extension ResultLocalQuerySortBy
    on QueryBuilder<ResultLocal, ResultLocal, QSortBy> {
  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByAvgWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgWeight', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByAvgWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgWeight', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy>
      sortByBiggestFishWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biggestFishWeight', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy>
      sortByBiggestFishWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biggestFishWeight', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy>
      sortByConfirmationMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmationMethod', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy>
      sortByConfirmationMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmationMethod', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedAt', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByConfirmedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedAt', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByFishCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fishCount', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByFishCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fishCount', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByIsConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConfirmed', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByIsConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConfirmed', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy>
      sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy>
      sortBySignatureLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureLocalPath', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy>
      sortBySignatureLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureLocalPath', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByTeamLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamLocalId', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByTeamLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamLocalId', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByTotalWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWeight', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByTotalWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWeight', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> sortByWeighingLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingLocalId', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy>
      sortByWeighingLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingLocalId', Sort.desc);
    });
  }
}

extension ResultLocalQuerySortThenBy
    on QueryBuilder<ResultLocal, ResultLocal, QSortThenBy> {
  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByAvgWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgWeight', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByAvgWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgWeight', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy>
      thenByBiggestFishWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biggestFishWeight', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy>
      thenByBiggestFishWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biggestFishWeight', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy>
      thenByConfirmationMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmationMethod', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy>
      thenByConfirmationMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmationMethod', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedAt', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByConfirmedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedAt', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByFishCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fishCount', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByFishCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fishCount', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByIsConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConfirmed', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByIsConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConfirmed', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy>
      thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy>
      thenBySignatureLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureLocalPath', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy>
      thenBySignatureLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureLocalPath', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByTeamLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamLocalId', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByTeamLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamLocalId', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByTotalWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWeight', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByTotalWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWeight', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy> thenByWeighingLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingLocalId', Sort.asc);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QAfterSortBy>
      thenByWeighingLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighingLocalId', Sort.desc);
    });
  }
}

extension ResultLocalQueryWhereDistinct
    on QueryBuilder<ResultLocal, ResultLocal, QDistinct> {
  QueryBuilder<ResultLocal, ResultLocal, QDistinct> distinctByAvgWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avgWeight');
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QDistinct>
      distinctByBiggestFishWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'biggestFishWeight');
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QDistinct>
      distinctByConfirmationMethod({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confirmationMethod',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QDistinct> distinctByConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confirmedAt');
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QDistinct> distinctByFishCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fishCount');
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QDistinct> distinctByIsConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isConfirmed');
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QDistinct> distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QDistinct> distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QDistinct> distinctByServerId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QDistinct>
      distinctBySignatureLocalPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signatureLocalPath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QDistinct> distinctByTeamLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'teamLocalId');
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QDistinct> distinctByTotalWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalWeight');
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<ResultLocal, ResultLocal, QDistinct>
      distinctByWeighingLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weighingLocalId');
    });
  }
}

extension ResultLocalQueryProperty
    on QueryBuilder<ResultLocal, ResultLocal, QQueryProperty> {
  QueryBuilder<ResultLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ResultLocal, double, QQueryOperations> avgWeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avgWeight');
    });
  }

  QueryBuilder<ResultLocal, double?, QQueryOperations>
      biggestFishWeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'biggestFishWeight');
    });
  }

  QueryBuilder<ResultLocal, String?, QQueryOperations>
      confirmationMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confirmationMethod');
    });
  }

  QueryBuilder<ResultLocal, DateTime?, QQueryOperations> confirmedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confirmedAt');
    });
  }

  QueryBuilder<ResultLocal, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ResultLocal, int, QQueryOperations> fishCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fishCount');
    });
  }

  QueryBuilder<ResultLocal, List<FishEntry>, QQueryOperations>
      fishEntriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fishEntries');
    });
  }

  QueryBuilder<ResultLocal, bool, QQueryOperations> isConfirmedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isConfirmed');
    });
  }

  QueryBuilder<ResultLocal, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<ResultLocal, DateTime?, QQueryOperations>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<ResultLocal, String?, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<ResultLocal, String?, QQueryOperations>
      signatureLocalPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signatureLocalPath');
    });
  }

  QueryBuilder<ResultLocal, int, QQueryOperations> teamLocalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'teamLocalId');
    });
  }

  QueryBuilder<ResultLocal, double, QQueryOperations> totalWeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalWeight');
    });
  }

  QueryBuilder<ResultLocal, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<ResultLocal, int, QQueryOperations> weighingLocalIdProperty() {
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

const FishEntrySchema = Schema(
  name: r'FishEntry',
  id: 43155174676883175,
  properties: {
    r'id': PropertySchema(
      id: 0,
      name: r'id',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 1,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
    r'weight': PropertySchema(
      id: 2,
      name: r'weight',
      type: IsarType.double,
    )
  },
  estimateSize: _fishEntryEstimateSize,
  serialize: _fishEntrySerialize,
  deserialize: _fishEntryDeserialize,
  deserializeProp: _fishEntryDeserializeProp,
);

int _fishEntryEstimateSize(
  FishEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  return bytesCount;
}

void _fishEntrySerialize(
  FishEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.id);
  writer.writeDateTime(offsets[1], object.timestamp);
  writer.writeDouble(offsets[2], object.weight);
}

FishEntry _fishEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FishEntry();
  object.id = reader.readString(offsets[0]);
  object.timestamp = reader.readDateTime(offsets[1]);
  object.weight = reader.readDouble(offsets[2]);
  return object;
}

P _fishEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension FishEntryQueryFilter
    on QueryBuilder<FishEntry, FishEntry, QFilterCondition> {
  QueryBuilder<FishEntry, FishEntry, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<FishEntry, FishEntry, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<FishEntry, FishEntry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<FishEntry, FishEntry, QAfterFilterCondition> idBetween(
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

  QueryBuilder<FishEntry, FishEntry, QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<FishEntry, FishEntry, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<FishEntry, FishEntry, QAfterFilterCondition> idContains(
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

  QueryBuilder<FishEntry, FishEntry, QAfterFilterCondition> idMatches(
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

  QueryBuilder<FishEntry, FishEntry, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<FishEntry, FishEntry, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<FishEntry, FishEntry, QAfterFilterCondition> timestampEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<FishEntry, FishEntry, QAfterFilterCondition>
      timestampGreaterThan(
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

  QueryBuilder<FishEntry, FishEntry, QAfterFilterCondition> timestampLessThan(
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

  QueryBuilder<FishEntry, FishEntry, QAfterFilterCondition> timestampBetween(
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

  QueryBuilder<FishEntry, FishEntry, QAfterFilterCondition> weightEqualTo(
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

  QueryBuilder<FishEntry, FishEntry, QAfterFilterCondition> weightGreaterThan(
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

  QueryBuilder<FishEntry, FishEntry, QAfterFilterCondition> weightLessThan(
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

  QueryBuilder<FishEntry, FishEntry, QAfterFilterCondition> weightBetween(
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

extension FishEntryQueryObject
    on QueryBuilder<FishEntry, FishEntry, QFilterCondition> {}
