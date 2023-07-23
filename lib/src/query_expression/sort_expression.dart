import '../expression/basic_expression.dart';
import '../expression/common/document_types.dart';

class SortExpression extends MapExpression {
  SortExpression() : super.empty();

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
  String toString() => 'SortExpression($rawContent)';

  void processExpression() {
    expressionProcessed = true;
    content.clear();
    for (var element in _sequence) {
      content.addAll(element.rawContent);
    }
  }

  /// adds a {$meta : testScore} for field text search
  void add$meta(String fieldName) => _sequence.add(MapExpression({
        fieldName: {r'$meta': 'textScore'}
      }));
  void addField(String fieldName, {bool descending = false}) =>
      _sequence.add(MapExpression({fieldName: descending ? -1 : 1}));
}
