import 'package:mongo_dart_query/src/expression/basic_expression.dart';
import 'package:mongo_dart_query/src/expression/common/operators_def.dart';
import 'package:mongo_dart_query/src/expression/field_expression.dart';
import 'package:test/test.dart';

void main() {
  group('Expression', () {
    test('Expression', () {
      var e = Expression(op$eq, ValueExpression.create(5));
      expect(e.raw, {r'$eq': 5});
    });
    test('Operator Expression', () {
      var e = Expression(op$eq, ValueExpression.create(null));
      expect(e.raw, {r'$eq': null});
      expect(e.key, op$eq);
    });

    test('Container Expression', () {
      var e = OperatorExpression(
          op$or,
          ListExpression([
            Expression(op$eq, ValueExpression.create(5)),
            OperatorExpression(op$eq, ValueExpression.create(null))
          ]));
      expect(e.raw, {
        r'$or': [
          {r'$eq': 5},
          {r'$eq': null}
        ]
      });
      expect(e.operator, op$or);
    });
    test('Field Expression', () {
      var e = FieldExpression(
          'field', OperatorExpression(op$eq, ValueExpression.create(null)));
      expect(e.raw, {
        'field': {r'$eq': null}
      });
      expect(e.fieldName, 'field');
    });
  });
  group('Set Expression', () {
    test('MapExpression', () {
      var e = MapExpression({r'$eq': 5});
      e.addExpression(OperatorExpression(r'$eq', ValueExpression.create(6)));
      e.addExpression(Expression(r'$gt', ValueExpression.create(9)));
      var me = MapExpression({r'$eq': 8});
      me.addExpression(Expression(r'$lt', ValueExpression.create(0)));
      e.addMapExpression(me);
      expect(e.rawContent, {r'$eq': 8, r'$gt': 9, r'$lt': 0});
    });
    test('Map', () {
      var e = MapExpression.empty();
      e.addMap({r'$eq': 5});
      e.addMap({r'$eq': 6});
      expect(e.rawContent, {r'$eq': 6});
    });
    test('Expression', () {
      var e = MapExpression({r'$eq': 5});
      e.addExpression(OperatorExpression(r'$eq', ValueExpression.create(6)));
      e.addExpression(Expression(r'$gt', ValueExpression.create(9)));
      expect(e.rawContent, {r'$eq': 6, r'$gt': 9});
    });
    test('Entry', () {
      var e = MapExpression({r'$eq': 5});
      e.addEntry(r'$eq', 6);
      expect(e.rawContent, {r'$eq': 6});
    });
    test('MapEntry', () {
      var e = MapExpression({r'$eq': 5});
      e.setMapEntry(MapEntry(r'$eq', 6));
      expect(e.rawContent, {r'$eq': 6});
    });
  });
  group('Merge Expression', () {
    test('set Map', () {
      var e = MapExpression({r'field': 5});
      var me = FieldExpression(
          'field', OperatorExpression(r'$eq', ValueExpression.create(8)));
      e.mergeExpression(me);
      expect(e.rawContent, {
        'field': {r'$eq': 8}
      });
    });
    test('Set Value', () {
      var e = MapExpression(FieldExpression(
              'field', OperatorExpression(r'$eq', ValueExpression.create(8)))
          .raw);
      var me = OperatorExpression('field', ValueExpression.create(5));
      e.mergeExpression(me);
      expect(e.rawContent, {'field': 5});
    });
    test('Merge Map Expression', () {
      var e = MapExpression(FieldExpression(
              'field', OperatorExpression(r'$eq', ValueExpression.create(8)))
          .raw);
      var me = FieldExpression(
          'field', OperatorExpression(r'$gt', ValueExpression.create(7)));

      e.mergeExpression(me);
      expect(e.rawContent, {
        'field': {r'$eq': 8, r'$gt': 7}
      });
    });
    test('Merge Map Expression 2', () {
      var e = MapExpression(FieldExpression(
              'field', OperatorExpression(r'$eq', ValueExpression.create(8)))
          .raw);
      e.mergeExpression(FieldExpression(
          'field', OperatorExpression(r'$eq', ValueExpression.create(2))));
      var me = FieldExpression(
          'field', OperatorExpression(r'$gt', ValueExpression.create(7)));
      e.mergeExpression(me);
      expect(e.rawContent, {
        'field': {r'$eq': 2, r'$gt': 7}
      });
    });
    test('merge Expression on Map', () {
      var e = MapExpression({
        'field': {r'$eq': 4, r'$gt': 7}
      });
      var me = FieldExpression(
          'field', OperatorExpression(r'$gt', ValueExpression.create(5)));
      e.mergeExpression(me);
      expect(e.rawContent, {
        'field': {r'$eq': 4, r'$gt': 5}
      });
    });
    test('merge Expression on MapExpression', () {
      var e = MapExpression.empty()
        ..addExpression(
            FieldExpression('field', MapExpression({r'$eq': 4, r'$gt': 7})));
      var me = FieldExpression(
          'field', OperatorExpression(r'$gt', ValueExpression.create(5)));
      e.mergeExpression(me);
      expect(e.rawContent, {
        'field': {r'$eq': 4, r'$gt': 5}
      });
    });
    test('merge Expression on Expression', () {
      var e = MapExpression.empty()
        ..addExpression(FieldExpression(
            'field', OperatorExpression(r'$eq', ValueExpression.create(4))));
      var me = FieldExpression(
          'field', OperatorExpression(r'$gt', ValueExpression.create(5)));
      e.mergeExpression(me);
      expect(e.rawContent, {
        'field': {r'$eq': 4, r'$gt': 5}
      });
    });
    test('merge Expression on MapEntry', () {
      var e = MapExpression.empty()
        ..addExpression(FieldExpression(
            'field', ValueExpression.create(MapEntry(r'$eq', 4))));
      var me = FieldExpression(
          'field', OperatorExpression(r'$gt', ValueExpression.create(5)));
      e.mergeExpression(me);
      expect(e.rawContent, {
        'field': {r'$eq': 4, r'$gt': 5}
      });
    });

    test('merge Map on Map', () {
      var e = MapExpression({
        'field': {r'$eq': 4, r'$gt': 7}
      });
      var me = {
        'field': {r'$gt': 5}
      };
      e.mergeDocument(me);
      expect(e.rawContent, {
        'field': {r'$eq': 4, r'$gt': 5}
      });
    });
    test('merge Map on MapExpression', () {
      var e = MapExpression.empty()
        ..addExpression(
            FieldExpression('field', MapExpression({r'$eq': 4, r'$gt': 7})));
      var me = {
        'field': {r'$gt': 5}
      };
      e.mergeDocument(me);
      expect(e.rawContent, {
        'field': {r'$eq': 4, r'$gt': 5}
      });
    });
    test('merge Map on Expression', () {
      var e = MapExpression.empty()
        ..addExpression(FieldExpression(
            'field', OperatorExpression(r'$eq', ValueExpression.create(4))));
      var me = {
        'field': {r'$gt': 5}
      };
      e.mergeDocument(me);
      expect(e.rawContent, {
        'field': {r'$eq': 4, r'$gt': 5}
      });
    });
    test('merge Map on MapEntry', () {
      var e = MapExpression.empty()
        ..addExpression(FieldExpression(
            'field', ValueExpression.create(MapEntry(r'$eq', 4))));
      var me = {
        'field': {r'$gt': 5}
      };
      e.mergeDocument(me);
      expect(e.rawContent, {
        'field': {r'$eq': 4, r'$gt': 5}
      });
    });
  });
}
