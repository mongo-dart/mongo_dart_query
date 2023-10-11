import 'package:mongo_dart_query/mongo_aggregation.dart';
import 'package:mongo_dart_query/mongo_dart_query.dart';
import 'package:mongo_dart_query/src/mongo_aggregation/common.dart';

/// `$addFields` aggregation stage
///
/// ### Stage description.
///
/// `$addFields` appends new fields to existing documents. You can include one
/// or more `$addFields` stages in an aggregation pipeline.
///
/// To add field or fields to embedded documents (including documents in arrays)
/// use the dot notation.
///
/// To add an element to an existing array field with `$addFields`, use with
/// `$concatArrays`([ConcatArrays]).
///
/// Example:
///
/// Dart code
/// ```
/// AddFields({
///   'totalHomework': Sum(Field('homework')),
///   'totalQuiz': Sum(Field('quiz'))
/// }).build()
/// ```
/// Equivalent mongoDB aggregation stage:
/// ```
/// {
///  $addFields: {
///     totalHomework: { $sum: "$homework" } ,
///     totalQuiz: { $sum: "$quiz" }
///   }
/// }
/// ```
/// https://docs.mongodb.com/manual/reference/operator/aggregation/addFields/
class AddFields extends AggregationStage {
  /// Creates `$addFields` aggregation stage
  AddFields(Map<String, dynamic> fields) : super('addFields', AEObject(fields));
}

/// `$set` aggregation stage
///
/// ### Stage description
///
/// Available since MongoDB version 4.2
///
/// Adds new fields to documents. `$set` outputs documents that contain all
/// existing fields from the input documents and newly added fields.
///
/// The `$set` stage is an alias for `$addFields`.
///
/// `$set` appends new fields to existing documents. You can include one or
/// more $set stages in an aggregation operation.
///
/// To add field or fields to embedded documents (including documents in
/// arrays) use the dot notation.
///
/// To add an element to an existing array field with `$set`, use with
/// $concatArrays ([ConcatArrays]).
///
/// Dart code:
/// ```
/// SetStage({
///   'totalHomework': Sum(Field('homework')),
///   'totalQuiz': Sum(Field('quiz'))
/// }).build()
/// ```
/// Equivalent mongoDB aggregation stage:
/// ```
/// {
///   $set: {
///     totalHomework: { $sum: "$homework" },
///     totalQuiz: { $sum: "$quiz" }
///   }
/// }
/// ```
/// https://docs.mongodb.com/manual/reference/operator/aggregation/set/
class SetStage extends AggregationStage {
  /// Creates `$set` aggregation stage
  SetStage(Map<String, dynamic> fields) : super('set', AEObject(fields));
}

/// `$setWindowFields` aggregation stage
///
/// ### Stage description
///
/// Available since MongoDB version 5.0
///
/// Performs operations on a specified span of documents in a collection,
/// known as a window, and returns the results based on the chosen
/// window operator.
///
/// For example, you can use the $setWindowFields stage to output the:
/// -   Difference in sales between two documents in a collection.
/// -   Sales rankings.
/// -   Cumulative sales totals.
/// -   Analysis of complex time series information without exporting the data
///     to an external database.
///
/// Example:
///
/// Dart code:
/// ```
///   SetWindowFields(
///      partitionBy: {r'$year': r"$orderDate"},
///      sortBy: {'orderDate': 1},
///      output: Output('cumulativeQuantityForYear', Sum(r'$quantity'),
///          documents: ["unbounded", "current"])).build(),
/// ```
/// Equivalent mongoDB aggregation stage:
/// ```
///  {
///    r'$setWindowFields': {
///      'partitionBy': {r'$year': r"$orderDate"},
///      'sortBy': {'orderDate': 1},
///      'output': {
///        'cumulativeQuantityForYear': {
///          r'$sum': r"$quantity",
///          'window': {
///            'documents': ["unbounded", "current"]
///          }
///        }
///      }
///    }
///  }
/// ```
/// https://www.mongodb.com/docs/manual/reference/operator/aggregation/setWindowFields/
class SetWindowFields extends AggregationStage {
  /// Creates `$setWindowFields` aggregation stage
  ///
  /// * [partitionBy] Optional - Specifies an expression to group the documents.
  ///   In the $setWindowFields stage, the group of documents is known as a
  ///   partition. Default is one partition for the entire collection.
  /// * [sortBy] Required for some operators
  ///   Specifies the field(s) to sort the documents by in the partition.
  ///   Uses the same syntax as the $sort stage.
  ///   Default is no sorting.
  /// * [output] - Specifies the field(s) an related parameters to append to
  ///   the documents in the output returned by the $setWindowFields stage.
  ///   Each field is set to the result returned by the window operator.
  ///   The field can either an Output object, a list of Output Objects or a
  ///   document containing the explicit description of the output required
  SetWindowFields({
    partitionBy,
    Map<String, int>? sortBy,
    defaultId,
    required dynamic output,
  }) : super(
            stSetWindowFields,
            AEObject({
              if (partitionBy != null) spPartitionBy: partitionBy,
              if (sortBy != null) spSortBy: AEObject(sortBy),
              'output': _getOutputDocument(output),
            }));

  static AEObject _getOutputDocument(output) {
    if (output is Output) {
      return AEObject(output.build());
    } else if (output is List<Output>) {
      return AEObject({for (Output element in output) ...element.build()});
    } else if (output is Map<String, dynamic>) {
      return AEObject(output);
    } else {
      throw Exception(
          'output parm must be Map<String,dynamic>, Output or List<Output>');
    }
  }
}

/// `$unset` aggregation stage
///
/// ### Stage description
///
/// Available since MongoDB version 4.2
///
/// Removes/excludes fields from documents.
///
/// Example:
///
/// Dart code:
/// ```
/// Unset([ "isbn", "author.first", "copies.warehouse" ]).build()
/// ```
/// Equivalent mongoDB aggregation stage:
/// ```
/// { $unset: [ "isbn", "author.first", "copies.warehouse" ] }
/// ```
/// https://docs.mongodb.com/manual/reference/operator/aggregation/unset/
class Unset extends AggregationStage {
  /// Creates `$unset` aggreagation stage
  Unset(List<String> fields) : super('unset', fields);
}

/// `$bucket` aggregation stage
///
/// ### Stage description
///
/// Categorizes incoming documents into groups, called buckets, based on a
/// specified expression and bucket boundaries.
///
/// Each bucket is represented as a document in the output. The document for
/// each bucket contains an `_id` field, whose value specifies the inclusive
/// lower bound of the bucket and a count field that contains the number of
/// documents in the bucket. The count field is included by default when the
/// output is not specified.
///
/// `$bucket` only produces output documents for buckets that contain at least
/// one input document.
///
/// Example:
///
/// Dart code:
/// ```
/// Bucket(
///   groupBy: Field('price'),
///   boundaries: [0, 200, 400],
///   defaultId: "Other",
///   output: {
///     'count': Sum(1),
///     'titles': Push(Field('title'))
///   }
/// ).build()
/// ```
/// Equivalent mongoDB aggregation stage:
/// ```
/// {
///  $bucket: {
///    groupBy: "$price",
///    boundaries: [ 0, 200, 400 ],
///    default: "Other",
///    output: {
///      "count": { $sum: 1 },
///      "titles" : { $push: "$title" }
///    }
///  }
/// }
/// ```
/// https://docs.mongodb.com/manual/reference/operator/aggregation/bucket/
class Bucket extends AggregationStage {
  /// Creates `$bucket` aggregation stage
  ///
  /// * [groupBy] - An expression to group documents by. To specify a field
  /// path use [Field] object. Unless `$bucket` includes a default
  /// specification, each input document must resolve the groupBy field path
  /// or expression to a value that falls within one of the ranges specified
  /// by the boundaries.
  /// * [boundaries] - An array of values based on the [groupBy] expression that
  /// specify the boundaries for each bucket. Each adjacent pair of values acts
  /// as the inclusive lower boundary and the exclusive upper boundary for the
  /// bucket. You must specify at least two boundaries.
  ///
  /// Example:
  ///
  /// An array of `[ 0, 5, 10 ]` creates two buckets:
  ///
  ///   * [0, 5) with inclusive lower bound 0 and exclusive upper bound 5.
  ///   * [5, 10) with inclusive lower bound 5 and exclusive upper bound 10.
  ///
  ///
  /// * [defaultId] - Optional. A literal that specifies the `_id` of an
  /// additional bucket that contains all documents whose groupBy expression
  /// result does not fall into a bucket specified by boundaries. If
  /// unspecified, each input document must resolve the groupBy expression to
  /// a value within one of the bucket ranges specified by boundaries or the
  /// operation throws an error. The default value must be less than the lowest
  /// boundaries value, or greater than or equal to the highest boundaries
  /// value. The default value can be of a different type than the entries in
  /// boundaries.
  /// * [output] - Optional. A document that specifies the fields to include in
  /// the output documents in addition to the _id field. To specify the field
  /// to include, you must use accumulator expressions.
  Bucket(
      {required AggregationExpr groupBy,
      required List boundaries,
      defaultId,
      Map<String, Accumulator>? output})
      : super(
            'bucket',
            AEObject({
              'groupBy': groupBy,
              'boundaries': AEList(boundaries),
              if (defaultId != null) 'default': defaultId,
              if (output != null) 'output': AEObject(output)
            }));
}

/// `$bucketAuto` aggregation stage
///
/// ### Stage description
///
/// Categorizes incoming documents into a specific number of groups, called
/// buckets, based on a specified expression. Bucket boundaries are
/// automatically determined in an attempt to evenly distribute the documents
/// into the specified number of buckets.
///
/// Each bucket is represented as a document in the output. The document for
/// each bucket contains an _id field, whose value specifies the inclusive
/// lower bound and the exclusive upper bound for the bucket, and a count
/// field that contains the number of documents in the bucket. The count
/// field is included by default when the output is not specified.
///
/// https://docs.mongodb.com/manual/reference/operator/aggregation/bucketAuto/
class BucketAuto extends AggregationStage {
  /// Creates `$bucketAuto` aggregation stage
  ///
  /// * [groupBy] - An expression to group documents by. To specify a field path
  /// use [Field] object.
  /// * [buckets] - A positive integer that specifies the number of buckets
  /// into which input documents are grouped.
  /// * [output] - Optional. A document that specifies the fields to include in
  /// the output documents in addition to the `_id` field. To specify the field
  /// to include, you must use accumulator expressions
  /// * [granularity] - Optional. A [Granularity] that specifies the preferred
  /// number series to use to ensure that the calculated boundary edges end on
  /// preferred round numbers or their powers of 10.
  BucketAuto(
      {required AggregationExpr groupBy,
      required int buckets,
      Map<String, Accumulator>? output,
      Granularity? granularity})
      : super(
            'bucketAuto',
            AEObject({
              'groupBy': groupBy,
              'buckets': buckets,
              if (output != null) 'output': AEObject(output),
              if (granularity != null) 'granularity': granularity
            }));
}

/// Granularity for [BucketAuto]
///
/// Granularity ensures that the boundaries of all buckets adhere to a specified
/// preferred number series. Using a preferred number series provides more
/// control on where the bucket boundaries are set among the range of values in
/// the `groupBy` expression. They may also be used to help logarithmically and
/// evenly set bucket boundaries when the range of the `groupBy` expression
/// scales exponentially.
///
/// ### Renard Series
///
/// The Renard number series are sets of numbers derived by taking either the
/// 5th, 10 th, 20 th, 40 th, or 80 th root of 10, then including various powers
/// of the root that equate to values between 1.0 to 10.0 (10.3 in the case of
/// R80).
///
/// Set granularity to R5, R10, R20, R40, or R80 to restrict bucket boundaries
/// to values in the series. The values of the series are multiplied by a power
/// of 10 when the groupBy values are outside of the 1.0 to 10.0 (10.3 for R80)
/// range.
///
/// Example:
///
/// The R5 series is based off of the fifth root of 10, which is 1.58, and
/// includes various powers of this root (rounded) until 10 is reached. The R5
/// series is derived as follows:
///
/// * 10 0/5 = 1
/// * 10 1/5 = 1.584 ~ 1.6
/// * 10 2/5 = 2.511 ~ 2.5
/// * 10 3/5 = 3.981 ~ 4.0
/// * 10 4/5 = 6.309 ~ 6.3
/// * 10 5/5 = 10
///
/// The same approach is applied to the other Renard series to offer finer
/// granularity, i.e., more intervals between 1.0 and 10.0 (10.3 for R80).
///
/// ### E Series
///
/// The E number series are similar to the Renard series in that they subdivide
/// the interval from 1.0 to 10.0 by the 6 th, 12 th, 24 th, 48 th, 96 th, or
/// 192 nd root of ten with a particular relative error.
///
/// Set granularity to E6, E12, E24, E48, E96, or E192 to restrict bucket
/// boundaries to values in the series. The values of the series are multiplied
/// by a power of 10 when the groupBy values are outside of the 1.0 to 10.0
/// range. To learn more about the E-series and their respective relative
/// errors, see preferred number series.
///
/// ### 1-2-5 Series
///
/// The 1-2-5 series behaves like a three-value Renard series, if such a series
/// existed.
///
/// Set granularity to 1-2-5 to restrict bucket boundaries to various powers of
/// the third root of 10, rounded to one significant digit.
///
/// Example:
///
/// The following values are part of the 1-2-5 series: 0.1, 0.2, 0.5, 1, 2, 5,
/// 10, 20, 50, 100, 200, 500, 1000, and so on…
///
/// ### Powers of Two Series
/// Set granularity to POWERSOF2 to restrict bucket boundaries to numbers that
/// are a power of two.
///
/// Example:
///
/// The following numbers adhere to the power of two Series:
///
/// * 2^0 = 1
/// * 2^1 = 2
/// * 2^2 = 4
/// * 2^3 = 8
/// * 2^4 = 16
/// * 2^5 = 32
/// * and so on…
///
/// A common implementation is how various computer components, like memory,
/// often adhere to the POWERSOF2 set of preferred numbers:
///
/// 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, and so on….
///
/// https://docs.mongodb.com/manual/reference/operator/aggregation/bucketAuto/#granularity
class Granularity extends Const {
  static final r5 = Granularity._('R5');
  static final r10 = Granularity._('R10');
  static final r20 = Granularity._('R20');
  static final r40 = Granularity._('R40');
  static final r80 = Granularity._('R80');
  static final g125 = Granularity._('1-2-5');
  static final e6 = Granularity._('E6');
  static final e12 = Granularity._('E12');
  static final e24 = Granularity._('E24');
  static final e48 = Granularity._('E48');
  static final e96 = Granularity._('E96');
  static final e192 = Granularity._('E192');
  static final powersof2 = Granularity._('POWERSOF2');

  Granularity._(String value) : super(value);
}

/// `$count` aggregation stage
///
/// ### Stage description
///
/// Passes a document to the next stage that contains a count of the number of
/// documents input to the stage.
///
/// https://docs.mongodb.com/manual/reference/operator/aggregation/count/
class Count extends AggregationStage {
  /// Creates `$count` aggregation stage
  ///
  /// [fieldName] - is the name of the output field which has the count as its
  /// value. [fieldName] must be a non-empty string and must not contain the `.`
  /// character.
  Count(String fieldName) : super('count', fieldName);
}

/// `$facet` aggregation stage
///
/// ### Stage description
///
/// Processes multiple aggregation pipelines within a single stage on the same
/// set of input documents. Each sub-pipeline has its own field in the output
/// document where its results are stored as an array of documents.
///
/// The `$facet` stage allows you to create multi-faceted aggregations which
/// characterize data across multiple dimensions, or facets, within a single
/// aggregation stage. Multi-faceted aggregations provide multiple filters and
/// categorizations to guide data browsing and analysis. Retailers commonly
/// use faceting to narrow search results by creating filters on product
/// price, manufacturer, size, etc.
///
/// Input documents are passed to the `$facet` stage only once. `$facet` enables
/// various aggregations on the same set of input documents, without needing
/// to retrieve the input documents multiple times.
///
/// Example:
///
/// Dart code:
/// ```
/// Facet({
///   'categorizedByTags': [
///     Unwind(Field('tags')),
///     SortByCount(Field('tags'))
///   ],
///   'categorizedByPrice': [
///     Match(where.exists('price').map['\$query']),
///     Bucket(
///       groupBy: Field('price'),
///       boundaries: [0, 150, 200, 300, 400],
///       defaultId: 'Other',
///       output: {
///         'count': Sum(1),
///         'titles': Push(Field('title'))
///       }
///     )
///   ],
///   'categorizedByYears(Auto)': [
///     BucketAuto(
///       groupBy: Field('year'),
///       buckets: 4
///     )
///   ]
/// }).build()
/// ```
/// Equivalent aggreagtion stage:
/// ```
/// {
///  $facet: {
///    "categorizedByTags": [
///      { $unwind: "$tags" },
///      { $sortByCount: "$tags" }
///    ],
///    "categorizedByPrice": [
///      { $match: { price: { $exists: true } } },
///      {
///        $bucket: {
///          groupBy: "$price",
///          boundaries: [  0, 150, 200, 300, 400 ],
///          default: "Other",
///          output: {
///            "count": { $sum: 1 },
///            "titles": { $push: "$title" }
///          }
///        }
///      }
///    ],
///    "categorizedByYears(Auto)": [
///      {
///        $bucketAuto: {
///          groupBy: "$year",
///          buckets: 4
///        }
///      }
///    ]
///  }
/// }
/// ```
/// https://docs.mongodb.com/manual/reference/operator/aggregation/facet/
class Facet extends AggregationStage {
  /// Creates `$facet` aggregation stage
  Facet(Map<String, List<AggregationStage>> pipelines)
      : super(
            'facet',
            AEObject(pipelines
                .map((field, stages) => MapEntry(field, AEList(stages)))));
}

/// `$replaceRoot` aggregation stage
///
/// ### Stage description
///
/// Replaces the input document with the specified document. The operation
/// replaces all existing fields in the input document, including the `_id`
/// field. You can promote an existing embedded document to the top level,
/// or create a new document for promotion.
///
/// Examples:
///
/// 1.
///
/// Dart code:
///
/// ```
/// ReplaceRoot(Field('name')).build()
/// ```
///
/// Equivalent mongoDB aggregation stage:
///
/// ```
/// { $replaceRoot: { newRoot: "$name" } }
/// ```
///
/// 2.
///
/// Dart code:
///
/// ```
/// ReplaceRoot(MergeObjects([
///   {
///     '_id': Field('_id'),
///     'first': '',
///     'last': ''
///   },
///   Field('name')
/// ])).build()
/// ```
///
/// Equivalent mongoDB aggregation stage:
///
/// ```
/// { $replaceRoot: {
///   newRoot: {
///     $mergeObjects: [ { _id: "$_id", first: "", last: "" }, "$name" ]
///   }
/// }}
/// ```
/// https://docs.mongodb.com/manual/reference/operator/aggregation/replaceRoot/
class ReplaceRoot extends AggregationStage {
  /// Creates `$replaceRoot` aggrregation stage
  ///
  /// The [replacement] document can be any valid expression that resolves to
  /// a document. The stage errors and fails if [replacement] is not
  /// a document.
  ReplaceRoot(replacement)
      : super('replaceRoot', AEObject({'newRoot': replacement}));
}

/// `$replaceWith` aggregation stage
///
/// ### Stage description
///
/// Available since MongoDB version 4.2
///
/// Replaces the input document with the specified document. The operation
/// replaces all existing fields in the input document, including the `_id`
/// field. With `$replaceWith`, you can promote an embedded document to the
/// top-level. You can also specify a new document as the replacement.
///
/// The `$replaceWith` is an alias for $replaceRoot.
///
/// Examples:
///
/// 1.
///
/// Dart code:
///
/// ```
/// ReplaceWith(Field('name')).build()
/// ```
///
/// Equivalent mongoDB aggregation stage:
///
/// ```
/// { $replaceWith: { newRoot: "$name" } }
/// ```
///
/// 2.
///
/// Dart code:
///
/// ```
/// ReplaceWith(MergeObjects([
///   {
///     '_id': Field('_id'),
///     'first': '',
///     'last': ''
///   },
///   Field('name')
/// ])).build()
/// ```
///
/// Equivalent mongoDB aggregation stage:
///
/// ```
/// { $replaceWith: {
///   newRoot: {
///     $mergeObjects: [ { _id: "$_id", first: "", last: "" }, "$name" ]
///   }
/// }}
/// ```
/// https://docs.mongodb.com/manual/reference/operator/aggregation/replaceWith/
class ReplaceWith extends AggregationStage {
  /// Creates `$replaceWith` aggregation stage
  ///
  /// The [replacement] document can be any valid expression that resolves to a
  /// document.
  ReplaceWith(replacement) : super('replaceWith', replacement);
}

/// `$group` aggregation stage
///
/// ### Stage description
///
/// Groups documents by some specified expression and outputs to the next
/// stage a document for each distinct grouping. The output documents contain
/// an `_id` field which contains the distinct group by key. The output
/// documents can also contain computed fields that hold the values of some
/// accumulator expression grouped by the `$group`’s `_id` field. `$group`
/// does not order its output documents.
///
/// Examples:
///
/// #### Group by Month, Day, and Year
///
/// The following aggregation operation uses the `$group` stage to group the
/// documents by the month, day, and year and calculates the total price and
/// the average quantity as well as counts the documents per each group:
///
/// Dart code:
/// ```
/// Group(
///   id: {
///     'month': Month(Field('date')),
///     'day': DayOfMonth(Field('date')),
///     'year': Year(Field('date'))
///   },
///   fields: {
///     'totalPrice': Sum(Multiply([Field('price'), Field('quantity')])),
///     'averageQuantity': Avg(Field('quantity')),
///     'count': Sum(1)
///   }
/// ).build()
/// ```
/// Equivalent mongoDB aggregation stage:
/// ```
/// {
///   $group : {
///     _id : {
///       month: { $month: { date: "$date" }},
///       day: { $dayOfMonth: { date: "$date" }},
///       year: { $year: { date: "$date" }}
///     },
///     totalPrice: { $sum: { $multiply: [ "$price", "$quantity" ] } },
///     averageQuantity: { $avg: "$quantity" },
///     count: { $sum: 1 }
///   }
/// }
/// ```
///
/// #### Group by null
///
/// The following aggregation operation specifies a group `_id` of `null`,
/// calculating the total price and the average quantity as well as counts
/// for all documents in the collection:
///
/// Dart code:
/// ```
/// Group(
///   id: BsonNull(),
///   fields: {
///     'totalPrice': Sum(Multiply([Field('price'), Field('quantity')])),
///     'averageQuantity': Avg(Field('quantity')),
///     'count': Sum(1)
///   }
/// ).build()
/// ```
/// Equivalent mongoDB aggregation stage:
/// ```
/// {
///   $group : {
///      _id : null,
///      totalPrice: { $sum: { $multiply: [ "$price", "$quantity" ] } },
///      averageQuantity: { $avg: "$quantity" },
///      count: { $sum: 1 }
///   }
/// }
/// ```
///
/// #### Retrieve Distinct Values
///
/// The following aggregation operation uses the `$group` stage to group the
/// documents by the item to retrieve the distinct item values:
///
/// Dart code:
/// ```
/// Group(id: Field('item')).build()
/// ```
/// Equivalent mongoDB aggregation stage:
/// ```
/// { $group : { _id : "$item" } }
/// ```
///
/// #### Group title by author
///
/// The following aggregation operation pivots the data in the books
/// collection to have titles grouped by authors.
///
/// Dart code:
/// ```
/// Group(
///   id: Field('author'),
///   fields: {'books': Push(Field('title'))}
/// ).build()
/// ```
/// Equivalent mongoDB aggregation stage:
/// ```
/// { $group : { _id : "$author", books: { $push: "$title" } } }
/// ```
///
/// #### Group Documents by author
///
/// The following aggregation operation uses the $$ROOT system variable to
/// group the documents by authors. The resulting documents must not exceed
/// the BSON Document Size limit.
///
/// Dart code:
/// ```
/// Group(id: Field('author'), fields: {'books': Push(Var.root)}).build()
/// ```
/// Equivalent mongoDB aggregation stage:
/// ```
/// { $group : { _id : "$author", books: { $push: "$$ROOT" } } }
/// ```
/// https://docs.mongodb.com/manual/reference/operator/aggregation/group/
class Group extends AggregationStage {
  /// Creates `$group` aggregation stage
  Group({required id, Map<String, Accumulator> fields = const {}})
      : super(
            'group',
            AEObject({'_id': id is Map<String, dynamic> ? AEObject(id) : id}
              ..addAll(fields)));
}

/// `$match` aggregation stage
///
/// ### Stage description
///
/// Filters the documents to pass only the documents that match the specified
/// condition(s) to the next pipeline stage.
///
/// Examples:
///
/// 1. Using [SelectorBuilder] query
///
/// Dart code:
/// ```
/// Match(where.eq('author', 'dave').map['\$query']).build()
/// ```
/// Equivalent mongoDB aggregation stage:
/// ```
/// {$match: {author: "dave"}}
/// ```
///
/// 2. Using aggregation expression:
///
/// Dart code:
/// ```
/// Match(Expr(Eq(Field('author'), 'dave'))).build()
/// ```
/// Equivalent mongoDB aggregation stage:
/// ```
/// {$match: {$expr: {$eq: ['$author', 'dave']}}}
/// ```
/// https://docs.mongodb.com/manual/reference/operator/aggregation/match/
class Match extends AggregationStage {
  /// Creates `$match` aggreagtion stage
  ///
  /// [query] can be either a [SelectorBuilder] query part
  /// (`selectorBuilder.map['\$query']`) or an aggregation expression wrapped
  /// in [Expr]
  Match(query) : super('match', query);
}

/// `$lookup` aggregation stage
///
/// ### Stage description
///
/// Performs a left outer join to an unsharded collection in the same database
/// to filter in documents from the “joined” collection for processing. To each
/// input document, the $lookup stage adds a new array field whose elements are
/// the matching documents from the “joined” collection. The $lookup stage
/// passes these reshaped documents to the next stage.
///
/// Examples:
///
/// 1. Single Equality Join
///
/// Dart code:
/// ```
/// Lookup(
///   from: 'inventory',
///   localField: 'item',
///   foreignField: 'sku',
///   as: 'inventory_docs'
/// ).build()
/// ```
/// Equivalent mongoDB aggregation stage:
/// ```
/// {
///   $lookup: {
///     from: "inventory",
///     localField: "item",
///     foreignField: "sku",
///     as: "inventory_docs"
///   }
/// }
/// ```
///
/// 2. Specify Multiple Join Conditions:
///
/// Dart code:
/// ```
/// Lookup.withPipeline(
///   from: 'warehouses',
///   let: {
///     'order_item': Field('item'),
///     'order_qty': Field('ordered')
///   },
///   pipeline: [
///     Match(Expr(And([
///       Eq(Field('stock_item'), Var('order_item')),
///       Gte(Field('instock'), Var('order_qty'))
///     ]))),
///     Project({
///       'stock_item': 0,
///       '_id': 0
///     })
///   ],
///   as: 'stockdata'
/// ).build()
/// ```
/// Equivalent mongoDB aggregation stage:
/// ```
/// {
///   $lookup: {
///     from: "warehouses",
///     let: { order_item: "$item", order_qty: "$ordered" },
///     pipeline: [
///       { $match:
///         { $expr:
///           { $and:
///             [
///               { $eq: [ "$stock_item",  "$$order_item" ] },
///               { $gte: [ "$instock", "$$order_qty" ] }
///             ]
///           }
///         }
///       },
///       { $project: { stock_item: 0, _id: 0 } }
///     ],
///     as: "stockdata"
///   }
/// }
/// ```
/// https://docs.mongodb.com/manual/reference/operator/aggregation/lookup/
class Lookup extends AggregationStage {
  /// Creates ordinary `$lookup` stage
  ///
  /// * [from] - Specifies the collection in the same database to perform the join
  /// with. The from collection cannot be sharded.
  /// * [localField] - Specifies the field from the documents input to the
  /// `$lookup` stage. `$lookup` performs an equality match on the [localField] to
  /// the [foreignField] from the documents of the from collection. If an input
  /// document does not contain the [localField], the `$lookup` treats the field as
  /// having a value of `null` for matching purposes.
  /// * [foreignField] - Specifies the field from the documents in the from
  /// collection. `$lookup` performs an equality match on the [foreignField] to
  /// the [localField] from the input documents. If a document in the from
  /// collection does not contain the [foreignField], the `$lookup` treats the
  /// value as `null` for matching purposes.
  /// * [as] - Specifies the name of the new array field to add to the input
  /// documents. The new array field contains the matching documents from the
  /// from collection. If the specified name already exists in the input
  /// document, the existing field is overwritten.
  Lookup(
      {required String from,
      required String localField,
      required String foreignField,
      required String as})
      : super(
            'lookup',
            AEObject({
              'from': from,
              'localField': localField,
              'foreignField': foreignField,
              'as': as
            }));

  /// Creates `$lookup` stage with it's own pipeline
  ///
  /// * [from] - Specifies the collection in the same database to perform the join
  /// with. The from collection cannot be sharded.
  /// * [let] - Optional. Specifies variables to use in the pipeline field
  /// stages. Use the variable expressions to access the fields from the
  /// documents input to the $lookup stage. The pipeline cannot directly access
  /// the input document fields. Instead, first define the variables for the
  /// input document fields, and then reference the variables in the stages in
  /// the pipeline. To access the let variables in the pipeline, use the
  /// `$expr` ([Expr]) operator.
  ///
  /// NOTE:
  ///
  /// The let variables are accessible by the stages in the pipeline, including
  /// additional `$lookup` stages nested in the pipeline.
  /// * [pipeline] - Specifies the pipeline to run on the joined collection.
  /// The pipeline determines the resulting documents from the joined
  /// collection. To return all documents, specify an empty pipeline `[]`.
  ///
  /// The pipeline cannot include the `$out` stage or the `$merge` stage.
  ///
  /// The pipeline cannot directly access the input document fields. Instead,
  /// first define the variables for the input document fields, and then
  /// reference the variables in the stages in the pipeline.
  /// * [as] - Specifies the name of the new array field to add to the input
  /// documents. The new array field contains the matching documents from the
  /// from collection. If the specified name already exists in the input
  /// document, the existing field is overwritten.
  Lookup.withPipeline(
      {required String from,
      required Map<String, dynamic> let,
      required List<AggregationStage> pipeline,
      required String as})
      : super(
            'lookup',
            AEObject({
              'from': from,
              'let': AEObject(let),
              'pipeline': AEList(pipeline),
              'as': as
            }));
}

/// `$graphLookup`
///
/// ### Stage description
/// Performs a recursive search on a collection, with options for restricting the search by recursion depth and query filter.
/// [see mongo db documentation](https://docs.mongodb.com/manual/reference/operator/aggregation/graphLookup/)
///
///
/// Dart code:
///
/// ```
///   GraphLookup(
///           from: "follows",
///           startWith: "user_id",
///           connectFromField: "my_follows",
///           connectToField: "followed",
///           as: "same_follows",
///           depthField: "depth",
///           maxDepth: 3,
///           restrictSearchWithMatch: where.ne("user_id", "user1"));
/// ```
///
/// Equivalent mongoDB aggregation stage:
///
/// ```
///   $graphLookup: {
///         from: "follows",
///         startWith: "$user_id",
///         connectFromField: "my_follows",
///         connectToField: "followed",
///         as: "same_follows",
///         depthField: "depth",
///         maxDepth : 3,
///         restrictSearchWithMatch: {
///            follower: {$ne: "user1"}
///         }
///      }
/// ```
///
///
class GraphLookup extends AggregationStage {
  GraphLookup(
      {required String from,
      required String startWith,
      required String connectFromField,
      required String connectToField,
      required String as,
      int? maxDepth,
      String? depthField,
      restrictSearchWithMatch})
      : super(
            'graphLookup',
            AEObject({
              'from': from,
              'startWith': '\$$startWith',
              'connectFromField': connectFromField,
              'connectToField': connectToField,
              'as': as,
              if (maxDepth != null) 'maxDepth': maxDepth,
              if (depthField != null) 'depthField': depthField,
              if (restrictSearchWithMatch != null)
                'restrictSearchWithMatch':
                    _getRestrictSearchWithMatch(restrictSearchWithMatch)
            }));

  static AEObject _getRestrictSearchWithMatch(restrictSearchWithMatch) {
    if (restrictSearchWithMatch is SelectorBuilder) {
      return AEObject(restrictSearchWithMatch.map['\$query']);
    } else if (restrictSearchWithMatch is Map<String, dynamic>) {
      return AEObject(restrictSearchWithMatch);
    } else {
      throw Exception(
          'restrictSearchWithMatch must be Map<String,dynamic> or SelectorBuilder');
    }
  }
}

/// `$unwind` aggregation stage
///
/// ### Stage description
///
/// Deconstructs an array field from the input documents to output a document
/// for each element. Each output document is the input document with the value
/// of the array field replaced by the element.
///
/// Examples:
///
/// 1.
///
/// Dart code:
/// ```
/// Unwind(Field('sizes')).build()
/// ```
/// Equivalent mongoDB aggregation stage:
/// ```
/// {$unwind : {path: "$sizes"}}
/// ```
/// https://docs.mongodb.com/manual/reference/operator/aggregation/unwind/
class Unwind extends AggregationStage {
  /// Creates `$unwind` aggregation stage
  ///
  /// * [field] - Field path to an array field.
  /// * [includeArrayIndex] - Optional. The name of a new field to hold the
  /// array index of the element.
  /// * [preserveNullAndEmptyArrays] - Optional. If `true`, if the path is
  /// `null`, missing, or an empty array, `$unwind` outputs the document. If
  /// `false`, `$unwind` does not output a document if the path is `null`,
  /// missing, or an empty array. The default value is `false`.
  Unwind(Field field,
      {String? includeArrayIndex, bool? preserveNullAndEmptyArrays})
      : super(
            'unwind',
            AEObject({
              'path': field,
              if (includeArrayIndex != null)
                'includeArrayIndex': includeArrayIndex,
              if (preserveNullAndEmptyArrays != null)
                'preserveNullAndEmptyArrays': preserveNullAndEmptyArrays
            }));
}

/// `$project` aggregation stage
///
/// ### Stage description
///
/// Passes along the documents with the requested fields to the next stage in
/// the pipeline. The specified fields can be existing fields from the input
/// documents or newly computed fields.
class Project extends AggregationStage {
  /// Creates `$project` aggreagtion stage
  ///
  /// [specification] have the following forms:
  ///
  /// * `<fieldname>`: `1` or `true` - Specifies the inclusion of a field.
  /// * `<fieldname>`: `0` or `false` - Specifies the exclusion of a field. To
  /// exclude a field conditionally, use the [Var].remove (`REMOVE`) variable
  /// instead. If you specify the exclusion of a field other than `_id`, you
  /// cannot employ any other `$project` specification forms. This restriction
  /// does not apply to conditionally exclusion of a field using the
  /// [Var].remove (`REMOVE`) variable. By default, the `_id` field is included
  /// in the output documents. If you do not need the `_id` field, you have
  /// to exclude it explicitly.
  /// * `<fieldname>`: `<expression>` - Adds a new field or resets the value of
  /// an existing field. If the the expression evaluates to [Var].remove
  /// (`$$REMOVE`), the field is excluded in the output.
  ///
  /// Example:
  ///
  /// Dart code:
  /// ```
  /// Project({
  ///   '_id': 0,
  ///   'title': 1,
  ///   'author': 1
  /// }).build()
  /// ```
  /// Equivalent mongoDB aggregation stage:
  /// ```
  /// { $project : { _id: 0, title : 1 , author : 1 } }
  /// ```
  /// https://docs.mongodb.com/manual/reference/operator/aggregation/project/
  Project(Map<String, dynamic> specification)
      : super('project', AEObject(specification));
}

/// `$skip` aggregation stage
///
/// ### Stage description
///
/// Skips over the specified number of documents that pass into the stage and
/// passes the remaining documents to the next stage in the pipeline.
///
/// https://docs.mongodb.com/manual/reference/operator/aggregation/skip/
class Skip extends AggregationStage {
  /// Creates `$skip` aggregation stage
  ///
  /// [count] - positive integer that specifies the maximum number of documents
  /// to skip.
  Skip(int count) : super('skip', count);
}

/// `$limit` aggregation stage
///
/// ### Stage description
///
/// Limits the number of documents passed to the next stage in the pipeline.
///
/// https://docs.mongodb.com/manual/reference/operator/aggregation/limit/
class Limit extends AggregationStage {
  /// Creates `$limit` aggregation stage
  ///
  /// [count] - a positive integer that specifies the maximum number of
  /// documents to pass along.
  Limit(int count) : super('limit', count);
}

/// `$sort` aggregation stage
///
/// ### Stage description
///
/// Sorts all input documents and returns them to the pipeline in sorted order.
///
/// Example:
///
/// Dart code:
/// ```
/// Sort({
///   'age': -1,
///   'posts': 1
/// }).build()
/// ```
/// Equivalent mongoDB aggregation stage:
/// ```
/// { $sort : { age : -1, posts: 1 } }
/// ```
/// https://docs.mongodb.com/manual/reference/operator/aggregation/sort/
class Sort extends AggregationStage {
  /// Creates `$sort` aggregation stage
  ///
  /// [specification] - a document that specifies the field(s) to sort by and
  /// the respective sort order. Sort order can have one of the following
  /// values:
  ///
  /// * 1 to specify ascending order.
  /// * -1 to specify descending order.
  Sort(Map<String, dynamic> specification)
      : super('sort', AEObject(specification));
}

/// `$sortByCount`
///
/// ### Stage description
///
/// Groups incoming documents based on the value of a specified expression,
/// then computes the count of documents in each distinct group.
///
/// Each output document contains two fields: an _id field containing the
/// distinct grouping value, and a count field containing the number of
/// documents belonging to that grouping or category.
///
/// The documents are sorted by count in descending order.
///
/// https://docs.mongodb.com/manual/reference/operator/aggregation/sortByCount/
class SortByCount extends AggregationStage {
  /// Creates `$sortByCount` aggregation stage
  ///
  /// [expression] - expression to group by. You can specify any expression
  /// except for a document literal.
  ///
  /// To specify a field path, use [Field]. For example:
  ///
  /// Dart code:
  /// ```
  /// SortByCount(Field('employee')).build()
  /// ```
  /// Equivalent mongoDB aggregation stage:
  /// ```
  /// { $sortByCount:  "$employee" }
  /// ```
  ///
  /// Although you cannot specify a document literal for the group by
  /// expression, you can, however, specify a field or an expression that
  /// evaluates to a document. For example, if employee and business fields are
  /// document fields, then the following is a valid argument to
  /// `$sortByCounts`:
  ///
  /// Dart code:
  /// ```
  /// SortByCount(MergeObjects([Field('employee'), Field('business')])).build()
  /// ```
  /// Equivalent mongoDB aggregation stage:
  /// ```
  /// { $sortByCount: { $mergeObjects: [ "$employee", "$business" ] } }
  /// ```
  SortByCount(expression) : super('sortByCount', expression);
}

/// `$geoNear`
///
/// ### Stage description
/// Outputs documents in order of nearest to farthest from a specified point.
/// [see mongo db documentation](https://docs.mongodb.com/manual/reference/operator/aggregation/geoNear/#std-label-pipeline-geoNear-key-param-example)
///
///
/// Dart code:
///
/// ```
/// GeoNear(
///   near: Geometry.point([-73.99279, 40.719296]),
///   distanceField: 'dist.calculated',
///   maxDistance: 2,
///   query: where.eq('category', 'Parks').map['\$query'],
///   includeLocs: 'dist.location',
///   spherical: true
///  ).build()
/// ```
///
/// Equivalent mongoDB aggregation stage:
/// ```
/// {
///    '$geoNear': {
///        'near': {
///           'type': 'Point',
///           'coordinates': [-73.99279, 40.719296]
///         },
///         'distanceField': 'dist.calculated',
///         'maxDistance': 2,
///         'query': {'category': 'Parks'},
///         'includeLocs': 'dist.location',
///         'spherical': true
///    }
/// }
/// ```
///
///
class GeoNear extends AggregationStage {
  GeoNear(
      {required Geometry near,
      required String distanceField,
      num? maxDistance,
      num? minDistance,
      bool? spherical,
      dynamic query,
      num? distanceMultiplier,
      String? includeLocs,
      String? key})
      : assert(near.type == GeometryObjectType.Point,
            '\$geoNear \'near\' field must be Point'),
        super(
            'geoNear',
            AEObject({
              'near': near.build()[r'$geometry'],
              'distanceField': distanceField,
              if (maxDistance != null) 'maxDistance': maxDistance,
              if (minDistance != null) 'minDistance': minDistance,
              if (spherical != null) 'spherical': spherical,
              if (query != null) 'query': _getQuery(query),
              if (distanceMultiplier != distanceMultiplier)
                'distanceMultiplier': distanceMultiplier,
              if (includeLocs != null) 'includeLocs': includeLocs,
              if (key != null) 'key': key
            }));

  static AEObject _getQuery(query) {
    if (query is SelectorBuilder) {
      return AEObject(query.map['\$query']);
    } else if (query is Map<String, dynamic>) {
      return AEObject(query);
    } else {
      throw Exception(
          'restrictSearchWithMatch must be Map<String,dynamic> or SelectorBuilder');
    }
  }
}

/// `$unionWith` aggregation stage
///
/// ### Stage description
///
/// New in version 4.4.
///
/// Performs a union of two collections. $unionWith combines pipeline results
/// from two collections into a single result set. The stage outputs the
///  combined result set (including duplicates) to the next stage.
///
/// The order in which the combined result set documents are output
/// is unspecified.
///
/// Examples:
///
/// Dart code:
/// ```
/// UnionWith(
///   coll: 'warehouses',
///   pipeline: [
///     Project({
///       'state': 1,
///       '_id': 0
///     })
///   ],
/// ).build()
/// ```
/// Equivalent mongoDB aggregation stage:
/// ```
/// {
///   $unionWith: {
///      coll: "warehouses",
///      pipeline: [
///        { $project:
///          { state: 1, _id: 0 }
///        }
///      ]
///   }
/// }
/// ```
/// https://www.mongodb.com/docs/manual/reference/operator/aggregation/unionWith/
class UnionWith extends AggregationStage {
  /// Creates `$UnionWith` stage with it's own pipeline
  ///
  /// * [coll] - The collection or view whose pipeline results you
  ///   wish to include in the result set.
  /// * [pipeline] - Optional. An aggregation pipeline to apply to the
  ///   specified coll.
  ///     [ <stage1>, <stage2>, ...]
  ///   The pipeline cannot include the $out and $merge stages.
  ///
  ///   The combined results from the previous stage and the $unionWith stage
  ///   can include duplicates.
  ///
  /// NOTE:
  ///
  /// The $unionWith operation would correspond to the following SQL statement:
  /// ```
  ///    SELECT *
  ///   FROM Collection1
  ///   WHERE ...
  ///   UNION ALL
  ///   SELECT *
  ///   FROM Collection2
  ///   WHERE ...
  /// ```
  /// The pipeline cannot directly access the input document fields. Instead,
  /// first define the variables for the input document fields, and then
  /// reference the variables in the stages in the pipeline.
  /// * [as] - Specifies the name of the new array field to add to the input
  /// documents. The new array field contains the matching documents from the
  /// from collection. If the specified name already exists in the input
  /// document, the existing field is overwritten.
  UnionWith({required String coll, List<AggregationStage>? pipeline})
      : super(
            'unionWith',
            AEObject({
              'coll': coll,
              if (pipeline != null) 'pipeline': AEList(pipeline),
            }));
}
