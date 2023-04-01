import '../common/document_types.dart';

abstract class ExpressionContent {
  dynamic get raw;
}

class ValueExpression extends ExpressionContent {
  ValueExpression(value) : _value = _setValue(value);

  final dynamic _value;

  @override
  dynamic get raw {
    if (_value is ExpressionContent) {
      return _value.raw;
    }

    return _value;
  }

  static dynamic _setValue(value) {
    if (value is List) {
      return ListExpression(value);
    }
    if (value is Set) {
      return SetExpression(value);
    }
    if (value is MongoDocument) {
      return MapExpression(value);
    }
    return value;
  }
}

class ListExpression extends ExpressionContent {
  ListExpression(this.values);

  List values;

  void add(value) => values.add(value);

  @override
  List get raw => [
        for (var element in values)
          element is ExpressionContent ? element.raw : element
      ];
}

class SetExpression extends ExpressionContent {
  SetExpression(this.values);

  Set values;

  void add(value) => values.add(value);

  @override
  Set get raw => {
        for (var element in values)
          element is ExpressionContent ? element.raw : element
      };
}

class MapExpression extends ExpressionContent {
  MapExpression(this.valueMap);
  MapExpression.empty() : valueMap = emptyMongoDocument;

  MongoDocument valueMap;

  void addMapExpression(MapExpression expression) =>
      valueMap.addAll(expression.raw);

  void setMap(Map<String, dynamic> map) => valueMap.addAll(map);
  void setExpression(Expression operatorExp) =>
      valueMap.addAll(operatorExp.raw);
  void setMapEntry(MapEntry<String, dynamic> entry) =>
      valueMap.addAll({entry.key: entry.value});
  void setEntry(String key, value) => valueMap[key] = value;

  void mergeExpression(Expression expression) =>
      merge(expression.key, expression.content);

  void merge(key, content) {
    if (content is! Map &&
        content is! MapExpression &&
        content is! MapEntry &&
        content is! Expression) {
      setEntry(key, content);
      return;
    }
    MongoDocument contentMap;
    if (content is MongoDocument) {
      contentMap = content;
    } else if (content is Expression) {
      contentMap = content.raw;
    } else if (content is MapExpression) {
      contentMap = content.raw;
    } else if (content is MapEntry) {
      contentMap = {content.key: content.value};
    } else {
      setEntry(key, content);
      return;
    }
    var origin = valueMap[key];

    if (origin is Map) {
      valueMap[key] = {...origin, ...contentMap};
    } else if (origin is Expression) {
      valueMap[key] = {...origin.raw, ...contentMap};
    } else if (origin is MapExpression) {
      valueMap[key] = {...origin.raw, ...contentMap};
    } else if (origin is MapEntry) {
      valueMap[key] = {origin.key: origin.value, ...contentMap};
    } else {
      setEntry(key, contentMap);
    }
  }

  @override
  MongoDocument get raw => {
        for (var entry in valueMap.entries)
          if (entry.value is ExpressionContent)
            entry.key: entry.value.raw
          else
            entry.key: entry.value
      };
}

class Expression<T> extends ExpressionContent {
  Expression(String key, T value) : entry = MapEntry<String, T>(key, value);
  Expression.fromMapEntry(this.entry);
  MapEntry<String, T> entry;

  String get key => entry.key;
  dynamic get content => entry.value;

  @override
  MongoDocument get raw => {
        if (entry.value is ExpressionContent)
          entry.key: (entry.value as ExpressionContent).raw
        else
          entry.key: entry.value
      };
}

class OperatorExpression extends Expression {
  OperatorExpression(String operator, value) : super(operator, value);
  String get operator => entry.key;
}

//          {
//            r'$currentDate': {
//              'a': {r'$type': 'date'},
//              'b': {r'$type': 'timestamp'},
//              'c': {r'$type': 'date'}
//            }
//          }

/// UpdateExpression = MapExpression<OperatorExpression>
/// OperatorExression = operator : MapExpression<FieldExpression>
/// OperatorListExpression = operator : ListExpression
/// FieldExpression = fieldName : 
///       value | listExpression | OpratorExpression | OperatorListExpression | 
///       MapExpression<Operator> 
/// Expression = key : value
