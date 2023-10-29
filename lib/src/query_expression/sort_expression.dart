import '../expression/basic_expression.dart';
import '../expression/common/document_types.dart';

class SortExpression extends MapExpression {
  SortExpression() : super.empty();

  bool expressionProcessed = false;
  final _sequence = <MapExpression>[];

  bool get notEmpty => _sequence.isNotEmpty;
  IndexDocument get content => <String, Object>{...valueMap};

  @override
  IndexDocument get rawContent {
    if (!expressionProcessed) {
      processExpression();
    }
    return content;
  }

  @override
  String toString() => 'SortExpression($rawContent)';

  void processExpression() {
    expressionProcessed = true;
    valueMap.clear();
    for (var element in _sequence) {
      var insertMap = <String, Object>{...element.rawContent};
      valueMap.addAll(insertMap);
    }
  }

  /// Set a Map
  /// Clears the original content and add the new one
  @override
  void setMap(MongoDocument map) => valueMap = <String, Object>{...map};

  /// Add a Map
  /// Add a map content to the actual content.
  /// If any key alreay exists, it is substituted
  @override
  void addMap(MongoDocument map) => valueMap.addAll(map as IndexDocument);

  /// Add a key-value pair
  /// If the key already exists, the value is substituted
  @override
  void addEntry(String key, value) => valueMap[key] = value as Object;

  /// adds a {$meta : testScore} for field text search
  void add$meta(String fieldName) => _sequence.add(MapExpression({
        fieldName: {r'$meta': 'textScore'}
      }));
  void addField(String fieldName, {bool descending = false}) =>
      _sequence.add(MapExpression({fieldName: descending ? -1 : 1}));
}
