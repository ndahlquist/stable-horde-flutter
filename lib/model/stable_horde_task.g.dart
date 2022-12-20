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
    r'imagePath': PropertySchema(
      id: 2,
      name: r'imagePath',
      type: IsarType.string,
    )
  },
  estimateSize: _stableHordeTaskEstimateSize,
  serialize: _stableHordeTaskSerialize,
  deserialize: _stableHordeTaskDeserialize,
  deserializeProp: _stableHordeTaskDeserializeProp,
  idName: r'id',
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
    final value = object.imagePath;
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
  writer.writeString(offsets[2], object.imagePath);
}

StableHordeTask _stableHordeTaskDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StableHordeTask();
  object.estimatedCompletionTime = reader.readDateTimeOrNull(offsets[0]);
  object.firstShowProgressIndicatorTime = reader.readDateTimeOrNull(offsets[1]);
  object.id = id;
  object.imagePath = reader.readStringOrNull(offsets[2]);
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _stableHordeTaskGetId(StableHordeTask object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _stableHordeTaskGetLinks(StableHordeTask object) {
  return [];
}

void _stableHordeTaskAttach(
    IsarCollection<dynamic> col, Id id, StableHordeTask object) {
  object.id = id;
}

extension StableHordeTaskQueryWhereSort
    on QueryBuilder<StableHordeTask, StableHordeTask, QWhere> {
  QueryBuilder<StableHordeTask, StableHordeTask, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StableHordeTaskQueryWhere
    on QueryBuilder<StableHordeTask, StableHordeTask, QWhereClause> {
  QueryBuilder<StableHordeTask, StableHordeTask, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterWhereClause>
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

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterWhereClause> idBetween(
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
}

extension StableHordeTaskQueryFilter
    on QueryBuilder<StableHordeTask, StableHordeTask, QFilterCondition> {
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
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
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

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
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

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
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

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imagePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imagePath',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imagePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imagePath',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imagePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imagePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imagePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imagePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imagePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imagePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterFilterCondition>
      imagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePath',
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
      sortByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      sortByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }
}

extension StableHordeTaskQuerySortThenBy
    on QueryBuilder<StableHordeTask, StableHordeTask, QSortThenBy> {
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

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      thenByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<StableHordeTask, StableHordeTask, QAfterSortBy>
      thenByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
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

  QueryBuilder<StableHordeTask, StableHordeTask, QDistinct> distinctByImagePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePath', caseSensitive: caseSensitive);
    });
  }
}

extension StableHordeTaskQueryProperty
    on QueryBuilder<StableHordeTask, StableHordeTask, QQueryProperty> {
  QueryBuilder<StableHordeTask, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
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

  QueryBuilder<StableHordeTask, String?, QQueryOperations> imagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePath');
    });
  }
}
