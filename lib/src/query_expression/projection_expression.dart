import 'package:mongo_dart_query/src/expression/common/constant.dart';
import 'package:mongo_dart_query/src/expression/common/operators_def.dart';

import '../expression/basic_expression.dart';
import '../expression/common/document_types.dart';
import 'filter_expression.dart';

class ProjectionExpression extends MapExpression {
  ProjectionExpression() : super.empty();

  bool expressionProcessed = false;
  final _sequence = <MapExpression>[];

  bool get notEmpty => _sequence.isNotEmpty;
  ProjectionDocument get content => <String, Object>{...valueMap};

  @override
  ProjectionDocument get rawContent {
    if (!expressionProcessed) {
      processExpression();
    }
    return content;
  }

  @override
  String toString() => 'ProjectionExpression($rawContent)';

  void processExpression() {
    expressionProcessed = true;
    valueMap.clear();
    for (var element in _sequence) {
      var insertMap = <String, Object>{...element.rawContent};
      valueMap.addAll(insertMap);
    }
  }

  /// Set a Map
  /// Clears the original content and add the new one
  @override
  void setMap(MongoDocument map) => valueMap = <String, Object>{...map};

  /// Add a Map
  /// Add a map content to the actual content.
  /// If any key alreay exists, it is substituted
  @override
  void addMap(MongoDocument map) => valueMap.addAll(map as ProjectionDocument);

  /// Add a key-value pair
  /// If the key already exists, the value is substituted
  @override
  void addEntry(String key, value) => valueMap[key] = value as Object;

  /// adds a {$meta : testScore} for search score projection
  void add$metaTextScore(String fieldName) => _sequence.add(MapExpression({
        fieldName: {op$meta: 'textScore'}
      }));

  /// adds a {$meta : testScore} for search score projection
  void add$metaIndexKey(String fieldName) => _sequence.add(MapExpression({
        fieldName: {op$meta: 'indexKey'}
      }));

  /// Include a field in the returned field list
  /// For embedded Documents use the  dot notation (ex. "<docName>.<field>")
  void includeField(String fieldName) =>
      _sequence.add(MapExpression({fieldName: 1}));

  /// Exclude a field from the returned field list
  /// For embedded Documents use the dot notation (ex. "<docName>.<field>")
  void excludeField(String fieldName) =>
      _sequence.add(MapExpression({fieldName: 0}));

  /// Exclude the "_id" field from the returned field list
  /// By, default, if not excluded explicitely,
  /// the "_id" field is always returned.
  void excludeId() => _sequence.add(MapExpression({field_id: 0}));

  /// The positional $ operator limits the contents of an <array> to return
  /// the first element that matches the query condition on the array.
  void $(String fieldName) =>
      _sequence.add(MapExpression({'$fieldName.\$': 1}));

  /// The $elemMatch operator limits the contents of an <array> to return
  /// the first element that matches the given selection.
  /// The $elemMatch projection operator takes an explicit condition argument.
  /// This allows you to project based on a condition not in the query,
  /// or if you need to project based on multiple fields in the array's
  /// embedded documents.
  void $elemMatch(String fieldName, FilterExpression condition) =>
      _sequence.add(MapExpression({
        fieldName: {op$elemMatch: condition.rawContent}
      }));

  /// The $slice projection operator specifies the number of elements in an
  ///   array to return in the query result.
  /// For embedded Documents use the  dot notation (ex. "<docName>.<field>")
  void $slice(String fieldName, int elementsToReturn, {int? elementsToSkip}) =>
      _sequence.add(MapExpression({
        fieldName: {
          if (elementsToSkip == null)
            op$slice: elementsToReturn
          else
            op$slice: [elementsToReturn, elementsToSkip]
        }
      }));
}
