library test_lib;

import 'package:test/test.dart';
import 'package:bson/bson.dart';
import 'package:mongo_dart_query/mongo_query.dart';
import 'package:mongo_dart_query/src/geometry_obj.dart';

void main() {
  test('SelectorBuilder Creation', () {
    var selector = where;
    expect(selector.filter.rawContent, isMap);
    expect(selector.filter.rawContent, isEmpty);
  });

  test('testSelectorBuilderOnObjectId', () {
    var id = ObjectId();
    var selector = where..id(id);
    expect(selector.filter.rawContent.isNotEmpty, isTrue);
    expect(
        selector.filter.rawContent,
        equals({
          '_id': {r'$eq': id}
        }));
  });

  test('testSelectorBuilderRawMap', () {
    var selector = where..raw({'name': 'joe'});

    var id = ObjectId();
    selector.id(id);
    //expect(selector.map is Map, isTrue);
    expect(selector.filter.rawContent.isNotEmpty, isTrue);
    expect(
        selector.filter.rawContent,
        equals({
          'name': 'joe',
          '_id': {r'$eq': id}
        }));
  });

  test('testQueries', () {
    var selector = where
      ..$gt('my_field', 995)
      ..sortBy('my_field');
    expect(selector.filter.rawContent, {
      'my_field': {r'$gt': 995},
      'orderby': {'my_field': 1}
    });
    expect(false, isTrue);
    selector = where
      ..inRange('my_field', 700, 703, minInclude: false)
      ..sortBy('my_field');
    expect(selector.filter.rawContent, {
      r'$query': {
        'my_field': {r'$gt': 700, r'$lt': 703}
      },
      'orderby': {'my_field': 1}
    });
    selector = where
      ..$eq('my_field', 17)
      ..fields(['str_field']);
    expect(selector.filter.rawContent, {
      r'$query': {'my_field': 17}
    });
    expect(selector.paramFields, {'str_field': 1});
    selector = where
      ..sortBy('a')
      ..skip(300);
    expect(
        selector.filter.rawContent,
        equals({
          '\$query': {},
          'orderby': {'a': 1}
        }));
    selector = where
      ..hint('bar')
      ..hint('baz', descending: true)
      ..explain();
    expect(
        selector.filter.rawContent,
        equals({
          '\$query': {},
          '\$hint': {'bar': 1, 'baz': -1},
          '\$explain': true
        }));
    selector = where..hintIndex('foo');
    expect(
        selector.filter.rawContent, equals({'\$query': {}, '\$hint': 'foo'}));
  });

  test('testQueryComposition', () {
    var selector = where
      ..$gt('a', 995)
      ..$eq('b', 'bbb');
    expect(selector.filter.rawContent, {
      'a': {r'$gt': 995},
      'b': {r'$eq': 'bbb'}
    });
  });

  test('testQueryComposition 2', () {
    var selector = where
      ..$gt('a', 995)
      ..$lt('a', 1000);
    expect(
        selector.filter.rawContent,
        equals({
          'a': {r'$gt': 995, r'$lt': 1000},
        }));
  });

  test('testQueryComposition 3', () {
    var selector = where
      ..$gt('a', 995)
      ..$and
      ..open
      ..$lt('b', 1000)
      ..$or
      ..$gt('c', 2000)
      ..close;
    /* var selector = where
      ..$gt('a', 995)
      ..and(where
        ..$lt('b', 1000)
        ..or(where..$gt('c', 2000))); */
    expect(selector.filter.rawContent, {
      'a': {r'$gt': 995},
      r'$or': [
        {
          'b': {r'$lt': 1000}
        },
        {
          'c': {r'$gt': 2000}
        }
      ]
    });
  });

  test('testQueryComposition 4', () {
    var selector = where
      ..open
      ..$lt('b', 1000)
      ..$or
      ..$gt('c', 2000)
      ..close
      ..$gt('a', 995);
    expect(selector.filter.rawContent, {
      r'$or': [
        {
          'b': {r'$lt': 1000}
        },
        {
          'c': {r'$gt': 2000}
        }
      ],
      'a': {r'$gt': 995}
    });
  });

  test('testQueryComposition 5', () {
    var selector = where
      ..$lt('b', 1000)
      ..$or
      ..$gt('c', 2000)
      ..$and
      ..$gt('a', 995);
    expect(selector.filter.rawContent, {
      r'$or': [
        {
          'b': {r'$lt': 1000}
        },
        {
          'c': {r'$gt': 2000},
          'a': {r'$gt': 995}
        }
      ],
    });
  });

  test('testQueryComposition 6', () {
    var selector = where
      ..$lt('b', 1000)
      ..$or
      ..$gt('c', 2000)
      ..$or
      ..$gt('a', 995);
    expect(selector.filter.rawContent, {
      r'$or': [
        {
          'b': {r'$lt': 1000}
        },
        {
          'c': {r'$gt': 2000}
        },
        {
          'a': {r'$gt': 995}
        }
      ]
    });
  });

  test('testQueryComposition 7', () {
    var selector = where
      ..$eq('price', 1.99)
      ..$and
      ..open
      ..$lt('qty', 20)
      ..$or
      ..$eq('sale', true)
      ..close;
    expect(selector.filter.rawContent, {
      'price': {r'$eq': 1.99},
      r'$or': [
        {
          'qty': {r'$lt': 20}
        },
        {
          'sale': {r'$eq': true}
        }
      ]
    });
  });
  test('testQueryComposition 7 bis', () {
    var selector = where
      ..$eq('price', 1.99)
      ..open
      ..$lt('qty', 20)
      ..$or
      ..$eq('sale', true);
    expect(selector.filter.rawContent, {
      'price': {r'$eq': 1.99},
      r'$or': [
        {
          'qty': {r'$lt': 20}
        },
        {
          'sale': {r'$eq': true}
        }
      ]
    });
  });

  test('testQueryComposition 8', () {
    var selector = where
      ..$eq('price', 1.99)
      ..$and
      ..$lt('qty', 20)
      ..$and
      ..$eq('sale', true);
    expect(selector.filter.rawContent, {
      'price': {r'$eq': 1.99},
      'qty': {r'$lt': 20},
      'sale': {r'$eq': true}
    });
  });

  test('testQueryComposition 9', () {
    var selector = where
      ..$eq('price', 1.99)
      ..$lt('qty', 20)
      ..$eq('sale', true);
    expect(selector.filter.rawContent, {
      'price': {r'$eq': 1.99},
      'qty': {'\$lt': 20},
      'sale': {r'$eq': true}
    });
  });

  test('testQueryComposition 10', () {
    var selector = where
      ..$eq('foo', 'bar')
      ..$or
      ..$eq('foo', null)
      ..$eq('name', 'jack');
    expect(selector.filter.rawContent, {
      r'$or': [
        {
          'foo': {r'$eq': 'bar'}
        },
        {
          'foo': {r'$eq': null}
        }
      ],
      'name': {r'$eq': 'jack'}
    });
  });
  test('testGetQueryString', () {
    var selector = where..$eq('foo', 'bar');
    expect(selector.getQueryString(), r'{"foo":{"$eq":"bar"}}');
    selector = where..$lt('foo', 2);
    expect(selector.getQueryString(), r'{"foo":{"$lt":2}}');
    var id = ObjectId();
    selector = where..id(id);
    expect(selector.getQueryString(), '{"_id":{"\$eq":"${id.toHexString()}"}}');
//  var dbPointer = new DbRef('Dummy',id);
//  selector = where.eq('foo',dbPointer);
//  expect(selector.getQueryString(),'{"\$query":{"foo":$dbPointer}}');
  });

  test('sortByMetaTextScore', () {
    var fieldName = 'fName';
    var searchText = 'sText';
    var selector = where
      ..sortBy(fieldName)
      ..$eq('\$text', {'\$search': searchText})
      ..metaTextScore('score');

    expect(selector.getQueryString(),
        r'{"$query":{"$text":{"$search":"sText"}},"orderby":{"fName":1}}');
  });

  test('copyWith_clone', () {
    var selector = where
      ..$eq('field', 'value')
      ..$gt('num_field', 5)
      ..and(where..nearSphere('geo_obj', Geometry.point([35.0, 35.0])));

    var copied = QueryExpression.copyWith(selector);

    expect(selector.getQueryString(), equals(copied.getQueryString()));
  });

  test('nearSphere', () {
    var selector = where
      ..nearSphere(
          'geo_field',
          Geometry(type: GeometryObjectType.Polygon, coordinates: [
            [0, 0],
            [1, 8],
            [12, 30],
            [0, 0]
          ]),
          maxDistance: 1000,
          minDistance: 500);

    expect(
        selector.filter.rawContent,
        equals({
          'geo_field': {
            r'$nearSphere': {
              r'$geometry': {
                'type': 'Polygon',
                'coordinates': [
                  [0, 0],
                  [1, 8],
                  [12, 30],
                  [0, 0]
                ]
              },
              r'$minDistance': 500,
              r'$maxDistance': 1000
            }
          }
        }));
  });

  test('geoIntersects', () {
    var selector = where
      ..geoIntersects(
          'geo_field',
          Geometry(type: GeometryObjectType.Polygon, coordinates: [
            [0, 0],
            [1, 8],
            [12, 30],
            [0, 0]
          ]));

    expect(
        selector.filter.rawContent,
        equals({
          'geo_field': {
            r'$geoIntersects': {
              r'$geometry': {
                'type': 'Polygon',
                'coordinates': [
                  [0, 0],
                  [1, 8],
                  [12, 30],
                  [0, 0]
                ]
              }
            }
          }
        }));
  });

  test('geoWithin_geometry', () {
    var selector = where
      ..geoWithin(
          'geo_field',
          Geometry(type: GeometryObjectType.Polygon, coordinates: [
            [0, 0],
            [1, 8],
            [12, 30],
            [0, 0]
          ]));

    expect(
        selector.filter.rawContent,
        equals({
          'geo_field': {
            r'$geoWithin': {
              r'$geometry': {
                'type': 'Polygon',
                'coordinates': [
                  [0, 0],
                  [1, 8],
                  [12, 30],
                  [0, 0]
                ]
              }
            }
          }
        }));
  });

  test('geoWithin_box', () {
    var selector = where
      ..geoWithin(
          'geo_field', Box(bottomLeft: [5, 8], upperRight: [8.8, 10.5]));

    expect(
        selector.filter.rawContent,
        equals({
          'geo_field': {
            r'$geoWithin': {
              r'$box': [
                [5, 8],
                [8.8, 10.5]
              ]
            }
          }
        }));
  });

  test('geoWithin_center', () {
    var selector = where
      ..geoWithin('geo_field', Center(center: [5, 8], radius: 50.2));

    expect(
        selector.filter.rawContent,
        equals({
          'geo_field': {
            r'$geoWithin': {
              r'$center': [
                [5, 8],
                50.2
              ]
            }
          }
        }));
  });
}
