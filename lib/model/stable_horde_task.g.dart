// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stable_horde_task.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetStableHordeTaskCollection on Isar {
  IsarCollection<StableHordeTask> get stableHordeTasks => this.collection();
}

const StableHordeTaskSchema = CollectionSchema(
  name: r'StableHordeTask',
  id: -7546272270601559721,
  properties: {
    r'estimatedCompletionTime': PropertySchema(
      id: 0,
      name: r'estimatedCompletionTime',
      type: IsarType.dateTime,
    ),
    r'firstShowProgressIndicatorTime': PropertySchema(
      id: 1,
      name: r'firstShowProgressIndicatorTime',
      type: IsarType.dateTime,
    ),
    r'imageFilename': PropertySchema(
      id: 2,
      name: r'imageFilename',
      type: IsarType.string,
    ),
    r'model': PropertySchema(
      id: 3,
      name: r'model',
      type: IsarType.string,
    ),
    r'negativePrompt': PropertySchema(
      id: 4,
      name: r'negativePrompt',
      type: IsarType.string,
    ),
    r'nextUpdateTime': PropertySchema(
      id: 5,
      name: r'nextUpdateTime',
      type: IsarType.dateTime,
    ),
    r'prompt': PropertySchema(
      id: 6,
      name: r'prompt',
      type: IsarType.string,
    ),
    r'stableHordeId': PropertySchema(
      id: 7,
      name: r'stableHordeId',
      type: IsarType.string,
    )
  },
  estimateSize: _stableHordeTaskEstimateSize,
  serialize: _stableHordeTaskSerialize,
  deserialize: _stableHordeTaskDeserialize,
  deserializeProp: _stableHordeTaskDeserializeProp,
  idName: r'dbId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _stableHordeTaskGetId,
  getLinks: _stableHordeTaskGetLinks,
  attach: _stableHordeTaskAttach,
  version: '3.0.5',
);

int _stableHordeTaskEstimateSize(
  StableHordeTask object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.imageFilename;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.model.length * 3;
  bytesCount += 3 + object.negativePrompt.length * 3;
  bytesCount += 3 + object.prompt.length * 3;
  {
    final value = object.stableHordeId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _stableHordeTaskSerialize(
  StableHordeTask object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.estimatedCompletionTime);
  writer.writeDateTime(offsets[1], object.firstShowProgressIndicatorTime);
  writer.writeString(offsets[2], object.imageFilename);
  writer.writeString(offsets[3], object.model);
  writer.writeString(offsets[4], object.negativePrompt);
  writer.writeDateTime(offsets[5], object.nextUpdateTime);
  writer.writeString(offsets[6], object.prompt);
  writer.writeString(offsets[7], object.stableHordeId);
}

StableHordeTask _stableHordeTaskDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StableHordeTask(
    reader.readString(offsets[6]),
    reader.readString(offsets[4]),
    reader.readString(offsets[3]),
  );
  object.dbId = id;
  object.estimatedCompletionTime = reader.readDateTimeOrNull(offsets[0]);
  object.firstShowProgressIndicatorTime = reader.readDateTimeOrNull(offsets[1]);
  object.imageFilename = reader.readStringOrNull(offsets[2]);
  object.nextUpdateTime = reader.readDateTimeOrNull(offsets[5]);
  object.stableHordeId = reader.readStringOrNull(offsets[7]);
  return object;
}

P _stableHordeTaskDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _stableHordeTaskGetId(StableHordeTask object) {
  return object.dbId;
}

List<IsarLinkBase<dynamic>> _stableHordeTaskGetLinks(StableHordeTask object) {
  return [];
}

void _stableHordeTaskAttach(
    IsarCollection<dynamic> col, Id id, StableHordeTask object) {
  object.dbId = id;
}

extension StableHordeTaskQueryWhereSort
    on QueryBuilder<StableHordeTask, StableHordeTask, QWhere> {
  QueryBuilder<StableHordeTask, StableHordeTask, QAfterWhere> anyDbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StableHordeTaskQueryWhere
    on QueryBuilder<StableHordeTask, StableHordeTask, QWhereClause> {
  QueryBuilder<StableHordeTask, StableHordeTask, QAfterWhereClause> dbIdEqualTo(
      Id dbId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: dbId,
        upper: dbId,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterWhereClause>
      dbIdNotEqualTo(Id dbId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: dbId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: dbId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: dbId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: dbId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterWhereClause>
      dbIdGreaterThan(Id dbId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: dbId, includeLower: include),
      );
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterWhereClause>
      dbIdLessThan(Id dbId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: dbId, includeUpper: include),
      );
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterWhereClause> dbIdBetween(
    Id lowerDbId,
    Id upperDbId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerDbId,
        includeLower: includeLower,
        upper: upperDbId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StableHordeTaskQueryFilter
    on QueryBuilder<StableHordeTask, StableHordeTask, QFilterCondition> {
  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      dbIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dbId',
        value: value,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      dbIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dbId',
        value: value,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      dbIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dbId',
        value: value,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      dbIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dbId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      estimatedCompletionTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'estimatedCompletionTime',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      estimatedCompletionTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'estimatedCompletionTime',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      estimatedCompletionTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estimatedCompletionTime',
        value: value,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      estimatedCompletionTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'estimatedCompletionTime',
        value: value,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      estimatedCompletionTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'estimatedCompletionTime',
        value: value,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      estimatedCompletionTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'estimatedCompletionTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      firstShowProgressIndicatorTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'firstShowProgressIndicatorTime',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      firstShowProgressIndicatorTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'firstShowProgressIndicatorTime',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      firstShowProgressIndicatorTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstShowProgressIndicatorTime',
        value: value,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      firstShowProgressIndicatorTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstShowProgressIndicatorTime',
        value: value,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      firstShowProgressIndicatorTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstShowProgressIndicatorTime',
        value: value,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      firstShowProgressIndicatorTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstShowProgressIndicatorTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imageFilenameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imageFilename',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imageFilenameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imageFilename',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imageFilenameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imageFilenameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imageFilenameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imageFilenameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageFilename',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imageFilenameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imageFilenameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imageFilenameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imageFilenameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageFilename',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imageFilenameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageFilename',
        value: '',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imageFilenameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageFilename',
        value: '',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      modelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      modelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      modelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      modelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'model',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      modelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      modelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      modelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      modelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'model',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      modelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'model',
        value: '',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      modelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'model',
        value: '',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      negativePromptEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'negativePrompt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      negativePromptGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'negativePrompt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      negativePromptLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'negativePrompt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      negativePromptBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'negativePrompt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      negativePromptStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'negativePrompt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      negativePromptEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'negativePrompt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      negativePromptContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'negativePrompt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      negativePromptMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'negativePrompt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      negativePromptIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'negativePrompt',
        value: '',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      negativePromptIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'negativePrompt',
        value: '',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      nextUpdateTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nextUpdateTime',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      nextUpdateTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nextUpdateTime',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      nextUpdateTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextUpdateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      nextUpdateTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextUpdateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      nextUpdateTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextUpdateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      nextUpdateTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextUpdateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      promptEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prompt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      promptGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prompt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      promptLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prompt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      promptBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prompt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      promptStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'prompt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      promptEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'prompt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      promptContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'prompt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      promptMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'prompt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      promptIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prompt',
        value: '',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      promptIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'prompt',
        value: '',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      stableHordeIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stableHordeId',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      stableHordeIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stableHordeId',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      stableHordeIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stableHordeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      stableHordeIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stableHordeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      stableHordeIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stableHordeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      stableHordeIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stableHordeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      stableHordeIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'stableHordeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      stableHordeIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'stableHordeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      stableHordeIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stableHordeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      stableHordeIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stableHordeId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      stableHordeIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stableHordeId',
        value: '',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      stableHordeIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stableHordeId',
        value: '',
      ));
    });
  }
}

extension StableHordeTaskQueryObject
    on QueryBuilder<StableHordeTask, StableHordeTask, QFilterCondition> {}

extension StableHordeTaskQueryLinks
    on QueryBuilder<StableHordeTask, StableHordeTask, QFilterCondition> {}

extension StableHordeTaskQuerySortBy
    on QueryBuilder<StableHordeTask, StableHordeTask, QSortBy> {
  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      sortByEstimatedCompletionTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedCompletionTime', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      sortByEstimatedCompletionTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedCompletionTime', Sort.desc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      sortByFirstShowProgressIndicatorTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstShowProgressIndicatorTime', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      sortByFirstShowProgressIndicatorTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstShowProgressIndicatorTime', Sort.desc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      sortByImageFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageFilename', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      sortByImageFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageFilename', Sort.desc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy> sortByModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      sortByModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.desc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      sortByNegativePrompt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'negativePrompt', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      sortByNegativePromptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'negativePrompt', Sort.desc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      sortByNextUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextUpdateTime', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      sortByNextUpdateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextUpdateTime', Sort.desc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy> sortByPrompt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prompt', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      sortByPromptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prompt', Sort.desc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      sortByStableHordeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stableHordeId', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      sortByStableHordeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stableHordeId', Sort.desc);
    });
  }
}

extension StableHordeTaskQuerySortThenBy
    on QueryBuilder<StableHordeTask, StableHordeTask, QSortThenBy> {
  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy> thenByDbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dbId', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      thenByDbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dbId', Sort.desc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      thenByEstimatedCompletionTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedCompletionTime', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      thenByEstimatedCompletionTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedCompletionTime', Sort.desc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      thenByFirstShowProgressIndicatorTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstShowProgressIndicatorTime', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      thenByFirstShowProgressIndicatorTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstShowProgressIndicatorTime', Sort.desc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      thenByImageFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageFilename', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      thenByImageFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageFilename', Sort.desc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy> thenByModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      thenByModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.desc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      thenByNegativePrompt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'negativePrompt', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      thenByNegativePromptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'negativePrompt', Sort.desc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      thenByNextUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextUpdateTime', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      thenByNextUpdateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextUpdateTime', Sort.desc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy> thenByPrompt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prompt', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      thenByPromptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prompt', Sort.desc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      thenByStableHordeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stableHordeId', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      thenByStableHordeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stableHordeId', Sort.desc);
    });
  }
}

extension StableHordeTaskQueryWhereDistinct
    on QueryBuilder<StableHordeTask, StableHordeTask, QDistinct> {
  QueryBuilder<StableHordeTask, StableHordeTask, QDistinct>
      distinctByEstimatedCompletionTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estimatedCompletionTime');
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QDistinct>
      distinctByFirstShowProgressIndicatorTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstShowProgressIndicatorTime');
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QDistinct>
      distinctByImageFilename({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageFilename',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QDistinct> distinctByModel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'model', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QDistinct>
      distinctByNegativePrompt({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'negativePrompt',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QDistinct>
      distinctByNextUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextUpdateTime');
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QDistinct> distinctByPrompt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prompt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QDistinct>
      distinctByStableHordeId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stableHordeId',
          caseSensitive: caseSensitive);
    });
  }
}

extension StableHordeTaskQueryProperty
    on QueryBuilder<StableHordeTask, StableHordeTask, QQueryProperty> {
  QueryBuilder<StableHordeTask, int, QQueryOperations> dbIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dbId');
    });
  }

  QueryBuilder<StableHordeTask, DateTime?, QQueryOperations>
      estimatedCompletionTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estimatedCompletionTime');
    });
  }

  QueryBuilder<StableHordeTask, DateTime?, QQueryOperations>
      firstShowProgressIndicatorTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstShowProgressIndicatorTime');
    });
  }

  QueryBuilder<StableHordeTask, String?, QQueryOperations>
      imageFilenameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageFilename');
    });
  }

  QueryBuilder<StableHordeTask, String, QQueryOperations> modelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'model');
    });
  }

  QueryBuilder<StableHordeTask, String, QQueryOperations>
      negativePromptProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'negativePrompt');
    });
  }

  QueryBuilder<StableHordeTask, DateTime?, QQueryOperations>
      nextUpdateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextUpdateTime');
    });
  }

  QueryBuilder<StableHordeTask, String, QQueryOperations> promptProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prompt');
    });
  }

  QueryBuilder<StableHordeTask, String?, QQueryOperations>
      stableHordeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stableHordeId');
    });
  }
}
