import 'package:mongo_dart_query/mongo_aggregation.dart';
import 'package:test/test.dart';

void main() {
  test('concat', () {
    expect(Concat([TestExpr(), 'string']).build(), {
      '\$concat': ['\$field', 'string']
    });
  });

  test('indexOfBytes', () {
    expect(IndexOfBytes(TestExpr(), 'substr', 1, 10).build(), {
      '\$indexOfBytes': ['\$field', 'substr', 1, 10]
    });
  });

  test('indexOfCP', () {
    expect(IndexOfCP(TestExpr(), 'substr', 1, 10).build(), {
      '\$indexOfCP': ['\$field', 'substr', 1, 10]
    });
  });

  test('ltrim', () {
    expect(Ltrim(input: TestExpr(), chars: '*').build(), {
      '\$ltrim': {'input': '\$field', 'chars': '*'}
    });
  });

  test('regexFind', () {
    expect(
        RegexFind(input: TestExpr(), regex: 'regex', options: 'is').build(), {
      '\$regexFind': {'input': '\$field', 'regex': 'regex', 'options': 'is'}
    });
  });

  test('regexFindAll', () {
    expect(
        RegexFindAll(input: TestExpr(), regex: 'regex', options: 'is').build(),
        {
          '\$regexFindAll': {
            'input': '\$field',
            'regex': 'regex',
            'options': 'is'
          }
        });
  });

  test('regexMatch', () {
    expect(
        RegexMatch(input: TestExpr(), regex: 'regex', options: 'is').build(), {
      '\$regexMatch': {'input': '\$field', 'regex': 'regex', 'options': 'is'}
    });
  });

  test('rtrim', () {
    expect(Rtrim(input: TestExpr(), chars: '*').build(), {
      '\$rtrim': {'input': '\$field', 'chars': '*'}
    });
  });

  test('split', () {
    expect(Split(TestExpr(), ',').build(), {
      '\$split': ['\$field', ',']
    });
  });

  test('strLenBytes', () {
    expect(StrLenBytes(TestExpr()).build(), {'\$strLenBytes': '\$field'});
  });

  test('strLenCP', () {
    expect(StrLenCP(TestExpr()).build(), {'\$strLenCP': '\$field'});
  });

  test('strcasecmp', () {
    expect(StrCaseCmp(TestExpr(), TestExpr()).build(), {
      '\$strcasecmp': ['\$field', '\$field']
    });
  });

  test('substrBytes', () {
    expect(SubstrBytes(TestExpr(), 5, 3).build(), {
      '\$substrBytes': ['\$field', 5, 3]
    });
  });

  test('substrCP', () {
    expect(SubstrCP(TestExpr(), 5, 3).build(), {
      '\$substrCP': ['\$field', 5, 3]
    });
  });

  test('toLower', () {
    expect(ToLower(TestExpr()).build(), {'\$toLower': '\$field'});
  });

  test('toString', () {
    expect(ToString(TestExpr()).build(), {'\$toString': '\$field'});
  });

  test('trim', () {
    expect(Trim(input: TestExpr(), chars: '*').build(), {
      '\$trim': {'input': '\$field', 'chars': '*'}
    });
  });

  test('toUpper', () {
    expect(ToUpper(TestExpr()).build(), {'\$toUpper': '\$field'});
  });
}

class TestExpr implements AggregationExpr {
  @override
  String build() => '\$field';
}
