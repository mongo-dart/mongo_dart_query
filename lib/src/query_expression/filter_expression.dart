import 'package:mongo_dart_query/src/common/document_types.dart';

enum LogicType { and, or, nor }

// a = 5 and b = 6 or a = 7 and (b = 9 or c = 4) or c = 2

class FilterExpression {
  QueryFilter? _expression;
  LogicType? logicType;
  final QueryFilter _activeExpression = emptyQueryFilter;

  QueryFilter get raw => _expression ?? _activeExpression;

  @override
  String toString() => 'UpdateExpression($_expression)';

  void addExpression(String operator, String fieldName, value) {
    var opMap = _activeExpression[operator];
    if (opMap == null) {
      opMap = emptyMongoDocument;
      _activeExpression[operator] = opMap;
    }
    opMap[fieldName] = value;
  }

  void logicOr() {}
}
