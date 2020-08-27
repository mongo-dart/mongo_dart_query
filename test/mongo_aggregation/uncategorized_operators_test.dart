import 'package:mongo_dart_query/src/mongo_aggregation/aggregation_base.dart';
import 'package:mongo_dart_query/src/mongo_aggregation/uncategorized_operators.dart';
import 'package:test/test.dart';

void main() {
  test('expr', () {
    expect(Expr(TestExpr()).build(), {'\$expr': '\$field'});
  });

  test('let', () {
    expect(Let(vars: {'var': TestExpr()}, inExpr: TestExpr()).build(), {
      '\$let': {
        'vars': {'var': '\$field'},
        'in': '\$field'
      }
    });
  });
}

class TestExpr implements AggregationExpr {
  @override
  String build() => '\$field';
}
