import 'package:mongo_dart_query/src/common/operators_def.dart';
import 'package:mongo_dart_query/src/expression/basic_expression.dart';
import 'package:mongo_dart_query/src/expression/field_expression.dart';
import 'package:test/test.dart';

void main() {
  group('Expression Content', () {
    test('Simple Value Expression', () {
      var e = ValueExpression(5);
      expect(e.raw, 5);
    });
    test('List Value Expression', () {
      var e = ValueExpression(['A', 'B', 'C']);
      expect(e.raw, ['A', 'B', 'C']);
      e = ValueExpression(ListExpression(['A', ValueExpression('B'), 'C']));
      expect(e.raw, ['A', 'B', 'C']);
    });
    test('Set Value Expression', () {
      var e = ValueExpression({'A', 'B', 'C'});
      expect(e.raw, {'A', 'B', 'C'});
      e = ValueExpression(SetExpression({'A', 'B', 'C'}));
      expect(e.raw, {'A', 'B', 'C'});
      e = ValueExpression(SetExpression({'A', ValueExpression('B'), 'C'}));
      expect(e.raw, {'A', 'B', 'C'});
    });
    test('Map Value Expression', () {
      var e = ValueExpression({
        'a': 1,
        'b': ['a', 'b', 'c'],
        'c': {'key': 'value'}
      });
      expect(e.raw, {
        'a': 1,
        'b': ['a', 'b', 'c'],
        'c': {'key': 'value'}
      });
      e = ValueExpression(MapExpression({
        'a': 1,
        'b': ['a', 'b', 'c'],
        'c': {'key': 'value'}
      }));
      expect(e.raw, {
        'a': 1,
        'b': ['a', 'b', 'c'],
        'c': {'key': 'value'}
      });
      e = ValueExpression(MapExpression({
        'a': 1,
        'b': ListExpression(['a', 'b', 'c']),
        'c': MapExpression({'key': 'value'}),
        'd': SetExpression({1, 2})
      }));
      expect(e.raw, {
        'a': 1,
        'b': ['a', 'b', 'c'],
        'c': {'key': 'value'},
        'd': {1, 2}
      });
    });
  });
  group('Expression', () {
    test('Expression', () {
      var e = Expression(op$Eq, 5);
      expect(e.raw, {r'$eq': 5});
    });
    test('Operator Expression', () {
      var e = Expression(op$Eq, null);
      expect(e.raw, {r'$eq': null});
      expect(e.key, op$Eq);
    });

    test('Container Expression', () {
      var e = OperatorExpression(
          op$Or,
          ListExpression(
              [Expression(op$Eq, 5), OperatorExpression(op$Eq, null)]));
      expect(e.raw, {
        r'$or': [
          {r'$eq': 5},
          {r'$eq': null}
        ]
      });
      expect(e.operator, op$Or);
    });
    test('Field Expression', () {
      var e = FieldExpression('field', OperatorExpression(op$Eq, null));
      expect(e.raw, {
        'field': {r'$eq': null}
      });
      expect(e.fieldName, 'field');
    });
  });
}
