import 'package:mongo_dart_query/mongo_aggregation.dart';
import 'package:test/test.dart';

void main() {
  test('arrayToObjects', () {
    expect(ArrayToObject(Field('products')).build(),
        {'\$arrayToObject': '\$products'});
    expect(
        ArrayToObject([
          ['item', 'abc123'],
          ['qty', 25]
        ]).build(),
        {
          '\$arrayToObject': [
            ['item', 'abc123'],
            ['qty', 25]
          ]
        });
    expect(
        ArrayToObject([
          {'k': 'item', 'v': 'abc123'},
          {'k': 'qty', 'v': 25}
        ]).build(),
        {
          '\$arrayToObject': [
            {'k': 'item', 'v': 'abc123'},
            {'k': 'qty', 'v': 25}
          ]
        });
  });

  test('arrayElemAt', () {
    expect(ArrayElemAt(TestExpr(), 0).build(), {
      '\$arrayElemAt': ['\$field', 0]
    });
    expect(ArrayElemAt([1, 2, 3], 1).build(), {
      '\$arrayElemAt': [
        [1, 2, 3],
        1
      ]
    });
  });

  test('concatArrays', () {
    expect(
        ConcatArrays([
          TestExpr(),
          [1, 2]
        ]).build(),
        {
          '\$concatArrays': [
            '\$field',
            [1, 2]
          ]
        });
  });

  test('filter', () {
    expect(Filter(input: TestExpr(), as: 'test', cond: TestExpr()).build(), {
      '\$filter': {'input': '\$field', 'as': 'test', 'cond': '\$field'}
    });
  });

  test('in', () {
    expect(In(TestExpr(), TestExpr()).build(), {
      '\$in': ['\$field', '\$field']
    });
    expect(In('string', ['string', TestExpr()]).build(), {
      '\$in': [
        'string',
        ['string', '\$field']
      ]
    });
  });

  test('indexOfArray', () {
    expect(IndexOfArray(TestExpr(), TestExpr(), 2, 3).build(), {
      '\$indexOfArray': ['\$field', '\$field', 2, 3]
    });
    expect(IndexOfArray([1, 2, TestExpr()], 'value', 2, 3).build(), {
      '\$indexOfArray': [
        [1, 2, '\$field'],
        'value',
        2,
        3
      ]
    });
  });

  test('isArray', () {
    expect(IsArray(TestExpr()).build(), {'\$isArray': '\$field'});
  });

  test('map', () {
    expect(MapOp(input: TestExpr(), as: 'val', inExpr: TestExpr()).build(), {
      '\$map': {'input': '\$field', 'as': 'val', 'in': '\$field'}
    });
  });

  test('range', () {
    expect(Range(1, TestExpr(), 2).build(), {
      '\$range': [1, '\$field', 2]
    });
  });

  test('reduce', () {
    expect(
        Reduce(input: TestExpr(), initialValue: 0, inExpr: TestExpr()).build(),
        {
          '\$reduce': {'input': '\$field', 'initialValue': 0, 'in': '\$field'}
        });
  });

  test('reverseArray', () {
    expect(ReverseArray(TestExpr()).build(), {'\$reverseArray': '\$field'});
    expect(ReverseArray([1, 2, TestExpr()]).build(), {
      '\$reverseArray': [1, 2, '\$field']
    });
  });

  test('slice', () {
    expect(Slice(TestExpr(), 5, 2).build(), {
      '\$slice': ['\$field', 2, 5]
    });
    expect(Slice([1, TestExpr()], 5, 2).build(), {
      '\$slice': [
        [1, '\$field'],
        2,
        5
      ]
    });
  });

  test('zip', () {
    expect(
        Zip(
            inputs: [
              TestExpr(),
              [1, 2]
            ],
            useLongestLength: true,
            defaults: ['a', 'b']).build(),
        {
          '\$zip': {
            'inputs': [
              '\$field',
              [1, 2]
            ],
            'useLongestLength': true,
            'defaults': ['a', 'b']
          }
        });
  });

  test('mergeObjects', () {
    expect(MergeObjects(TestExpr()).build(), {'\$mergeObjects': '\$field'});
    expect(
        MergeObjects([
          TestExpr(),
          {'a': TestExpr(), 'b': 2}
        ]).build(),
        {
          '\$mergeObjects': [
            '\$field',
            {'a': '\$field', 'b': 2}
          ]
        });
  });

  test('objectToArray', () {
    expect(
        ObjectToArray(Field('order')).build(), {'\$objectToArray': '\$order'});
  });
}

class TestExpr implements AggregationExpr {
  @override
  String build() => '\$field';
}
