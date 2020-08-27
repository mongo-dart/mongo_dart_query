import 'package:mongo_dart_query/src/mongo_aggregation/aggregation_base.dart';
import 'package:mongo_dart_query/src/mongo_aggregation/logic_operators.dart';
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
