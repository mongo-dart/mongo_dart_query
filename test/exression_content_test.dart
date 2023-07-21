import 'package:mongo_dart_query/src/expression/basic_expression.dart';
import 'package:mongo_dart_query/src/expression/field_expression.dart';
import 'package:test/test.dart';

void main() {
  group('Value Expression', () {
    test('Simple Value Expression', () {
      var e = ValueExpression.create(5);
      expect(e.rawContent, 5);
    });
    test('List Value Expression', () {
      var e = ValueExpression.create(['A', 'B', 'C']);
      expect(e.rawContent, ['A', 'B', 'C']);
      expect(e is ListExpression, isTrue);
      e = ValueExpression.create(
          ListExpression(['A', ValueExpression.create('B'), 'C']));
      expect(e.rawContent, ['A', 'B', 'C']);
    });
    test('Set Value Expression', () {
      var e = ValueExpression.create({'A', 'B', 'C'});
      expect(e.rawContent, {'A', 'B', 'C'});
      expect(e is SetExpression, isTrue);
      e = ValueExpression.create(SetExpression({'A', 'B', 'C'}));
      expect(e.rawContent, {'A', 'B', 'C'});
      e = ValueExpression.create(
          SetExpression({'A', ValueExpression.create('B'), 'C'}));
      expect(e.rawContent, {'A', 'B', 'C'});
    });
    test('MongoDocument Value Expression', () {
      var e = ValueExpression.create({
        'a': 1,
        'b': ['a', 'b', 'c'],
        'c': {'key': 'value'}
      });
      expect(e.rawContent, {
        'a': 1,
        'b': ['a', 'b', 'c'],
        'c': {'key': 'value'}
      });
      expect(e is MapExpression, isTrue);
      e = ValueExpression.create(MapExpression({
        'a': 1,
        'b': ['a', 'b', 'c'],
        'c': {'key': 'value'}
      }));
      expect(e.rawContent, {
        'a': 1,
        'b': ['a', 'b', 'c'],
        'c': {'key': 'value'}
      });
      e = ValueExpression.create(MapExpression({
        'a': 1,
        'b': ListExpression(['a', 'b', 'c']),
        'c': MapExpression({'key': 'value'}),
        'd': SetExpression({1, 2})
      }));
      expect(e.rawContent, {
        'a': 1,
        'b': ['a', 'b', 'c'],
        'c': {'key': 'value'},
        'd': {1, 2}
      });
    });
    test('Map Value Expression', () {
      var e = ValueExpression.create({
        'a': 1,
        4: ['a', 'b', 'c'],
        null: {'key': 'value'}
      });
      expect(e.rawContent, {
        'a': 1,
        4: ['a', 'b', 'c'],
        null: {'key': 'value'}
      });
      expect(e is ValueExpression, isTrue);
    });
  });

  group('MapExpression', () {
    var opTestMap = {r'$gt': 7};
    var opTestMap2 = {r'$gt': 2};
    var opTestMap3 = {r'$eq': 3};
    var fieldTestMap = {'test': opTestMap};
    var fieldTestMap2 = {'test': opTestMap2};
    var fieldTestMap3 = {'test': opTestMap3};
    var fieldAltMap = {'alt': opTestMap};
    test('Map Expression from Value Expression', () {
      var e = ValueExpression.create({
        'a': 1,
        'b': ['a', 'b', 'c'],
        'c': {'key': 'value'}
      });
      expect(e.rawContent, {
        'a': 1,
        'b': ['a', 'b', 'c'],
        'c': {'key': 'value'}
      });
      expect(e is MapExpression, isTrue);
      e = ValueExpression.create(MapExpression({
        'a': 1,
        'b': ['a', 'b', 'c'],
        'c': {'key': 'value'}
      }));
      expect(e.rawContent, {
        'a': 1,
        'b': ['a', 'b', 'c'],
        'c': {'key': 'value'}
      });
      e = ValueExpression.create(MapExpression({
        'a': 1,
        'b': ListExpression(['a', 'b', 'c']),
        'c': MapExpression({'key': 'value'}),
        'd': SetExpression({1, 2})
      }));
      expect(e.rawContent, {
        'a': 1,
        'b': ['a', 'b', 'c'],
        'c': {'key': 'value'},
        'd': {1, 2}
      });
    });

    group('Set', () {
      test('setMap', () {
        var mp = MapExpression(fieldAltMap);
        mp.setMap(fieldTestMap);
        expect(mp.rawContent, fieldTestMap);
      });
      test('setMapExpression', () {
        var mp = MapExpression(fieldAltMap);
        mp.setMapExpression(MapExpression(fieldTestMap));
        expect(mp.rawContent, fieldTestMap);
      });
      test('setEntry', () {
        var mp = MapExpression(fieldAltMap);
        MapEntry entry = fieldTestMap.entries.first;
        mp.setEntry(entry.key, entry.value);
        expect(mp.rawContent, fieldTestMap);
      });
      test('setMapEntry', () {
        var mp = MapExpression(fieldAltMap);
        mp.setMapEntry(fieldTestMap.entries.first);
        expect(mp.rawContent, fieldTestMap);
      });
      test('setExpression', () {
        var mp = MapExpression(fieldAltMap);
        MapEntry entry = fieldTestMap.entries.first;
        Expression exp =
            Expression(entry.key, ValueExpression.create(entry.value));
        mp.setExpression(exp);
        expect(mp.rawContent, fieldTestMap);
      });
    });
    group('Add', () {
      test('addMap', () {
        var mp = MapExpression(fieldAltMap);
        mp.addMap(fieldTestMap);
        expect(mp.rawContent, {...fieldAltMap, ...fieldTestMap});
      });
      test('addMapExpression', () {
        var mp = MapExpression(fieldAltMap);
        mp.addMapExpression(MapExpression(fieldTestMap));
        expect(mp.rawContent, {...fieldAltMap, ...fieldTestMap});
      });
      test('addEntry', () {
        var mp = MapExpression(fieldAltMap);
        MapEntry entry = fieldTestMap.entries.first;
        mp.addEntry(entry.key, entry.value);
        expect(mp.rawContent, {...fieldAltMap, ...fieldTestMap});
      });
      test('addMapEntry', () {
        var mp = MapExpression(fieldAltMap);
        mp.addMapEntry(fieldTestMap.entries.first);
        expect(mp.rawContent, {...fieldAltMap, ...fieldTestMap});
      });
      test('addExpression', () {
        var mp = MapExpression(fieldAltMap);
        MapEntry entry = fieldTestMap.entries.first;
        Expression exp =
            Expression(entry.key, ValueExpression.create(entry.value));
        mp.addExpression(exp);
        expect(mp.rawContent, {...fieldAltMap, ...fieldTestMap});
      });
    });
    group('Add Substitute', () {
      test('addMap', () {
        var mp = MapExpression(fieldTestMap3);
        mp.addMap(fieldTestMap);
        expect(mp.rawContent, fieldTestMap);
      });
      test('addMapExpression', () {
        var mp = MapExpression(fieldTestMap3);
        mp.addMapExpression(MapExpression(fieldTestMap));
        expect(mp.rawContent, fieldTestMap);
      });
      test('addEntry', () {
        var mp = MapExpression(fieldTestMap3);
        MapEntry entry = fieldTestMap.entries.first;
        mp.addEntry(entry.key, entry.value);
        expect(mp.rawContent, fieldTestMap);
      });
      test('addMapEntry', () {
        var mp = MapExpression(fieldTestMap3);
        mp.addMapEntry(fieldTestMap.entries.first);
        expect(mp.rawContent, fieldTestMap);
      });
      test('addExpression', () {
        var mp = MapExpression(fieldTestMap3);
        MapEntry entry = fieldTestMap.entries.first;
        Expression exp =
            Expression(entry.key, ValueExpression.create(entry.value));
        mp.addExpression(exp);
        expect(mp.rawContent, fieldTestMap);
      });
    });

    group('Empty', () {
      test('SetMapExpression', () {
        var mp = MapExpression.empty();
        var mp2 = MapExpression(fieldTestMap);

        mp.setMapExpression(mp2);
        expect(mp.rawContent, mp2.rawContent);
        expect(mp.rawContent, fieldTestMap);
      });
      test('AddMapExpression', () {
        var mp = MapExpression.empty();
        var mp2 = MapExpression(fieldTestMap);

        mp.addMapExpression(mp2);
        expect(mp.rawContent, mp2.rawContent);
        expect(mp.rawContent, fieldTestMap);
      });
    });
    group('Not Empty', () {
      test('SetMapExpression', () {
        var mp = MapExpression(fieldAltMap);
        var mp2 = MapExpression(fieldTestMap);

        mp.setMapExpression(mp2);
        expect(mp.rawContent, mp2.rawContent);
        expect(mp.rawContent, fieldTestMap);
      });
      test('AddMapExpression', () {
        var mp = MapExpression(fieldTestMap2);
        var mp2 = MapExpression(fieldTestMap);

        mp.addMapExpression(mp2);
        expect(mp.rawContent, mp2.rawContent);
        expect(mp.rawContent, fieldTestMap);
      });
      test('AddMapExpression - different', () {
        var mp = MapExpression(fieldAltMap);
        var mp2 = MapExpression(fieldTestMap);

        mp.addMapExpression(mp2);
        expect(mp.rawContent, {...fieldAltMap, ...fieldTestMap});
      });
    });
    group('Merge', () {
      test('Basic', () {
        var tMap = {
          'a': 1,
          'b': ['a', 'b', 'c'],
          'c': {'key': 'value'}
        };

        var e = MapExpression(tMap);
        e.merge('c', 5);
        expect(e.rawContent['c'], 5);

        e = MapExpression(tMap);
        e.merge('a', {'key': 'value2'});
        expect(e.rawContent['a'], {'key': 'value2'});

        e = MapExpression(tMap);
        e.merge('c', {'key': 'value2'});
        expect(e.rawContent['c'], {'key': 'value2'});

        e = MapExpression(tMap);
        e.merge('c', {'test': 'value2'});
        expect(e.rawContent['c'], {'key': 'value', 'test': 'value2'});

        e = MapExpression(tMap);
        e.merge('c', MapExpression({'test': 'value2'}));
        expect(e.rawContent['c'], {'key': 'value', 'test': 'value2'});

        e = MapExpression(tMap);
        e.merge('c', MapEntry('test', 'value2'));
        expect(e.rawContent['c'], {'key': 'value', 'test': 'value2'});

        e = MapExpression(tMap);
        e.merge('c', Expression('test', ValueExpression.create('value2')));
        expect(e.rawContent['c'], {'key': 'value', 'test': 'value2'});
      });
      test('Merge Entry', () {
        var e = MapExpression(fieldTestMap);
        e.mergeEntry(MapEntry('test', opTestMap2));
        expect(e.rawContent, fieldTestMap2);

        e = MapExpression(fieldTestMap);
        e.mergeEntry(MapEntry('test', opTestMap3));
        expect(e.rawContent, {
          'test': {...opTestMap, ...opTestMap3}
        });

        e = MapExpression(fieldTestMap);
        e.mergeEntry(MapEntry('alt', opTestMap));
        expect(e.rawContent, {...fieldTestMap, ...fieldAltMap});
      });
      test('Merge Document 1:1', () {
        var e = MapExpression(fieldTestMap);
        e.mergeDocument(fieldTestMap2);
        expect(e.rawContent, fieldTestMap2);

        e = MapExpression(fieldTestMap);
        e.mergeDocument(fieldTestMap3);
        expect(e.rawContent, {
          'test': {...opTestMap, ...opTestMap3}
        });

        e = MapExpression(fieldTestMap);
        e.mergeDocument(fieldAltMap);
        expect(e.rawContent, {...fieldTestMap, ...fieldAltMap});
      });
      test('Merge Document 1:N', () {
        var e = MapExpression(fieldTestMap);
        e.mergeDocument({...fieldTestMap2, ...fieldAltMap});
        expect(e.rawContent, {...fieldTestMap2, ...fieldAltMap});

        e = MapExpression(fieldTestMap);
        e.mergeDocument({...fieldTestMap3, ...fieldAltMap});
        expect(e.rawContent, {
          'test': {...opTestMap, ...opTestMap3},
          ...fieldAltMap
        });

        e = MapExpression.empty();
        e.mergeDocument({...fieldTestMap, ...fieldAltMap});
        expect(e.rawContent, {...fieldTestMap, ...fieldAltMap});
      });
      test('Merge Document N:1', () {
        var e = MapExpression({...fieldTestMap2, ...fieldAltMap});
        e.mergeDocument(fieldTestMap);
        expect(e.rawContent, {...fieldTestMap, ...fieldAltMap});

        e = MapExpression({...fieldTestMap3, ...fieldAltMap});
        e.mergeDocument(fieldTestMap);
        expect(e.rawContent, {
          'test': {...opTestMap3, ...opTestMap},
          ...fieldAltMap
        });

        e = MapExpression({...fieldTestMap, ...fieldAltMap});
        e.mergeDocument({});
        expect(e.rawContent, {...fieldTestMap, ...fieldAltMap});
      });
      test('Merge Map Expression 1:1', () {
        var e = MapExpression(fieldTestMap);
        e.mergeMapExpression(MapExpression(fieldTestMap2));
        expect(e.rawContent, fieldTestMap2);

        e = MapExpression(fieldTestMap);
        e.mergeMapExpression(MapExpression(fieldTestMap3));
        expect(e.rawContent, {
          'test': {...opTestMap, ...opTestMap3}
        });

        e = MapExpression(fieldTestMap);
        e.mergeMapExpression(MapExpression(fieldAltMap));
        expect(e.rawContent, {...fieldTestMap, ...fieldAltMap});
      });
      test('Merge Map Expression 1:N', () {
        var e = MapExpression(fieldTestMap);
        e.mergeMapExpression(MapExpression({...fieldTestMap2, ...fieldAltMap}));
        expect(e.rawContent, {...fieldTestMap2, ...fieldAltMap});

        e = MapExpression(fieldTestMap);
        e.mergeMapExpression(MapExpression({...fieldTestMap3, ...fieldAltMap}));
        expect(e.rawContent, {
          'test': {...opTestMap, ...opTestMap3},
          ...fieldAltMap
        });

        e = MapExpression.empty();
        e.mergeMapExpression(MapExpression({...fieldTestMap, ...fieldAltMap}));
        expect(e.rawContent, {...fieldTestMap, ...fieldAltMap});
      });
      test('Merge Map Expression N:1', () {
        var e = MapExpression({...fieldTestMap2, ...fieldAltMap});
        e.mergeMapExpression(MapExpression(fieldTestMap));
        expect(e.rawContent, {...fieldTestMap, ...fieldAltMap});

        e = MapExpression({...fieldTestMap3, ...fieldAltMap});
        e.mergeMapExpression(MapExpression(fieldTestMap));
        expect(e.rawContent, {
          'test': {...opTestMap3, ...opTestMap},
          ...fieldAltMap
        });

        e = MapExpression({...fieldTestMap, ...fieldAltMap});
        e.mergeMapExpression(MapExpression.empty());
        expect(e.rawContent, {...fieldTestMap, ...fieldAltMap});
      });
      test('Merge Expression 1:1', () {
        var e = MapExpression(fieldTestMap);
        e.mergeExpression(FieldExpression('test', MapExpression(opTestMap2)));
        expect(e.rawContent, fieldTestMap2);

        e = MapExpression(fieldTestMap);
        e.mergeExpression(FieldExpression('test', MapExpression(opTestMap3)));
        expect(e.rawContent, {
          'test': {...opTestMap, ...opTestMap3}
        });

        e = MapExpression(fieldTestMap);
        e.mergeExpression(FieldExpression('alt', MapExpression(opTestMap)));
        expect(e.rawContent, {...fieldTestMap, ...fieldAltMap});
      });
      test('Merge Expression N:1', () {
        var e = MapExpression({...fieldTestMap2, ...fieldAltMap});
        e.mergeExpression(FieldExpression('test', MapExpression(opTestMap)));
        expect(e.rawContent, {...fieldTestMap, ...fieldAltMap});

        e = MapExpression({...fieldTestMap3, ...fieldAltMap});
        e.mergeExpression(FieldExpression('test', MapExpression(opTestMap)));
        expect(e.rawContent, {
          'test': {...opTestMap3, ...opTestMap},
          ...fieldAltMap
        });

        e = MapExpression({...fieldTestMap, ...fieldAltMap});
        e.mergeExpression(FieldExpression('test', MapExpression.empty()));
        expect(e.rawContent, {...fieldTestMap, ...fieldAltMap});
      });
    });
  });
}
