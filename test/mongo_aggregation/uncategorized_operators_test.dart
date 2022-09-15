import 'package:mongo_dart_query/mongo_aggregation.dart';
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
