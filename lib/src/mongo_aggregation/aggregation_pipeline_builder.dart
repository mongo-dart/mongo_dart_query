import 'package:meta/meta.dart';

import 'aggregation_base.dart';

/// Aggregation pipeline builder
class AggregationPipelineBuilder implements Builder {
  @protected
  final stages = <AggregationStage>[];

  /// Adds stage to the pipeline
  AggregationPipelineBuilder addStage(AggregationStage stage) {
    stages.add(stage);
    return this;
  }

  /// Builds pipeline
  ///
  /// Returns aggregation pipeline in format suitable for mongodb aggregate
  /// query
  List<Map<String, dynamic>> build() =>
      stages.map((stage) => stage.build()).toList();
}
