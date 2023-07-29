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
  MongoDocument get content => valueMap;

  @override
  MongoDocument get rawContent {
    if (!expressionProcessed) {
      processExpression();
    }
    return content;
  }

  @override
  String toString() => 'ProjectionExpression($rawContent)';

  void processExpression() {
    expressionProcessed = true;
    content.clear();
    for (var element in _sequence) {
      content.addAll(element.rawContent);
    }
  }

  /// adds a {$meta : testScore} for search score projection
  void add$metaTextScore(String fieldName) => _sequence.add(MapExpression({
        fieldName: {r'$meta': 'textScore'}
      }));

  /// adds a {$meta : testScore} for search score projection
  void add$metaIndexKey(String fieldName) => _sequence.add(MapExpression({
        fieldName: {r'$meta': 'indexKey'}
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

  /// The $slice projection operator specifies the number of elements in an
  ///   array to return in the query result.
  /// For embedded Documents use the  dot notation (ex. "<docName>.<field>")
  void arraySlice(String fieldName, int elementsToReturn,
          {int? elementsToSkip}) =>
      _sequence.add(MapExpression({
        fieldName: {
          if (elementsToSkip == null)
            op$Slice: elementsToReturn
          else
            op$Slice: [elementsToReturn, elementsToSkip]
        }
      }));

  /// The positional $ operator limits the contents of an <array> to return
  /// the first element that matches the query condition on the array.
  void arrayFirstMatchinge(String fieldName) =>
      _sequence.add(MapExpression({'$fieldName.\$': 1}));

  /// The $elemMatch operator limits the contents of an <array> to return
  /// the first element that matches the given selection.
  /// The $elemMatch projection operator takes an explicit condition argument.
  /// This allows you to project based on a condition not in the query,
  /// or if you need to project based on multiple fields in the array's
  /// embedded documents.
  void arrayFirstMatchingOnCondition(
          String fieldName, FilterExpression condition) =>
      _sequence.add(MapExpression({
        fieldName: {op$ElemMatch: condition.rawContent}
      }));
}
