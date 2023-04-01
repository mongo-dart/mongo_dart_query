library test_lib;

import 'package:fixnum/fixnum.dart';
import 'package:mongo_dart_query/src/common/constant.dart';
import 'package:test/test.dart';
import 'package:mongo_dart_query/mongo_query.dart';

void main() {
  group('Update Expression', () {
    test('Current Date', () {
      var modifier = modify
        ..$currentDate('a')
        ..$currentDate('b', asTimestamp: true)
        ..$currentDate('c', asTimestamp: false);
      expect(
          modifier.raw,
          equals({
            r'$currentDate': {
              'a': {r'$type': 'date'},
              'b': {r'$type': 'timestamp'},
              'c': {r'$type': 'date'}
            }
          }));
    });

    test('Inc - Min - Max', () {
      var modifier = modify
        ..$inc('a', 5)
        ..$min('b', 'Set')
        ..$max('c', null)
        ..$max('d', 200);
      expect(
          modifier.raw,
          equals({
            r'$inc': {'a': 5},
            r'$min': {'b': 'Set'},
            r'$max': {'c': null, 'd': 200}
          }));
    });
    test('mul', () {
      var modifier = modify
        ..$set('a', 995)
        ..$mul('b', 5);
      expect(
          modifier.raw,
          equals({
            r'$set': {'a': 995},
            r'$mul': {'b': 5}
          }));
      modifier = modify
        ..$mul('a', 7.0)
        ..$mul('b', 3);
      expect(
          modifier.raw,
          equals({
            r'$mul': {'a': 7.0, 'b': 3}
          }));
    });
    test('Rename', () {
      var modifier = modify..$rename('nmae', "name");
      expect(
          modifier.raw,
          equals({
            r'$rename': {'nmae': 'name'}
          }));
    });

    test('Set - Unset - SetOnInsert', () {
      var modifier = modify
        ..$set('a', 995)
        ..$set('b', 'bbb')
        ..$setOnInsert('c', true);
      expect(
          modifier.raw,
          equals({
            r'$set': {'a': 995, 'b': 'bbb'},
            r'$setOnInsert': {'c': true}
          }));
      modifier = modify
        ..$unset('a')
        ..$unset('b');
      expect(
          modifier.raw,
          equals({
            r'$unset': {'a': 1, 'b': 1}
          }));
    });

    test('Add to Set', () {
      var modifier = modify..$addToSet('colors', 'mauve');
      expect(
          modifier.raw,
          equals({
            r'$addToSet': {'colors': 'mauve'}
          }));
    });
    test('Add each to Set', () {
      var modifier = modify..addEachToSet('colors', ['green', 'orange']);
      expect(
          modifier.raw,
          equals({
            r'$addToSet': {
              'colors': {
                r'$each': ['green', 'orange']
              }
            }
          }));
    });
    test('Pop', () {
      var modifier = modify
        ..popFirst('colors')
        ..popLast('name');
      expect(
          modifier.raw,
          equals({
            r'$pop': {'colors': -1, 'name': 1}
          }));
    });
    test('Pull', () {
      var modifier = modify
        ..$pull('fruits', {
          r'$in': ['apples', 'oranges']
        })
        ..$pull('vegetables', 'carrots');
      expect(
          modifier.raw,
          equals({
            r'$pull': {
              'fruits': {
                r'$in': ['apples', 'oranges']
              },
              'vegetables': 'carrots'
            }
          }));
    });
    test('Push - Push each', () {
      var modifier = modify
        ..$push('scores', 89)
        ..pushEach('rates', [90, 92, 85])
        ..pushEach(
            'quizzes',
            [
              {'wk': 5, 'score': 8},
              {'wk': 6, 'score': 7},
              {'wk': 7, 'score': 6}
            ],
            sortDocument: {'score': -1},
            slice: 3)
        ..pushEach('names', ['John', 'Ann', 'Lou'],
            position: -1, sort: descending);
      expect(
          modifier.raw,
          equals({
            r'$push': {
              'scores': 89,
              'rates': {
                r'$each': [90, 92, 85]
              },
              'quizzes': {
                r'$each': [
                  {'wk': 5, 'score': 8},
                  {'wk': 6, 'score': 7},
                  {'wk': 7, 'score': 6}
                ],
                r'$sort': {'score': -1},
                r'$slice': 3
              },
              'names': {
                r'$each': ['John', 'Ann', 'Lou'],
                r'$position': -1,
                r'$sort': -1
              }
            }
          }));
    });
    test('Pull All', () {
      var modifier = modify
        ..$pullAll('scores', [0, 5])
        ..$pull('vegetables', 'carrots');
      expect(
          modifier.raw,
          equals({
            r'$pullAll': {
              'scores': [0, 5]
            },
            r'$pull': {'vegetables': 'carrots'}
          }));
    });
    test('Bit', () {
      var modifier = modify
        ..bitAnd('expdata', 10)
        ..bitOr('scores', 20)
        ..bitXor('days', 16)
        ..bitAnd64('series', Int64(8));
      expect(
          modifier.raw,
          equals({
            r'$bit': {
              'expdata': {'and': 10},
              'scores': {'or': 20},
              'days': {'xor': 16},
              'series': {'and': Int64(8)}
            }
          }));
    });
  });
}
