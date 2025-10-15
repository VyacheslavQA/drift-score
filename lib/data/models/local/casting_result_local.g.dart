// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'casting_result_local.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCastingResultLocalCollection on Isar {
  IsarCollection<CastingResultLocal> get castingResultLocals =>
      this.collection();
}

const CastingResultLocalSchema = CollectionSchema(
  name: r'CastingResultLocal',
  id: 7185018620647978363,
  properties: {
    r'attempts': PropertySchema(
      id: 0,
      name: r'attempts',
      type: IsarType.objectList,
      target: r'CastingAttempt',
    ),
    r'bestDistance': PropertySchema(
      id: 1,
      name: r'bestDistance',
      type: IsarType.double,
    ),
    r'castingSessionId': PropertySchema(
      id: 2,
      name: r'castingSessionId',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
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
    r'participantFullName': PropertySchema(
      id: 6,
      name: r'participantFullName',
      type: IsarType.string,
    ),
    r'participantId': PropertySchema(
      id: 7,
      name: r'participantId',
      type: IsarType.long,
    ),
    r'qrCode': PropertySchema(
      id: 8,
      name: r'qrCode',
      type: IsarType.string,
    ),
    r'serverId': PropertySchema(
      id: 9,
      name: r'serverId',
      type: IsarType.string,
    ),
    r'signatureBase64': PropertySchema(
      id: 10,
      name: r'signatureBase64',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 11,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'validAttemptsCount': PropertySchema(
      id: 12,
      name: r'validAttemptsCount',
      type: IsarType.long,
    )
  },
  estimateSize: _castingResultLocalEstimateSize,
  serialize: _castingResultLocalSerialize,
  deserialize: _castingResultLocalDeserialize,
  deserializeProp: _castingResultLocalDeserializeProp,
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
    r'castingSessionId': IndexSchema(
      id: -3728084434239046895,
      name: r'castingSessionId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'castingSessionId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'participantId': IndexSchema(
      id: -6135301321018090996,
      name: r'participantId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'participantId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'CastingAttempt': CastingAttemptSchema},
  getId: _castingResultLocalGetId,
  getLinks: _castingResultLocalGetLinks,
  attach: _castingResultLocalAttach,
  version: '3.3.0-dev.3',
);

int _castingResultLocalEstimateSize(
  CastingResultLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.attempts.length * 3;
  {
    final offsets = allOffsets[CastingAttempt]!;
    for (var i = 0; i < object.attempts.length; i++) {
      final value = object.attempts[i];
      bytesCount +=
          CastingAttemptSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.participantFullName.length * 3;
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

void _castingResultLocalSerialize(
  CastingResultLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<CastingAttempt>(
    offsets[0],
    allOffsets,
    CastingAttemptSchema.serialize,
    object.attempts,
  );
  writer.writeDouble(offsets[1], object.bestDistance);
  writer.writeLong(offsets[2], object.castingSessionId);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeBool(offsets[4], object.isSynced);
  writer.writeDateTime(offsets[5], object.lastSyncedAt);
  writer.writeString(offsets[6], object.participantFullName);
  writer.writeLong(offsets[7], object.participantId);
  writer.writeString(offsets[8], object.qrCode);
  writer.writeString(offsets[9], object.serverId);
  writer.writeString(offsets[10], object.signatureBase64);
  writer.writeDateTime(offsets[11], object.updatedAt);
  writer.writeLong(offsets[12], object.validAttemptsCount);
}

CastingResultLocal _castingResultLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CastingResultLocal();
  object.attempts = reader.readObjectList<CastingAttempt>(
        offsets[0],
        CastingAttemptSchema.deserialize,
        allOffsets,
        CastingAttempt(),
      ) ??
      [];
  object.bestDistance = reader.readDouble(offsets[1]);
  object.castingSessionId = reader.readLong(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.id = id;
  object.isSynced = reader.readBool(offsets[4]);
  object.lastSyncedAt = reader.readDateTimeOrNull(offsets[5]);
  object.participantFullName = reader.readString(offsets[6]);
  object.participantId = reader.readLong(offsets[7]);
  object.qrCode = reader.readStringOrNull(offsets[8]);
  object.serverId = reader.readStringOrNull(offsets[9]);
  object.signatureBase64 = reader.readStringOrNull(offsets[10]);
  object.updatedAt = reader.readDateTime(offsets[11]);
  object.validAttemptsCount = reader.readLong(offsets[12]);
  return object;
}

P _castingResultLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<CastingAttempt>(
            offset,
            CastingAttemptSchema.deserialize,
            allOffsets,
            CastingAttempt(),
          ) ??
          []) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _castingResultLocalGetId(CastingResultLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _castingResultLocalGetLinks(
    CastingResultLocal object) {
  return [];
}

void _castingResultLocalAttach(
    IsarCollection<dynamic> col, Id id, CastingResultLocal object) {
  object.id = id;
}

extension CastingResultLocalQueryWhereSort
    on QueryBuilder<CastingResultLocal, CastingResultLocal, QWhere> {
  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhere>
      anyCastingSessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'castingSessionId'),
      );
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhere>
      anyParticipantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'participantId'),
      );
    });
  }
}

extension CastingResultLocalQueryWhere
    on QueryBuilder<CastingResultLocal, CastingResultLocal, QWhereClause> {
  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhereClause>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhereClause>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhereClause>
      serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [null],
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhereClause>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhereClause>
      serverIdEqualTo(String? serverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [serverId],
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhereClause>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhereClause>
      castingSessionIdEqualTo(int castingSessionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'castingSessionId',
        value: [castingSessionId],
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhereClause>
      castingSessionIdNotEqualTo(int castingSessionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'castingSessionId',
              lower: [],
              upper: [castingSessionId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'castingSessionId',
              lower: [castingSessionId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'castingSessionId',
              lower: [castingSessionId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'castingSessionId',
              lower: [],
              upper: [castingSessionId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhereClause>
      castingSessionIdGreaterThan(
    int castingSessionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'castingSessionId',
        lower: [castingSessionId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhereClause>
      castingSessionIdLessThan(
    int castingSessionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'castingSessionId',
        lower: [],
        upper: [castingSessionId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhereClause>
      castingSessionIdBetween(
    int lowerCastingSessionId,
    int upperCastingSessionId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'castingSessionId',
        lower: [lowerCastingSessionId],
        includeLower: includeLower,
        upper: [upperCastingSessionId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhereClause>
      participantIdEqualTo(int participantId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'participantId',
        value: [participantId],
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhereClause>
      participantIdNotEqualTo(int participantId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'participantId',
              lower: [],
              upper: [participantId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'participantId',
              lower: [participantId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'participantId',
              lower: [participantId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'participantId',
              lower: [],
              upper: [participantId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhereClause>
      participantIdGreaterThan(
    int participantId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'participantId',
        lower: [participantId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhereClause>
      participantIdLessThan(
    int participantId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'participantId',
        lower: [],
        upper: [participantId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterWhereClause>
      participantIdBetween(
    int lowerParticipantId,
    int upperParticipantId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'participantId',
        lower: [lowerParticipantId],
        includeLower: includeLower,
        upper: [upperParticipantId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CastingResultLocalQueryFilter
    on QueryBuilder<CastingResultLocal, CastingResultLocal, QFilterCondition> {
  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      attemptsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'attempts',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      attemptsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'attempts',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      attemptsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'attempts',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      attemptsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'attempts',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      attemptsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'attempts',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      attemptsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'attempts',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      bestDistanceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bestDistance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      bestDistanceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bestDistance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      bestDistanceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bestDistance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      bestDistanceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bestDistance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      castingSessionIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'castingSessionId',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      castingSessionIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'castingSessionId',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      castingSessionIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'castingSessionId',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      castingSessionIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'castingSessionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      lastSyncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      participantFullNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'participantFullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      participantFullNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'participantFullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      participantFullNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'participantFullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      participantFullNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'participantFullName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      participantFullNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'participantFullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      participantFullNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'participantFullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      participantFullNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'participantFullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      participantFullNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'participantFullName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      participantFullNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'participantFullName',
        value: '',
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      participantFullNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'participantFullName',
        value: '',
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      participantIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'participantId',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      participantIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'participantId',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      participantIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'participantId',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      participantIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'participantId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      qrCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'qrCode',
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      qrCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'qrCode',
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      qrCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'qrCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      qrCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'qrCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      qrCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qrCode',
        value: '',
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      qrCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'qrCode',
        value: '',
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      serverIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      serverIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      serverIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serverId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      serverIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      serverIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      signatureBase64IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'signatureBase64',
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      signatureBase64IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'signatureBase64',
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      signatureBase64Contains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'signatureBase64',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      signatureBase64Matches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'signatureBase64',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      signatureBase64IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signatureBase64',
        value: '',
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      signatureBase64IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'signatureBase64',
        value: '',
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
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

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      validAttemptsCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'validAttemptsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      validAttemptsCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'validAttemptsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      validAttemptsCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'validAttemptsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      validAttemptsCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'validAttemptsCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CastingResultLocalQueryObject
    on QueryBuilder<CastingResultLocal, CastingResultLocal, QFilterCondition> {
  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterFilterCondition>
      attemptsElement(FilterQuery<CastingAttempt> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'attempts');
    });
  }
}

extension CastingResultLocalQueryLinks
    on QueryBuilder<CastingResultLocal, CastingResultLocal, QFilterCondition> {}

extension CastingResultLocalQuerySortBy
    on QueryBuilder<CastingResultLocal, CastingResultLocal, QSortBy> {
  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByBestDistance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestDistance', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByBestDistanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestDistance', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByCastingSessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'castingSessionId', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByCastingSessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'castingSessionId', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByParticipantFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'participantFullName', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByParticipantFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'participantFullName', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByParticipantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'participantId', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByParticipantIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'participantId', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByQrCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrCode', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByQrCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrCode', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortBySignatureBase64() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureBase64', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortBySignatureBase64Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureBase64', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByValidAttemptsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'validAttemptsCount', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      sortByValidAttemptsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'validAttemptsCount', Sort.desc);
    });
  }
}

extension CastingResultLocalQuerySortThenBy
    on QueryBuilder<CastingResultLocal, CastingResultLocal, QSortThenBy> {
  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByBestDistance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestDistance', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByBestDistanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestDistance', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByCastingSessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'castingSessionId', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByCastingSessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'castingSessionId', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByParticipantFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'participantFullName', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByParticipantFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'participantFullName', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByParticipantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'participantId', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByParticipantIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'participantId', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByQrCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrCode', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByQrCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrCode', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenBySignatureBase64() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureBase64', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenBySignatureBase64Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureBase64', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByValidAttemptsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'validAttemptsCount', Sort.asc);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QAfterSortBy>
      thenByValidAttemptsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'validAttemptsCount', Sort.desc);
    });
  }
}

extension CastingResultLocalQueryWhereDistinct
    on QueryBuilder<CastingResultLocal, CastingResultLocal, QDistinct> {
  QueryBuilder<CastingResultLocal, CastingResultLocal, QDistinct>
      distinctByBestDistance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bestDistance');
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QDistinct>
      distinctByCastingSessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'castingSessionId');
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QDistinct>
      distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QDistinct>
      distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QDistinct>
      distinctByParticipantFullName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'participantFullName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QDistinct>
      distinctByParticipantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'participantId');
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QDistinct>
      distinctByQrCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qrCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QDistinct>
      distinctByServerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QDistinct>
      distinctBySignatureBase64({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signatureBase64',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<CastingResultLocal, CastingResultLocal, QDistinct>
      distinctByValidAttemptsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'validAttemptsCount');
    });
  }
}

extension CastingResultLocalQueryProperty
    on QueryBuilder<CastingResultLocal, CastingResultLocal, QQueryProperty> {
  QueryBuilder<CastingResultLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CastingResultLocal, List<CastingAttempt>, QQueryOperations>
      attemptsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attempts');
    });
  }

  QueryBuilder<CastingResultLocal, double, QQueryOperations>
      bestDistanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bestDistance');
    });
  }

  QueryBuilder<CastingResultLocal, int, QQueryOperations>
      castingSessionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'castingSessionId');
    });
  }

  QueryBuilder<CastingResultLocal, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<CastingResultLocal, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<CastingResultLocal, DateTime?, QQueryOperations>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<CastingResultLocal, String, QQueryOperations>
      participantFullNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'participantFullName');
    });
  }

  QueryBuilder<CastingResultLocal, int, QQueryOperations>
      participantIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'participantId');
    });
  }

  QueryBuilder<CastingResultLocal, String?, QQueryOperations> qrCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qrCode');
    });
  }

  QueryBuilder<CastingResultLocal, String?, QQueryOperations>
      serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<CastingResultLocal, String?, QQueryOperations>
      signatureBase64Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signatureBase64');
    });
  }

  QueryBuilder<CastingResultLocal, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<CastingResultLocal, int, QQueryOperations>
      validAttemptsCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'validAttemptsCount');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const CastingAttemptSchema = Schema(
  name: r'CastingAttempt',
  id: -515876066540467957,
  properties: {
    r'attemptNumber': PropertySchema(
      id: 0,
      name: r'attemptNumber',
      type: IsarType.long,
    ),
    r'distance': PropertySchema(
      id: 1,
      name: r'distance',
      type: IsarType.double,
    ),
    r'id': PropertySchema(
      id: 2,
      name: r'id',
      type: IsarType.string,
    ),
    r'isValid': PropertySchema(
      id: 3,
      name: r'isValid',
      type: IsarType.bool,
    ),
    r'note': PropertySchema(
      id: 4,
      name: r'note',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 5,
      name: r'timestamp',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _castingAttemptEstimateSize,
  serialize: _castingAttemptSerialize,
  deserialize: _castingAttemptDeserialize,
  deserializeProp: _castingAttemptDeserializeProp,
);

int _castingAttemptEstimateSize(
  CastingAttempt object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _castingAttemptSerialize(
  CastingAttempt object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.attemptNumber);
  writer.writeDouble(offsets[1], object.distance);
  writer.writeString(offsets[2], object.id);
  writer.writeBool(offsets[3], object.isValid);
  writer.writeString(offsets[4], object.note);
  writer.writeDateTime(offsets[5], object.timestamp);
}

CastingAttempt _castingAttemptDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CastingAttempt();
  object.attemptNumber = reader.readLong(offsets[0]);
  object.distance = reader.readDouble(offsets[1]);
  object.id = reader.readString(offsets[2]);
  object.isValid = reader.readBool(offsets[3]);
  object.note = reader.readStringOrNull(offsets[4]);
  object.timestamp = reader.readDateTime(offsets[5]);
  return object;
}

P _castingAttemptDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension CastingAttemptQueryFilter
    on QueryBuilder<CastingAttempt, CastingAttempt, QFilterCondition> {
  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      attemptNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'attemptNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      attemptNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'attemptNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      attemptNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'attemptNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      attemptNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'attemptNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      distanceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'distance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      distanceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'distance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      distanceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'distance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      distanceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'distance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      idStartsWith(
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

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      idEndsWith(
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

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition> idMatches(
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

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      isValidEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isValid',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      noteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      noteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      noteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      noteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'note',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      noteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      noteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
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

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      timestampLessThan(
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

  QueryBuilder<CastingAttempt, CastingAttempt, QAfterFilterCondition>
      timestampBetween(
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

extension CastingAttemptQueryObject
    on QueryBuilder<CastingAttempt, CastingAttempt, QFilterCondition> {}
