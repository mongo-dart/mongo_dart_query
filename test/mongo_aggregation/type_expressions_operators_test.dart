import 'package:mongo_dart_query/mongo_aggregation.dart';
import 'package:test/test.dart';

void main() {
  test('convert', () {
    expect(
        Convert(
                input: TestExpr(),
                to: 'string',
                onError: TestExpr(),
                onNull: TestExpr())
            .build(),
        {
          '\$convert': {
            'input': '\$field',
            'to': 'string',
            'onError': '\$field',
            'onNull': '\$field'
          }
        });
  });

  test('toBool', () {
    expect(ToBool(TestExpr()).build(), {'\$toBool': '\$field'});
  });

  test('toDecimal', () {
    expect(ToDecimal(TestExpr()).build(), {'\$toDecimal': '\$field'});
  });

  test('toDouble', () {
    expect(ToDouble(TestExpr()).build(), {'\$toDouble': '\$field'});
  });

  test('toInt', () {
    expect(ToInt(TestExpr()).build(), {'\$toInt': '\$field'});
  });

  test('toLong', () {
    expect(ToLong(TestExpr()).build(), {'\$toLong': '\$field'});
  });

  test('toObjectId', () {
    expect(ToObjectId(TestExpr()).build(), {'\$toObjectId': '\$field'});
  });

  test('type', () {
    expect(Type(TestExpr()).build(), {'\$type': '\$field'});
  });
}

class TestExpr implements AggregationExpr {
  @override
  String build() => '\$field';
}
