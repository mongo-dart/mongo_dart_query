import 'package:mongo_dart_query/mongo_aggregation.dart';
import 'package:test/test.dart';

void main() {
  test('and', () {
    expect(And([TestExpr(), false]).build(), {
      '\$and': ['\$field', false]
    });
  });

  test('or', () {
    expect(Or([TestExpr(), false]).build(), {
      '\$or': ['\$field', false]
    });
  });

  test('not', () {
    expect(Not(TestExpr()).build(), {'\$not': '\$field'});
  });
}

class TestExpr implements AggregationExpr {
  @override
  String build() => '\$field';
}
