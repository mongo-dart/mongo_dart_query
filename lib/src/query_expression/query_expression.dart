import 'dart:convert';

import 'package:bson/bson.dart';
import 'package:mongo_dart_query/src/expression/basic_expression.dart';
import 'package:mongo_dart_query/src/query_expression/sort_expression.dart';

import '../expression/common/constant.dart';
import '../expression/common/document_types.dart';
import '../expression/common/operators_def.dart';
import '../expression/field_expression.dart';
import '../geometry_obj.dart';
import 'filter_expression.dart';

QueryExpression get where => QueryExpression();

class QueryExpression {
  static final RegExp objectIdRegexp = RegExp('.ObjectId...([0-9a-f]{24})....');

  FilterExpression filter = FilterExpression();
  QueryFilter get rawFilter => filter.rawContent;

  SortExpression sortExp = SortExpression();
  int _skip = 0;
  int _limit = 0;

  /// Returs a Json version of the filter
  String getQueryString() => json.encode(filter.rawContent);

  /// Inserts a raw document as filter
  void raw(MongoDocument document) => filter.addDocument(document);

  ExpressionContent _valueToContent(dynamic value) {
    if (value is ExpressionContent) {
      return value;
    } else if (value is MongoDocument) {
      return MapExpression(value);
    } else if (value is List) {
      return ListExpression(value);
    } else if (value is Set) {
      return SetExpression(value);
    }
    return ValueExpression.create(value);
  }

  // ***************************************************
  // ***************** Parenthesis
  // ***************************************************
  void get open => filter.open;
  void get close => filter.close;

  // ***************************************************
  // ***************** Comparison Operators
  // ***************************************************

  /// Matches values that are equal to a specified value.
  void $eq(String fieldName, value) => filter.addFieldOperator(FieldExpression(
      fieldName, OperatorExpression(op$Eq, _valueToContent(value))));

  void id(value) => $eq(field_id, value);

  /// Matches values that are greater than a specified value.
  void $gt(String fieldName, value) => filter.addFieldOperator(FieldExpression(
      fieldName, OperatorExpression(op$Gt, _valueToContent(value))));

  /// Matches values that are greater than or equal to a specified value.
  void $gte(String fieldName, value) => filter.addFieldOperator(FieldExpression(
      fieldName, OperatorExpression(op$Gte, _valueToContent(value))));

  /// Matches any of the values specified in an array.
  void $in(String fieldName, List values) =>
      filter.addOperator(OperatorExpression(
          op$In, FieldExpression(fieldName, ListExpression(values))));

  /// Matches values that are less than a specified value.
  void $lt(String fieldName, value) => filter.addFieldOperator(FieldExpression(
      fieldName, OperatorExpression(op$Lt, _valueToContent(value))));

  /// Matches values that are less than or equal to a specified value.
  void $lte(String fieldName, value) => filter.addFieldOperator(FieldExpression(
      fieldName, OperatorExpression(op$Lte, _valueToContent(value))));

  /// Matches all values that are not equal to a specified value.
  void $ne(String fieldName, value) => filter.addFieldOperator(FieldExpression(
      fieldName, OperatorExpression(op$Ne, _valueToContent(value))));

  /// Matches none of the values specified in an array.
  void $nin(String fieldName, List values) =>
      filter.addOperator(OperatorExpression(
          op$Nin, FieldExpression(fieldName, ListExpression(values))));
// ***************************************************
  // ***************** Text Search Operator
  // ***************************************************
  void $text(String search,
          {String? language, bool? caseSensitive, bool? diacriticSensitive}) =>
      filter.addOperator(OperatorExpression(
          op$Text,
          MapExpression({
            op$Search: search,
            if (language != null) op$Language: language,
            if (caseSensitive != null && caseSensitive)
              op$CaseSensitive: caseSensitive,
            if (diacriticSensitive != null && diacriticSensitive)
              op$DiacriticSensitive: diacriticSensitive,
          })));
  // ***************************************************
  // ***************** Logical Operators
  // ***************************************************

  /// $not Inverts the effect of a query expression and returns documents
  /// that do not match the query expression.
  void $not(OperatorExpression operatorExp) =>
      filter.addOperator(OperatorExpression(op$Not, operatorExp));

  /// $and performs a logical AND operation and selects the documents that
  /// satisfy all the expressions.
  void get $and => filter.logicAnd();

  /// $or operator performs a logical OR operation on an array of one or
  /// more expressions and selects the documents that satisfy at least one
  /// of the expressions.
  void get $or => filter.logicOr();

  /// $nor performs a logical NOR operation on an array of one or
  /// more query expression and selects the documents that fail all the
  /// query expressions in the array.
  void get $nor => filter.logicNor();

  // ***************************************************
  // **************         Sort          **************
  // ***************************************************
  void sortBy(Object field) {
    if (field is String) {
      sortExp.addField(field);
    } else if (field is IndexDocument) {
      for (var entry in field.entries) {
        if (entry.value is int) {
          if (entry.value == -1) {
            sortExp.addField(entry.key, descending: true);
          } else {
            sortExp.addField(entry.key);
          }
        } else if (entry.value is IndexDocument) {
          if ((entry.value as IndexDocument).length == 1 &&
              (entry.value as IndexDocument).entries.first.key == r'$meta' &&
              (entry.value as IndexDocument).entries.first.value ==
                  'textScore') {
            sortExp.add$meta(entry.key);
          } else {
            throw ArgumentError(
                'The received document seems to be not correct ("${entry.value}")');
          }
        }
      }
    } else {
      throw ArgumentError(
          'The received field seems to be not correct ("$field")');
    }
  }

  // ***************************************************
  // **************        Limit         **************
  // ***************************************************
  void limit(int limit) => _limit = limit;
  int getLimit() => _limit;

  // ***************************************************
  // **************         Skip          **************
  // ***************************************************
  void skip(int skip) => _skip = skip;
  int getSkip() => _skip;

  // *************************
  // ************** CHECK

  Map<String, Object>? _paramFields;

  Map<String, Object> get paramFields => _paramFields ??= <String, Object>{};

  // TODO revert after debug
  //@override
  //String toString() => 'QueryExpresion($filter.raw)';

  /// Copy to new instance
  static QueryExpression copyWith(QueryExpression other) {
    return QueryExpression()
      // TODO provide copy
      //..filter.raw = other.filter.raw
      .._paramFields = other._paramFields
      ..limit(other.getLimit())
      ..skip(other.getSkip());
  }

  ///
  QueryExpression clone() => copyWith(this);

  void _addExpression(String fieldName, value) {
    var exprMap = emptyMongoDocument;
    exprMap[fieldName] = value;
    if (rawFilter.isEmpty) {
      rawFilter[fieldName] = value;
    } else {
      _addExpressionMap(exprMap);
    }
  }

  void _addExpressionMap(Map<String, dynamic> expr) {
    if (rawFilter.containsKey('\$and')) {
      var expressions = rawFilter['\$and'] as List;
      expressions.add(expr);
    } else {
      var expressions = [rawFilter];
      expressions.add(expr);
      filter.rawContent['\$query'] = {'\$and': expressions};
    }
  }

  //void _ensureParamFields() => paramFields /* ??= <String, dynamic>{} */;

  void _ensureOrderBy() {
    rawFilter;
    if (!filter.rawContent.containsKey('orderby')) {
      filter.rawContent['orderby'] = <String, dynamic>{};
    }
  }

  void all(String fieldName, List values) =>
      _addExpression(fieldName, {'\$all': values});

  void nin(String fieldName, List values) =>
      _addExpression(fieldName, {'\$nin': values});

  void oneFrom(String fieldName, List values) =>
      _addExpression(fieldName, {'\$in': values});

  void exists(String fieldName) =>
      _addExpression(fieldName, {'\$exists': true});

  void notExists(String fieldName) =>
      _addExpression(fieldName, {'\$exists': false});

  void mod(String fieldName, int value) => _addExpression(fieldName, {
        '\$mod': [value, 0]
      });

  void match(String fieldName, String pattern,
          {bool? multiLine,
          bool? caseInsensitive,
          bool? dotAll,
          bool? extended}) =>
      _addExpression(fieldName, {
        '\$regex': BsonRegexp(pattern,
            multiLine: multiLine,
            caseInsensitive: caseInsensitive,
            dotAll: dotAll,
            extended: extended)
      });

  void inRange(String fieldName, min, max,
      {bool minInclude = true, bool maxInclude = false}) {
    var rangeMap = <String, dynamic>{};
    if (minInclude) {
      rangeMap['\$gte'] = min;
    } else {
      rangeMap['\$gt'] = min;
    }
    if (maxInclude) {
      rangeMap['\$lte'] = max;
    } else {
      rangeMap['\$lt'] = max;
    }
    _addExpression(fieldName, rangeMap);
  }

  // ********* SORT

  /* void sortBy(String fieldName, {bool descending = false}) {
    _ensureOrderBy();
    var order = 1;
    if (descending) {
      order = -1;
    }
    filter.rawContent['orderby'][fieldName] = order;
  } */

  /*  void sortByMetaTextScore(String fieldName) {
    _ensureOrderBy();
    filter.rawContent['orderby']
        [fieldName] = <String, dynamic>{'\$meta': 'textScore'};
  } */

  // *********** HINT

  void hint(String fieldName, {bool descending = false}) {
    rawFilter;
    if (!filter.rawContent.containsKey('\$hint')) {
      filter.rawContent['\$hint'] = <String, dynamic>{};
    }
    var order = 1;
    if (descending) {
      order = -1;
    }
    filter.rawContent['\$hint'][fieldName] = order;
  }

  void hintIndex(String indexName) {
    rawFilter;
    filter.rawContent['\$hint'] = indexName;
  }

  void comment(String commentStr) {
    rawFilter;
    filter.rawContent['\$comment'] = commentStr;
  }

  void explain() {
    rawFilter;
    filter.rawContent['\$explain'] = true;
  }

  void snapshot() {
    rawFilter;
    filter.rawContent['\$snapshot'] = true;
  }

  void showDiskLoc() {
    rawFilter;
    filter.rawContent['\$showDiskLoc'] = true;
  }

  void returnKey() {
    rawFilter;
    filter.rawContent['\$sreturnKey'] = true;
  }

  void jsQuery(String javaScriptCode) =>
      rawFilter['\$where'] = BsonCode(javaScriptCode);

  // this is for projection fields
  void metaTextScore(String fieldName) {
    paramFields[fieldName] = {'\$meta': 'textScore'};
  }

  void fields(List<String> fields) {
    for (var field in fields) {
      paramFields[field] = 1;
    }
  }

  void excludeFields(List<String> fields) {
    for (var field in fields) {
      paramFields[field] = 0;
    }
  }

  void within(String fieldName, value) => _addExpression(fieldName, {
        '\$within': {'\$box': value}
      });

  void near(String fieldName, var value, [double? maxDistance]) {
    if (maxDistance == null) {
      _addExpression(fieldName, {'\$near': value});
    } else {
      _addExpression(
          fieldName, {'\$near': value, '\$maxDistance': maxDistance});
    }
  }

  /// Only support $geometry shape operator
  /// Available ShapeOperator instances: Box , Center, CenterSphere, Geometry
  void geoWithin(String fieldName, ShapeOperator shape) =>
      _addExpression(fieldName, {'\$geoWithin': shape.build()});

  /// Only support geometry of point
  void nearSphere(String fieldName, Geometry point,
          {double? maxDistance, double? minDistance}) =>
      _addExpression(fieldName, {
        '\$nearSphere': <String, dynamic>{
          if (minDistance != null) '\$minDistance': minDistance,
          if (maxDistance != null) '\$maxDistance': maxDistance
        }..addAll(point.build()),
      });

  ///
  void geoIntersects(String fieldName, Geometry coordinate) =>
      _addExpression(fieldName, {'\$geoIntersects': coordinate.build()});

  /// Combine current expression with expression in parameter.
  /// [See MongoDB doc](http://docs.mongodb.org/manual/reference/operator/and/#op._S_and)
  /// [QueryExpression] provides implicit `and` operator for chained queries so these two expression will produce
  /// identical MongoDB queries
  ///
  ///     where.eq('price', 1.99).lt('qty', 20).eq('sale', true);
  ///     where.eq('price', 1.99).and(where.lt('qty',20)).and(where.eq('sale', true))
  ///
  /// Both these queries would produce json map:
  ///
  ///     {'\$query': {'\$and': [{'price':1.99},{'qty': {'\$lt': 20 }}, {'sale': true }]}}
  QueryExpression and(QueryExpression other) {
    if (rawFilter.isEmpty) {
      throw StateError('`And` operation is not supported on empty query');
    }
    _addExpressionMap(other.rawFilter);
    return this;
  }

  /// Combine current expression with expression in parameter by logical operator **OR**.
  /// [See MongoDB doc](https://www.mongodb.com/docs/manual/reference/operator/query/or/)
  /// For example
  ///    inventory.find(where.eq('price', 1.99).and(where.lt('qty',20).or(where.eq('sale', true))));
  ///
  /// This query will select all documents in the inventory collection where:
  /// * the **price** field value equals 1.99 and
  /// * either the **qty** field value is less than 20 or the **sale** field value is true
  /// MongoDB json query from this expression would be
  ///      {'\$query': {'\$and': [{'price':1.99}, {'\$or': [{'qty': {'\$lt': 20 }}, {'sale': true }]}]}}
  QueryExpression or(QueryExpression other) {
    if (rawFilter.isEmpty) {
      throw StateError('`Or` operation is not supported on empty query');
    }
    if (rawFilter.containsKey('\$or')) {
      var expressions = rawFilter['\$or'] as List;
      expressions.add(other.rawFilter);
    } else {
      var expressions = [rawFilter];
      expressions.add(other.rawFilter);
      filter.rawContent['\$query'] = {'\$or': expressions};
    }
    return this;
  }
}
