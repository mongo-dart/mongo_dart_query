import 'package:mongo_dart_query/src/expression/common/operators_def.dart';
import 'package:mongo_dart_query/src/expression/field_expression.dart';

import 'common/document_types.dart';

abstract class ExpressionContent {
  dynamic get rawContent;
}

class ValueExpression extends ExpressionContent {
  ValueExpression._(value) : _value = value;

  static ExpressionContent create(value) {
    var tempExpression = _setValue(value);
    if (tempExpression is ExpressionContent) {
      return tempExpression;
    }
    return ValueExpression._(tempExpression);
  }

  final dynamic _value;

  @override
  dynamic get rawContent {
    if (_value is ExpressionContent) {
      return _value.rawContent;
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

abstract class ExpressionContainer extends ExpressionContent {
  bool get isEmpty;
  bool get isNotEmpty;
}

class ListExpression extends ExpressionContainer {
  ListExpression(this.values);
  ListExpression.empty() : values = [];

  List values;

  int get length => values.length;

  @override
  bool get isEmpty => values.isEmpty;

  @override
  bool get isNotEmpty => values.isNotEmpty;
  bool get canBeSimplified {
    var keys = keysList;
    if (keys == null) {
      return false;
    }
    if (keys.length == 1) {
      return true;
    }
    for (int pos = 0; pos < keys.length - 1; pos++) {
      if (keys[pos] == '') {
        continue;
      }
      if (keys.sublist(pos + 1).contains(keys[pos])) return false;
    }
    /* var value = keys..(
        (element) => element != '' && keys.contains(element),
        orElse: () => '');
    return value == ''; */
    return true;
  }

  /* {
    var rawTemp = raw;
    var localKeys = <String>[];
    for (var element in rawTemp) {
      if (element is! Map) {
        return false;
      }
      if (element.keys.length > 1) {
        return false;
      }
      if (element.isEmpty) {
        continue;
      }
      var key = element.keys.first;
      if (key is! String) {
        return false;
      }
      if (localKeys.contains(key)) {
        return false;
      }
      localKeys.add(key);
    }
    return true;
  } */

  List<String>? get keysList {
    var rawTemp = rawContent;
    var localKeys = <String>[];
    for (var element in rawTemp) {
      if (element is! Map) {
        return null;
      }
      if (element.keys.length > 1) {
        return null;
      }
      if (element.isEmpty) {
        localKeys.add('');
        continue;
      }
      var key = element.keys.first;
      if (key is! String) {
        return null;
      }
      localKeys.add(key);
    }
    return localKeys;
  }

  void add(value) => values.add(value);

  @override
  List get rawContent => [
        for (var element in values)
          element is Expression
              ? element.raw
              : (element is ExpressionContent ? element.rawContent : element)
      ];

  MongoDocument get content2map => {
        for (var element in values)
          if (element is Expression)
            ...element.raw
          else if (element is MongoDocument)
            ...element
          else if (element is MapExpression)
            ...element.rawContent
          else if (element is ExpressionContent)
            'key': element.rawContent
          else
            'key': element
      };

  MongoDocument get mergeContent2map {
    var ret = MapExpression.empty();

    for (var element in values) {
      if (element is Expression) {
        ret.mergeExpression(element);
      } else if (element is MongoDocument) {
        for (var entity in element.entries) {
          ret.merge(entity.key, entity.value);
        }
      } else if (element is MapExpression) {
        for (var entity in element.rawContent.entries) {
          ret.merge(entity.key, entity.value);
        }
      } else if (element is ExpressionContent) {
        ret.merge('key', element.rawContent);
      } else {
        ret.merge('key', element);
      }
    }
    MongoDocument allAnd = emptyMongoDocument;
    for (var entry in ret.valueMap.entries) {
      if (entry.key != op$and) {
        break;
      }
      allAnd = {
        ...allAnd,
        if (entry.value is List)
          for (var element in entry.value) ...element
        else
          ...entry.value
      };
    }
    if (allAnd.isNotEmpty) {
      return allAnd;
    }

    return ret.rawContent;
  }

  bool mergeAtElement(ExpressionContent expression, int index) {
    var toBeMerged = values.elementAt(index);
    if (toBeMerged is MapExpression) {
      if (toBeMerged.length != 1) {
        return false;
      }
      if (expression is Expression) {
        toBeMerged.mergeExpression(expression);
      } else if (expression is MapExpression) {
        toBeMerged.mergeMapExpression(expression);
      }
      return true;
    }
    if (toBeMerged is Expression) {
      MapExpression mapExpression;
      if (toBeMerged.content is! MapExpression) {
        mapExpression = MapExpression(toBeMerged.rawContent);
      } else {
        mapExpression = toBeMerged.content as MapExpression;
      }
      if (expression is FieldExpression && expression.content is Expression) {
        mapExpression.mergeExpression(expression.content as Expression);
      } else if (expression is Expression) {
        // TODO check
        mapExpression.mergeExpression(expression);
      } else if (expression is MapExpression) {
        if (mapExpression.length != 1) {
          return false;
        }
        mapExpression.mergeMapExpression(expression);
      }
      values[index] = Expression(toBeMerged.key, mapExpression);
      return true;
    }
    return false;
  }
}

class SetExpression extends ExpressionContainer {
  SetExpression(this.values);

  Set values;

  void add(value) => values.add(value);

  @override
  Set get rawContent => {
        for (var element in values)
          element is ExpressionContent ? element.rawContent : element
      };

  @override
  bool get isEmpty => values.isEmpty;

  @override
  bool get isNotEmpty => values.isNotEmpty;
}

/// A container for a Map
///
/// It can contain empty maps, with only one element or even more.
class MapExpression extends ExpressionContainer {
  // Constructor must be designed like this, so that the
  // valueMap Map continues beeing of type MongoDocument.
  // If not, we could have problems with the addAll method
  MapExpression(MongoDocument value) : valueMap = {...value};
  MapExpression.empty() : valueMap = emptyMongoDocument;

  MongoDocument valueMap;
  int get length => valueMap.length;

  @override
  MongoDocument get rawContent => {
        for (var entry in valueMap.entries)
          if (entry.value is Expression)
            entry.key: entry.value.raw
          else if (entry.value is ExpressionContent)
            entry.key: entry.value.rawContent
          else
            entry.key: entry.value
      };

  @override
  bool get isEmpty => valueMap.isEmpty;

  @override
  bool get isNotEmpty => valueMap.isNotEmpty;

  bool get hasOneKeyOnly => valueMap.length == 1;
  bool get canBePromotedToExpression => hasOneKeyOnly;

  Expression? toExpression() => !canBePromotedToExpression
      ? null
      : Expression(
          valueMap.keys.first, ValueExpression.create(valueMap.values.first));

  /// Set a Map
  /// Clears the original content and add the new one
  void setMap(MongoDocument map) => valueMap = {...map};

  /// Set a MapExpression -
  /// Clears the original content and add the new one
  void setMapExpression(MapExpression expression) =>
      setMap({...expression.rawContent});

  /// Set a key-value pair
  ///Clears the original content and add the key value pair received
  void setEntry(String key, value) => setMap({key: value});

  /// Set a Map entry
  /// The Content is cleared and the single key-value pair is inserted
  void setMapEntry(MapEntry<String, dynamic> entry) =>
      setMap({entry.key: entry.value});

  /// Set an Expression
  /// clears the original content and add the expression
  /// as expressionKey : expressionContent (as map)
  void setExpression(Expression operatorExp) => setMap(operatorExp.raw);

  /// Add a Map
  /// Add a map content to the actual content.
  /// If any key alreay exists, it is substituted
  void addMap(MongoDocument map) => valueMap.addAll(map);

  /// Add a MapExpression -
  /// Add a map expression content to the actual content.
  /// If any key alreay exists, it is substituted
  void addMapExpression(MapExpression expression) =>
      addMap(expression.rawContent);

  /// Add a key-value pair
  /// If the key already exists, the value is substituted
  void addEntry(String key, value) => valueMap[key] = value;

  /// Add an Expression -
  /// Add an expression key-value pair to the actual content.
  /// If they key alreay exists, its value is substituted
  void addExpression(Expression operatorExp) => addMap(operatorExp.raw);

  /// Add a key-value pair
  /// If the key already exists, the value is substituted
  void addMapEntry(MapEntry<String, dynamic> entry) =>
      addEntry(entry.key, entry.value);

  /// Tries to merge the contents if they both are resolvable
  /// to a Map, otherwise acts like an addEntry method
  ///
  /// Checks if there is not the key
  /// If not adds the key - content pair to the actual content.
  /// Otherwise checks if acrual and received contents are resolvable
  /// to a Map. If not, it acts like an addEntry method.
  ///
  /// If yes it adds the new content to the actual content
  /// If a key of the content is already present its value is overwritten
  void merge(key, content) {
    if (!valueMap.containsKey(key)) {
      addEntry(key, content);
      return;
    }
    /* if (content is! Map &&
        content is! MapExpression &&
        content is! MapEntry &&
        content is! Expression) {
      addEntry(key, content);
      return;
    } */
    MongoDocument contentMap;
    if (content is MongoDocument) {
      contentMap = content;
    } else if (content is Expression) {
      contentMap = content.raw;
    } else if (content is MapExpression) {
      contentMap = content.rawContent;
    } else if (content is MapEntry) {
      contentMap = {content.key: content.value};
    } else {
      addEntry(key, content);
      return;
    }
    var origin = valueMap[key];

    /*   if (origin is Map) {
      addEntry(key, {...origin, ...contentMap});
    } else if (origin is Expression) {
      addEntry(key, {...origin.raw, ...contentMap});
    } else if (origin is MapExpression) {
      addEntry(key, {...origin.rawContent, ...contentMap});
    } else if (origin is MapEntry) {
      addEntry(key, {origin.key: origin.value, ...contentMap});
    } else {
      // TODO check
      addEntry(key, contentMap);
      //var entry = contentMap.entries.first;
      //addEntry(entry.key, entry.value);
    }
 */
    if (origin is Map) {
      contentMap = {...origin, ...contentMap};
    } else if (origin is Expression) {
      contentMap = {...origin.raw, ...contentMap};
    } else if (origin is MapExpression) {
      contentMap = {...origin.rawContent, ...contentMap};
    } else if (origin is MapEntry) {
      contentMap = {origin.key: origin.value, ...contentMap};
    }
    addEntry(key, contentMap);
  }

  /// Merges the entry in this mapExpression.
  void mergeEntry(MapEntry entry) => merge(entry.key, entry.value);

  /// Merges a MongoDocument into this MapExpression
  void mergeDocument(MongoDocument document) {
    for (var entry in document.entries) {
      mergeEntry(entry);
    }
  }

  /// Merges a MapExpression into this MapExpression
  void mergeMapExpression(MapExpression expression) =>
      mergeDocument(expression.rawContent);

  /// Merges a MapExpression into this MapExpression
  void mergeExpression(Expression expression) =>
      merge(expression.key, expression.content);
}

class Expression<T extends ExpressionContent> extends ExpressionContent {
  Expression(String key, T value) : entry = MapEntry<String, T>(key, value);
  Expression.fromMapEntry(this.entry);
  MapEntry<String, T> entry;

  String get key => entry.key;
  T get content => entry.value;

  MongoDocument get raw => {
        entry.key: content is Expression
            ? (content as Expression).raw
            : content.rawContent
      };
  @override
  dynamic get rawContent =>
      content is Expression ? (content as Expression).raw : content.rawContent;
}

class OperatorExpression<T extends ExpressionContent> extends Expression<T> {
  OperatorExpression(String operator, T value) : super(operator, value);
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
