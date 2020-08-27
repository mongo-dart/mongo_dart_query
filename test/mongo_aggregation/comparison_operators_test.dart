import 'package:mongo_dart_query/src/mongo_aggregation/aggregation_base.dart';
import 'package:mongo_dart_query/src/mongo_aggregation/comparison_operators.dart';
import 'package:test/test.dart';

void main() {
  test('cmp', () {
    expect(Cmp(TestExpr(), 5).build(), {
      '\$cmp': ['\$field', 5]
    });
  });

  test('eq', () {
    expect(Eq(TestExpr(), 5).build(), {
      '\$eq': ['\$field', 5]
    });
  });

  test('gt', () {
    expect(Gt(TestExpr(), 5).build(), {
      '\$gt': ['\$field', 5]
    });
  });

  test('gte', () {
    expect(Gte(TestExpr(), 5).build(), {
      '\$gte': ['\$field', 5]
    });
  });

  test('lt', () {
    expect(Lt(TestExpr(), 5).build(), {
      '\$lt': ['\$field', 5]
    });
  });

  test('lte', () {
    expect(Lte(TestExpr(), 5).build(), {
      '\$lte': ['\$field', 5]
    });
  });

  test('ne', () {
    expect(Ne(TestExpr(), 5).build(), {
      '\$ne': ['\$field', 5]
    });
  });

  test('cond', () {
    expect(
        Cond(ifExpr: TestExpr(), thenExpr: TestExpr(), elseExpr: TestExpr())
            .build(),
        {
          '\$cond': ['\$field', '\$field', '\$field']
        });
  });

  test('ifNull', () {
    expect(IfNull(TestExpr(), 'replacement').build(), {
      '\$ifNull': ['\$field', 'replacement']
    });
  });

  test('switch', () {
    expect(
        Switch(
                branches: [Case(caseExpr: TestExpr(), thenExpr: 'expr')],
                defaultExpr: 'default')
            .build(),
        {
          '\$switch': {
            'branches': [
              {'case': '\$field', 'then': 'expr'}
            ],
            'default': 'default'
          }
        });
  });
}

class TestExpr implements AggregationExpr {
  @override
  String build() => '\$field';
}
