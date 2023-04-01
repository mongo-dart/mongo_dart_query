import 'dart:convert';

import 'package:bson/bson.dart';
import 'package:mongo_dart_query/src/common/constant.dart';
import 'package:mongo_dart_query/src/common/document_types.dart';

import '../common/operators_def.dart';
import '../geometry_obj.dart';
import 'filter_expression.dart';

QueryExpression get where => QueryExpression();
const keyQuery = r'$query';

class QueryExpression {
  static final RegExp objectIdRegexp = RegExp('.ObjectId...([0-9a-f]{24})....');
  Map<String, dynamic> map = {};

  FilterExpression filter = FilterExpression();

  QueryFilter get rawFilter => filter.raw;

  // ***************************************************
  // ***************** Comparison Operators
  // ***************************************************

  /// Matches values that are equal to a specified value.
  void $eq(String fieldName, value) =>
      filter.addExpression(op$Eq, fieldName, value);

  void id(value) => $eq(field_id, value);

  /// Matches values that are greater than a specified value.
  void $gt(String fieldName, value) =>
      filter.addExpression(op$Gt, fieldName, value);

  /// Matches values that are greater than or equal to a specified value.
  void $gte(String fieldName, value) =>
      filter.addExpression(op$Gte, fieldName, value);

  /// Matches any of the values specified in an array.
  void $in(String fieldName, List values) =>
      filter.addExpression(op$In, fieldName, values);

  /// Matches values that are less than a specified value.
  void $lt(String fieldName, value) =>
      filter.addExpression(op$Lt, fieldName, value);

  /// Matches values that are less than or equal to a specified value.
  void $lte(String fieldName, value) =>
      filter.addExpression(op$Lte, fieldName, value);

  /// Matches all values that are not equal to a specified value.
  void $ne(String fieldName, value) =>
      filter.addExpression(op$Ne, fieldName, value);

  /// Matches none of the values specified in an array.
  void $nin(String fieldName, List values) =>
      filter.addExpression(op$Nin, fieldName, values);

  // ***************************************************
  // ***************** Comaprison Operators
  // ***************************************************

  // *************************
  // ************** CHECK
  Map<String, dynamic> get _query {
    if (!map.containsKey(keyQuery)) {
      map[keyQuery] = <String, dynamic>{};
    }
    return map[keyQuery] as Map<String, dynamic>;
  }

  int paramSkip = 0;
  int paramLimit = 0;
  Map<String, Object>? _paramFields;

  Map<String, Object> get paramFields => _paramFields ??= <String, Object>{};

  @override
  String toString() => 'QueryExpresion($map)';

  /// Copy to new instance
  static QueryExpression copyWith(QueryExpression other) {
    return QueryExpression()
      ..map = other.map
      .._paramFields = other._paramFields
      ..paramLimit = other.paramLimit
      ..paramSkip = other.paramSkip;
  }

  ///
  QueryExpression clone() => copyWith(this);

  void _addExpression(String fieldName, value) {
    var exprMap = emptyMongoDocument;
    exprMap[fieldName] = value;
    if (_query.isEmpty) {
      _query[fieldName] = value;
    } else {
      _addExpressionMap(exprMap);
    }
  }

  void _addExpressionMap(Map<String, dynamic> expr) {
    if (_query.containsKey('\$and')) {
      var expressions = _query['\$and'] as List;
      expressions.add(expr);
    } else {
      var expressions = [_query];
      expressions.add(expr);
      map['\$query'] = {'\$and': expressions};
    }
  }

  //void _ensureParamFields() => paramFields /* ??= <String, dynamic>{} */;

  void _ensureOrderBy() {
    _query;
    if (!map.containsKey('orderby')) {
      map['orderby'] = <String, dynamic>{};
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

  void sortBy(String fieldName, {bool descending = false}) {
    _ensureOrderBy();
    var order = 1;
    if (descending) {
      order = -1;
    }
    map['orderby'][fieldName] = order;
  }

  void sortByMetaTextScore(String fieldName) {
    _ensureOrderBy();
    map['orderby'][fieldName] = <String, dynamic>{'\$meta': 'textScore'};
  }

  // *********** HINT

  void hint(String fieldName, {bool descending = false}) {
    _query;
    if (!map.containsKey('\$hint')) {
      map['\$hint'] = <String, dynamic>{};
    }
    var order = 1;
    if (descending) {
      order = -1;
    }
    map['\$hint'][fieldName] = order;
  }

  void hintIndex(String indexName) {
    _query;
    map['\$hint'] = indexName;
  }

  void comment(String commentStr) {
    _query;
    map['\$comment'] = commentStr;
  }

  void explain() {
    _query;
    map['\$explain'] = true;
  }

  void snapshot() {
    _query;
    map['\$snapshot'] = true;
  }

  void showDiskLoc() {
    _query;
    map['\$showDiskLoc'] = true;
  }

  void returnKey() {
    _query;
    map['\$sreturnKey'] = true;
  }

  void jsQuery(String javaScriptCode) =>
      _query['\$where'] = BsonCode(javaScriptCode);

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

  // ******* Limit

  void limit(int limit) => paramLimit = limit;
  void skip(int skip) => paramSkip = skip;

  QueryExpression raw(Map<String, dynamic> rawSelector) {
    map = rawSelector;
    return this;
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
    if (_query.isEmpty) {
      throw StateError('`And` operation is not supported on empty query');
    }
    _addExpressionMap(other._query);
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
    if (_query.isEmpty) {
      throw StateError('`Or` operation is not supported on empty query');
    }
    if (_query.containsKey('\$or')) {
      var expressions = _query['\$or'] as List;
      expressions.add(other._query);
    } else {
      var expressions = [_query];
      expressions.add(other._query);
      map['\$query'] = {'\$or': expressions};
    }
    return this;
  }

  String getQueryString() {
    var result = json.encode(map);
    return result;
  }
}
