import 'package:mongo_dart_query/src/mongo_aggregation/aggregation_base.dart';
import 'package:mongo_dart_query/src/mongo_aggregation/arithmetic_operators.dart';
import 'package:test/test.dart';

main() {
  test('abs', () {
    expect(Abs(TestExpr()).build(), {'\$abs': '\$field'});
  });

  test('add', () {
    expect(Add([TestExpr(), 1]).build(), {
      '\$add': ['\$field', 1]
    });
  });

  test('ceil', () {
    expect(Ceil(TestExpr()).build(), {'\$ceil': '\$field'});
  });

  test('divide', () {
    expect(Divide(TestExpr(), 2).build(), {
      '\$divide': ['\$field', 2]
    });
  });

  test('exp', () {
    expect(Exp(TestExpr()).build(), {'\$exp': '\$field'});
  });

  test('floor', () {
    expect(Floor(TestExpr()).build(), {'\$floor': '\$field'});
  });

  test('ln', () {
    expect(Ln(TestExpr()).build(), {'\$ln': '\$field'});
  });

  test('log', () {
    expect(Log(TestExpr(), 2).build(), {
      '\$log': ['\$field', 2]
    });
  });

  test('log10', () {
    expect(Log10(TestExpr()).build(), {'\$log10': '\$field'});
  });

  test('mod', () {
    expect(Mod(TestExpr(), 2).build(), {
      '\$mod': ['\$field', 2]
    });
  });

  test('multiply', () {
    expect(Multiply([TestExpr(), 3]).build(), {
      '\$multiply': ['\$field', 3]
    });
  });

  test('pow', () {
    expect(Pow(TestExpr(), 3).build(), {
      '\$pow': ['\$field', 3]
    });
  });

  test('round', () {
    expect(Round(TestExpr(), 3).build(), {
      '\$round': ['\$field', 3]
    });
  });

  test('sqrt', () {
    expect(Sqrt(TestExpr()).build(), {'\$sqrt': '\$field'});
  });

  test('subtract', () {
    expect(Subtract(TestExpr(), 3).build(), {
      '\$subtract': ['\$field', 3]
    });
  });

  test('trunc', () {
    expect(Trunc(TestExpr(), 3).build(), {
      '\$trunc': ['\$field', 3]
    });
  });
}

class TestExpr implements AggregationExpr {
  @override
  String build() => '\$field';
}
