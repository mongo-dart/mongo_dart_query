import 'package:mongo_dart_query/mongo_aggregation.dart';
import 'package:test/test.dart';

void main() {
  test('addToSet', () {
    expect(AddToSet(TestExpr()).build(), {'\$addToSet': '\$field'});
  });

  test('avg', () {
    expect(Avg(TestExpr()).build(), {'\$avg': '\$field'});
    expect(Avg([TestExpr(), 2]).build(), {
      '\$avg': ['\$field', 2]
    });
  });

  test('first', () {
    expect(First(TestExpr()).build(), {'\$first': '\$field'});
  });

  test('last', () {
    expect(Last(TestExpr()).build(), {'\$last': '\$field'});
  });

  test('max', () {
    expect(Max(TestExpr()).build(), {'\$max': '\$field'});
    expect(Max([TestExpr(), 2]).build(), {
      '\$max': ['\$field', 2]
    });
  });

  test('min', () {
    expect(Min(TestExpr()).build(), {'\$min': '\$field'});
    expect(Min([TestExpr(), 2]).build(), {
      '\$min': ['\$field', 2]
    });
  });

  test('push', () {
    expect(Push(TestExpr()).build(), {'\$push': '\$field'});
    expect(Push.list([TestExpr(), 1]).build(), {
      '\$push': ['\$field', 1]
    });
    expect(Push.object({'field': TestExpr(), 'num': 1}).build(), {
      '\$push': {'field': '\$field', 'num': 1}
    });
  });

  test('stdDevPop', () {
    expect(StdDevPop(TestExpr()).build(), {'\$stdDevPop': '\$field'});
    expect(StdDevPop([TestExpr(), 2]).build(), {
      '\$stdDevPop': ['\$field', 2]
    });
  });

  test('stdDevSamp', () {
    expect(StdDevSamp(TestExpr()).build(), {'\$stdDevSamp': '\$field'});
    expect(StdDevSamp([TestExpr(), 2]).build(), {
      '\$stdDevSamp': ['\$field', 2]
    });
  });

  test('sum', () {
    expect(Sum(TestExpr()).build(), {'\$sum': '\$field'});
    expect(Sum([TestExpr(), 2]).build(), {
      '\$sum': ['\$field', 2]
    });
  });
}

class TestExpr implements AggregationExpr {
  @override
  String build() => '\$field';
}
