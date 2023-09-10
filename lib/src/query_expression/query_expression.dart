import 'dart:convert';

import 'package:bson/bson.dart';
import 'package:mongo_dart_query/mongo_aggregation.dart';
import 'package:mongo_dart_query/src/expression/basic_expression.dart';
import 'package:mongo_dart_query/src/query_expression/projection_expression.dart';
import 'package:mongo_dart_query/src/query_expression/sort_expression.dart';

import '../expression/common/constant.dart';
import '../expression/common/document_types.dart';
import '../expression/common/operators_def.dart';
import '../expression/field_expression.dart';
import 'filter_expression.dart';

QueryExpression get where => QueryExpression();

class QueryExpression {
  static final RegExp objectIdRegexp = RegExp('.ObjectId...([0-9a-f]{24})....');

  FilterExpression filter = FilterExpression();
  QueryFilter get rawFilter => filter.rawContent;

  SortExpression sortExp = SortExpression();
  ProjectionExpression fields = ProjectionExpression();
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
      fieldName, OperatorExpression(op$eq, _valueToContent(value))));

  void id(value) => $eq(field_id, value);

  /// Matches values that are greater than a specified value.
  void $gt(String fieldName, value) => filter.addFieldOperator(FieldExpression(
      fieldName, OperatorExpression(op$gt, _valueToContent(value))));

  /// Matches values that are greater than or equal to a specified value.
  void $gte(String fieldName, value) => filter.addFieldOperator(FieldExpression(
      fieldName, OperatorExpression(op$gte, _valueToContent(value))));

  /// Matches any of the values specified in an array.
  void $in(String fieldName, List values) =>
      filter.addFieldOperator(FieldExpression(
          fieldName, OperatorExpression(op$in, ListExpression(values))));

  /// Matches values that are less than a specified value.
  void $lt(String fieldName, value) => filter.addFieldOperator(FieldExpression(
      fieldName, OperatorExpression(op$lt, _valueToContent(value))));

  /// Matches values that are less than or equal to a specified value.
  void $lte(String fieldName, value) => filter.addFieldOperator(FieldExpression(
      fieldName, OperatorExpression(op$lte, _valueToContent(value))));

  /// Matches all values that are not equal to a specified value.
  void $ne(String fieldName, value) => filter.addFieldOperator(FieldExpression(
      fieldName, OperatorExpression(op$ne, _valueToContent(value))));

  /// Matches none of the values specified in an array.
  void $nin(String fieldName, List values) =>
      filter.addOperator(OperatorExpression(
          op$nin, FieldExpression(fieldName, ListExpression(values))));

  // ***************************************************
  // ***************** Logical Operators
  // ***************************************************

  /// $and performs a logical AND operation and selects the documents that
  /// satisfy all the expressions.
  void get $and => filter.logicAnd();

  /// $not Inverts the effect of a query expression and returns documents
  /// that do not match the query expression.
  void $not(OperatorExpression operatorExp) =>
      filter.addOperator(OperatorExpression(op$not, operatorExp));

  /// $nor performs a logical NOR operation on an array of one or
  /// more query expression and selects the documents that fail all the
  /// query expressions in the array.
  void get $nor => filter.logicNor();

  /// $or operator performs a logical OR operation on an array of one or
  /// more expressions and selects the documents that satisfy at least one
  /// of the expressions.
  void get $or => filter.logicOr();

  // ***************************************************
  // ***************** Element Query Operators
  // ***************************************************

  /// $exists matches the documents that contain the field,
  /// including documents where the field value is null.
  void $exists(String fieldName) => filter.addFieldOperator(FieldExpression(
      fieldName, OperatorExpression(op$exists, _valueToContent(true))));

  ///  notExist reTurns only the documents that do not contain the field.
  void notExists(String fieldName) => filter.addFieldOperator(FieldExpression(
      fieldName, OperatorExpression(op$exists, _valueToContent(false))));

  /// $type selects documents where the value of the field is an instance
  /// of the specified BSON type(s). Querying by data type is useful
  /// when dealing with highly unstructured data where data types
  /// are not predictable.
  /// You can user either the identification number o the type alias:
  /// BSON Type       Id Number        Alias              Const
  ///   Double          1             "double"          bsonDataNumber
  ///   String          2             "string"          bsonDataString
  ///   Object          3             "object"          bsonDataObject
  ///   Array           4             "array"           bsonDataArray
  ///   Binary Data     5             "binData"         bsonDataBinary
  ///   ObjectId        7             "objectId"        bsonDataObjectId
  ///   Boolean         8             "bool"            bsonDataBool
  ///   Date            9             "date"            bsonDataDate
  ///   Null           10             "null"            bsonDataNull
  ///   Regular Exp    11             "regex"           bsonDataRegExp
  ///   32-bit integer 16             "int"             bsonDataInt
  ///   Timestamp      17             "timestamp"       bsonDataTimestamp
  ///   64-bit integer 18             "long"            bsonDataLong
  ///   Decimal128     19             "decimal"         bsonDecimal128
  void $type(String fieldName, List types) =>
      filter.addFieldOperator(FieldExpression(
          fieldName, OperatorExpression(op$type, ListExpression(types))));
  // ***************************************************
  // ***************** Evaluation Query Operators
  // ***************************************************

  void $expr(Operator aggregationExpression) =>
      filter.addOperator(OperatorExpression(
          op$expr, MapExpression(aggregationExpression.build())));

  /// The $jsonSchema operator matches documents that satisfy the
  /// specified JSON Schema.
  // TODO check if String or MAp are required
  void $jsonSchema(String schemaObject) => filter.addOperator(
      OperatorExpression(op$jsonSchema, _valueToContent(schemaObject)));

  /// Select documents where the value of a field divided by a divisor
  /// has the specified remainder (i.e. perform a modulo operation to
  /// select documents).
  /// The reminder defaults to zero
  void $mod(String fieldName, int value, {int reminder = 0}) =>
      filter.addFieldOperator(FieldExpression(fieldName,
          OperatorExpression(op$mod, ListExpression([value, reminder]))));

  /// Provides regular expression capabilities for pattern matching
  /// strings in queries. MongoDB uses Perl compatible regular expressions
  /// (i.e. "PCRE" ) version 8.42 with UTF-8 support.
  void $regex(String fieldName, String pattern,
      {bool caseInsensitive = false,
      bool multiLineAnchorMatch = false,
      bool extendedIgnoreWhiteSpace = false,
      bool dotMAtchAll = false}) {
    var options = '${caseInsensitive ? 'i' : ''}'
        '${multiLineAnchorMatch ? 'm' : ''}'
        '${extendedIgnoreWhiteSpace ? 'x' : ''}'
        '${dotMAtchAll ? 's' : ''}';

    filter.addFieldOperator(FieldExpression(
        fieldName,
        MapExpression({
          op$regex: _valueToContent(pattern),
          if (options.isNotEmpty) op$options: options
        })));
  }

  void $text(String search,
          {String? language, bool? caseSensitive, bool? diacriticSensitive}) =>
      filter.addOperator(OperatorExpression(
          op$text,
          MapExpression({
            op$search: search,
            if (language != null) op$language: language,
            if (caseSensitive != null && caseSensitive)
              op$caseSensitive: caseSensitive,
            if (diacriticSensitive != null && diacriticSensitive)
              op$diacriticSensitive: diacriticSensitive,
          })));

  /// Use the $where operator to pass either a string containing a JavaScript
  /// expression or a full JavaScript function to the query system.
  /// The $where provides greater flexibility, but requires that the database
  /// processes the JavaScript expression or function for each document
  /// in the collection.
  /// Reference the document in the JavaScript expression or function
  /// using either this or obj .
  void $where(String function) => filter
      .addOperator(OperatorExpression(op$where, _valueToContent(function)));

  // ***************************************************
  // ***************** Geo Spatial
  // ***************************************************

  /// Geospatial operators return data based on geospatial expression conditions
  void $geoIntersects(String fieldName, Geometry coordinate) =>
      filter.addFieldOperator(FieldExpression(
          fieldName,
          OperatorExpression(
              op$geoIntersects, MapExpression(coordinate.build()))));

  /// Selects documents with geospatial data that exists entirely
  /// within a specified shape.
  /// Only support $geometry shape operator
  /// Available ShapeOperator instances: Box , Center, CenterSphere, Geometry
  void $geoWithin(String fieldName, ShapeOperator shape) =>
      filter.addFieldOperator(FieldExpression(fieldName,
          OperatorExpression(op$geoWithin, MapExpression(shape.build()))));

  /// Specifies a point for which a geospatial query returns the documents
  /// from nearest to farthest.
  void $near(String fieldName, var value,
      {double? maxDistance, double? minDistance}) {
    filter.addFieldOperator(FieldExpression(
        fieldName,
        MapExpression({
          op$near: value,
          if (minDistance != null) op$minDistance: minDistance,
          if (maxDistance != null) op$maxDistance: maxDistance
        })));
  }

  /// Specifies a point for which a geospatial query returns the documents
  /// from nearest to farthest.
  /// Only support geometry of point
  void $nearSphere(String fieldName, Geometry point,
          {double? maxDistance, double? minDistance}) =>
      filter.addFieldOperator(FieldExpression(
          fieldName,
          OperatorExpression(
              op$nearSphere,
              MapExpression({
                if (minDistance != null) op$minDistance: minDistance,
                if (maxDistance != null) op$maxDistance: maxDistance
              }..addAll(point.build())))));

  // ***************************************************
  // ***************** Array Query Operator
  // ***************************************************

  /// The $all operator selects the documents where the value of a field is
  /// an array that contains all the specified elements.
  void $all(String fieldName, List values) =>
      filter.addFieldOperator(FieldExpression(
          fieldName, OperatorExpression(op$all, ListExpression(values))));

  /// The $elemMatch operator matches documents that contain an array
  /// field with at least one element that matches all the specified query criteria.
  void $elemMatch(String fieldName, List values) =>
      filter.addFieldOperator(FieldExpression(
          fieldName, OperatorExpression(op$elemMatch, ListExpression(values))));

  void $size(String fieldName, int numElements) =>
      filter.addFieldOperator(FieldExpression(fieldName,
          OperatorExpression(op$size, _valueToContent(numElements))));

  /*  void match(String fieldName, String pattern,
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
      }); */

  void inRange(String fieldName, min, max,
      {bool minInclude = true, bool maxInclude = false}) {
    var mapExp = MapExpression.empty();
    if (minInclude) {
      mapExp.addExpression(OperatorExpression(op$gte, _valueToContent(min)));
    } else {
      mapExp.addExpression(OperatorExpression(op$gt, _valueToContent(min)));
    }
    if (maxInclude) {
      mapExp.addExpression(OperatorExpression(op$lte, _valueToContent(max)));
    } else {
      mapExp.addExpression(OperatorExpression(op$lt, _valueToContent(max)));
    }
    filter.addFieldOperator(FieldExpression(fieldName, mapExp));
  }

  // ***************************************************
  // **************    Bit wise operators
  // ***************************************************

  // TODO Missing  $bitsAllClear
  // TODO Missing $bitsAllSet
  // TODO Missing $bitsAnyClear
  // TODO Missing $bitsAnySet

  // ***************************************************
  // **************    Miscellaneous query operators
  // ***************************************************

  /// The $comment query operator associates a comment to any expression
  /// taking a query predicate.
  void $comment(String commentStr) {
    filter.addOperator(
        OperatorExpression(op$comment, _valueToContent(commentStr)));
  }
  // TODO Missing $rand
  // TODO Missing $natural

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
  // **************        Project        **************
  // ***************************************************

  void selectMetaTextScore(String fieldName) =>
      fields.add$metaTextScore(fieldName);

  void selectFields(List<String> fields) {
    for (var field in fields) {
      this.fields.includeField(field);
    }
  }

  void excludeFields(List<String> fields) {
    for (var field in fields) {
      this.fields.excludeField(field);
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

  // ***************************************************
  // **************         Copy           **************
  // ***************************************************

  /// Copy to new instance
  static QueryExpression copyWith(QueryExpression other) {
    return QueryExpression()
      ..filter.addDocument(other.filter.rawContent)
      ..sortExp.addMap(other.sortExp.rawContent)
      ..fields.addMap(other.fields.rawContent)
      ..limit(other.getLimit())
      ..skip(other.getSkip());
  }

  ///
  QueryExpression clone() => copyWith(this);

  // *************************
  // ************** CHECK

  // TODO revert after debug
  //@override
  //String toString() => 'QueryExpresion($filter.raw)';

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

  /*  void _ensureOrderBy() {
    rawFilter;
    if (!filter.rawContent.containsKey('orderby')) {
      filter.rawContent['orderby'] = <String, dynamic>{};
    }
  } */
/* 
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
  } */

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
      rawFilter['\$where'] = BsonCode(JsCode(javaScriptCode));

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
