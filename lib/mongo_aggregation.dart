/// Mongodb aggregation library
///
/// Simplifies to create aggregation pipelines using Dart code.
///
/// Basic usage:
/// ```
/// final db = Db('mongodb://127.0.0.1/testdb');
/// final pipeline = AggregationPipelineBuilder()
///   .addStage(
///     Match(where.eq('status', 'A').map['\$query']))
///   .addStage(
///     Group(
///       id: Field('cust_id'),
///       fields: {
///         'total': Sum(Field('amount'))
///       }
///     )).build();
/// final result =
///   await DbCollection(db, 'orders')
///     .aggregateToStream(pipeline).toList();
/// ```
/// Full mongoDB documentation on aggregation queries:
/// https://docs.mongodb.com/manual/aggregation/
library mongo_aggregation;

export 'src/mongo_aggregation/aggregation_base.dart';
export 'src/mongo_aggregation/aggregation_pipeline_builder.dart';
export 'src/mongo_aggregation/aggregation_stages.dart';
export 'src/mongo_aggregation/arithmetic_operators.dart';
export 'src/mongo_aggregation/array_object_operators.dart';
export 'src/mongo_aggregation/comparison_operators.dart';
export 'src/mongo_aggregation/date_time_operators.dart';
export 'src/mongo_aggregation/group_stage_accumulators.dart';
export 'src/mongo_aggregation/logic_operators.dart';
export 'src/mongo_aggregation/string_operators.dart';
export 'src/mongo_aggregation/type_expression_operators.dart';
export 'src/mongo_aggregation/uncategorized_operators.dart';
