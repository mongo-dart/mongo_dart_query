import 'package:mongo_dart_query/mongo_aggregation.dart';
import 'package:mongo_dart_query/mongo_dart_query.dart';
import 'package:test/test.dart' hide Skip;

void main() {
  test('addFields', () {
    expect(
        AddFields({
          'totalHomework': Sum(Field('homework')),
          'totalQuiz': Sum(Field('quiz'))
        }).build(),
        {
          '\$addFields': {
            'totalHomework': {'\$sum': '\$homework'},
            'totalQuiz': {'\$sum': '\$quiz'}
          }
        });
  });

  test('set', () {
    expect(
        SetStage({
          'totalHomework': Sum(Field('homework')),
          'totalQuiz': Sum(Field('quiz'))
        }).build(),
        {
          '\$set': {
            'totalHomework': {'\$sum': '\$homework'},
            'totalQuiz': {'\$sum': '\$quiz'}
          }
        });
  });

  test('setWindowFields', () {
    expect(
        SetWindowFields(
            partitionBy: {r'$year': r"$orderDate"},
            sortBy: {'orderDate': 1},
            output: Output('cumulativeQuantityForYear', Sum(r'$quantity'),
                documents: ["unbounded", "current"])).build(),
        {
          r'$setWindowFields': {
            'partitionBy': {r'$year': r"$orderDate"},
            'sortBy': {'orderDate': 1},
            'output': {
              'cumulativeQuantityForYear': {
                r'$sum': r"$quantity",
                'window': {
                  'documents': ["unbounded", "current"]
                }
              }
            }
          }
        });
    expect(
        SetWindowFields(
                partitionBy: r'$state',
                sortBy: {'orderDate': 1},
                output: Output('recentOrders', Push(r'$orderDate'),
                    range: ["unbounded", -10], unit: "month"))
            .build(),
        {
          r'$setWindowFields': {
            'partitionBy': r"$state",
            'sortBy': {'orderDate': 1},
            'output': {
              'recentOrders': {
                r'$push': r"$orderDate",
                'window': {
                  'range': ["unbounded", -10],
                  'unit': "month"
                }
              }
            }
          }
        });
    expect(
        SetWindowFields(output: Output('recentOrders', Avg(r'$orderDate')))
            .build(),
        {
          r'$setWindowFields': {
            'output': {
              'recentOrders': {
                r'$avg': r"$orderDate",
              }
            }
          }
        });
    expect(
        SetWindowFields(partitionBy: {
          r'$year': r'$orderDate'
        }, sortBy: {
          'orderDate': 1
        }, output: [
          Output('cumulativeQuantityForYear', Sum(r'$quantity'),
              documents: ["unbounded", "current"]),
          Output('maximumQuantityForYear', Max(r'$quantity'),
              documents: ["unbounded", "unbounded"])
        ]).build(),
        {
          r'$setWindowFields': {
            'partitionBy': {r'$year': r'$orderDate'},
            'sortBy': {'orderDate': 1},
            'output': {
              'cumulativeQuantityForYear': {
                r'$sum': r'$quantity',
                'window': {
                  'documents': ["unbounded", "current"]
                }
              },
              'maximumQuantityForYear': {
                r'$max': r'$quantity',
                'window': {
                  'documents': ["unbounded", "unbounded"]
                }
              }
            }
          }
        });
  });

  test('unset', () {
    expect(Unset(['isbn', 'author.first', 'copies.warehouse']).build(), {
      '\$unset': ['isbn', 'author.first', 'copies.warehouse']
    });
  });

  test('bucket', () {
    expect(
        Bucket(
            groupBy: Field('price'),
            boundaries: [0, 200, 400],
            defaultId: 'Other',
            output: {'count': Sum(1), 'titles': Push(Field('title'))}).build(),
        {
          '\$bucket': {
            'groupBy': '\$price',
            'boundaries': [0, 200, 400],
            'default': 'Other',
            'output': {
              'count': {'\$sum': 1},
              'titles': {'\$push': '\$title'}
            }
          }
        });
  });

  test('granularity', () {
    expect(Granularity.r5.build(), 'R5');
    expect(Granularity.r10.build(), 'R10');
    expect(Granularity.r20.build(), 'R20');
    expect(Granularity.r40.build(), 'R40');
    expect(Granularity.r80.build(), 'R80');
    expect(Granularity.e6.build(), 'E6');
    expect(Granularity.e12.build(), 'E12');
    expect(Granularity.e24.build(), 'E24');
    expect(Granularity.e48.build(), 'E48');
    expect(Granularity.e96.build(), 'E96');
    expect(Granularity.e192.build(), 'E192');
    expect(Granularity.g125.build(), '1-2-5');
    expect(Granularity.powersof2.build(), 'POWERSOF2');
  });

  test('bucketAuto', () {
    expect(
        BucketAuto(
            groupBy: Field('_id'),
            buckets: 5,
            granularity: Granularity.r5,
            output: {'count': Sum(1)}).build(),
        {
          '\$bucketAuto': {
            'groupBy': '\$_id',
            'buckets': 5,
            'granularity': 'R5',
            'output': {
              'count': {'\$sum': 1}
            }
          }
        });
  });

  test('count', () {
    expect(Count('myCount').build(), {'\$count': 'myCount'});
  });

  test('facet', () {
    expect(
        Facet({
          'categorizedByTags': [
            Unwind(Field('tags')),
            SortByCount(Field('tags'))
          ],
          'categorizedByPrice': [
            Match(where.exists('price').map['\$query']),
            Bucket(
                groupBy: Field('price'),
                boundaries: [0, 150, 200, 300, 400],
                defaultId: 'Other',
                output: {'count': Sum(1), 'titles': Push(Field('title'))})
          ],
          'categorizedByYears(Auto)': [
            BucketAuto(groupBy: Field('year'), buckets: 4)
          ]
        }).build(),
        {
          '\$facet': {
            'categorizedByTags': [
              {
                '\$unwind': {'path': '\$tags'}
              },
              {'\$sortByCount': '\$tags'}
            ],
            'categorizedByPrice': [
              {
                '\$match': {
                  'price': {'\$exists': true}
                }
              },
              {
                '\$bucket': {
                  'groupBy': '\$price',
                  'boundaries': [0, 150, 200, 300, 400],
                  'default': 'Other',
                  'output': {
                    'count': {'\$sum': 1},
                    'titles': {'\$push': '\$title'}
                  }
                }
              }
            ],
            'categorizedByYears(Auto)': [
              {
                '\$bucketAuto': {'groupBy': '\$year', 'buckets': 4}
              }
            ]
          }
        });
  });

  test('replaceWith', () {
    expect(ReplaceWith(Field('name')).build(), {'\$replaceWith': '\$name'});
    expect(
        ReplaceWith(MergeObjects([
          {'_id': Field('_id'), 'first': '', 'last': ''},
          Field('name')
        ])).build(),
        {
          '\$replaceWith': {
            '\$mergeObjects': [
              {'_id': '\$_id', 'first': '', 'last': ''},
              '\$name'
            ]
          }
        });
  });

  test('group', () {
    expect(
        Group(id: {
          'month': Month(Field('date')),
          'day': DayOfMonth(Field('date')),
          'year': Year(Field('date'))
        }, fields: {
          'totalPrice': Sum(Multiply([Field('price'), Field('quantity')])),
          'averageQuantity': Avg(Field('quantity')),
          'count': Sum(1)
        }).build(),
        {
          '\$group': {
            '_id': {
              'month': {
                '\$month': {'date': '\$date'}
              },
              'day': {
                '\$dayOfMonth': {'date': '\$date'}
              },
              'year': {
                '\$year': {'date': '\$date'}
              }
            },
            'totalPrice': {
              '\$sum': {
                '\$multiply': ['\$price', '\$quantity']
              }
            },
            'averageQuantity': {'\$avg': '\$quantity'},
            'count': {'\$sum': 1}
          }
        });
    expect(
        Group(id: null, fields: {
          'totalPrice': Sum(Multiply([Field('price'), Field('quantity')])),
          'averageQuantity': Avg(Field('quantity')),
          'count': Sum(1)
        }).build(),
        {
          '\$group': {
            '_id': null,
            'totalPrice': {
              '\$sum': {
                '\$multiply': ['\$price', '\$quantity']
              }
            },
            'averageQuantity': {'\$avg': '\$quantity'},
            'count': {'\$sum': 1}
          }
        });
    expect(Group(id: Field('item')).build(), {
      '\$group': {'_id': '\$item'}
    });
    expect(
        Group(id: Field('author'), fields: {'books': Push(Field('title'))})
            .build(),
        {
          '\$group': {
            '_id': '\$author',
            'books': {'\$push': '\$title'}
          }
        });
    expect(
        Group(id: Field('author'), fields: {'books': Push(Var.root)}).build(), {
      '\$group': {
        '_id': '\$author',
        'books': {'\$push': '\$\$ROOT'}
      }
    });
  });

  test('match', () {
    expect(Match(where.eq('author', 'dave').map['\$query']).build(), {
      '\$match': {'author': 'dave'}
    });
    expect(Match(Expr(Eq(Field('author'), 'dave'))).build(), {
      '\$match': {
        '\$expr': {
          '\$eq': ['\$author', 'dave']
        }
      }
    });
  });

  test('lookup', () {
    expect(
        Lookup(
                from: 'inventory',
                localField: 'item',
                foreignField: 'sku',
                as: 'inventory_docs')
            .build(),
        {
          '\$lookup': {
            'from': 'inventory',
            'localField': 'item',
            'foreignField': 'sku',
            'as': 'inventory_docs'
          }
        });
    expect(
        Lookup.withPipeline(
                from: 'warehouses',
                let: {
                  'order_item': Field('item'),
                  'order_qty': Field('ordered')
                },
                pipeline: [
                  Match(Expr(And([
                    Eq(Field('stock_item'), Var('order_item')),
                    Gte(Field('instock'), Var('order_qty'))
                  ]))),
                  Project({'stock_item': 0, '_id': 0})
                ],
                as: 'stockdata')
            .build(),
        {
          '\$lookup': {
            'from': 'warehouses',
            'let': {'order_item': '\$item', 'order_qty': '\$ordered'},
            'pipeline': [
              {
                '\$match': {
                  '\$expr': {
                    '\$and': [
                      {
                        '\$eq': ['\$stock_item', '\$\$order_item']
                      },
                      {
                        '\$gte': ['\$instock', '\$\$order_qty']
                      }
                    ]
                  }
                }
              },
              {
                '\$project': {'stock_item': 0, '_id': 0}
              }
            ],
            'as': 'stockdata'
          }
        });
  });

  test('graphLookup', () {
    expect(
        GraphLookup(
                from: 'employees',
                startWith: 'reportsTo',
                connectFromField: 'reportsTo',
                connectToField: 'name',
                as: 'reportingHierarchy',
                depthField: 'depth',
                maxDepth: 5,
                restrictSearchWithMatch: where.eq('field', 'value'))
            .build(),
        {
          r'$graphLookup': {
            'from': 'employees',
            'startWith': r'$reportsTo',
            'connectFromField': 'reportsTo',
            'connectToField': 'name',
            'as': 'reportingHierarchy',
            'depthField': 'depth',
            'maxDepth': 5,
            'restrictSearchWithMatch': {'field': 'value'}
          }
        });
  });
  test('unwind', () {
    expect(Unwind(Field('sizes')).build(), {
      '\$unwind': {'path': '\$sizes'}
    });
  });

  test('project', () {
    expect(Project({'_id': 0, 'title': 1, 'author': 1}).build(), {
      '\$project': {'_id': 0, 'title': 1, 'author': 1}
    });
  });

  test('skip', () {
    expect(Skip(5).build(), {'\$skip': 5});
  });

  test('limit', () {
    expect(Limit(5).build(), {'\$limit': 5});
  });

  test('sort', () {
    expect(Sort({'age': -1, 'posts': 1}).build(), {
      '\$sort': {'age': -1, 'posts': 1}
    });
  });

  test('sortByCount', () {
    expect(SortByCount(Field('employee')).build(),
        {'\$sortByCount': '\$employee'});
    expect(
        SortByCount(MergeObjects([Field('employee'), Field('business')]))
            .build(),
        {
          '\$sortByCount': {
            '\$mergeObjects': ['\$employee', '\$business']
          }
        });
  });

  test('geoNear', () {
    expect(
        GeoNear(
                near: Geometry.point([-73.99279, 40.719296]),
                distanceField: 'dist.calculated',
                maxDistance: 2,
                query: where.eq('category', 'Parks').map['\$query'],
                includeLocs: 'dist.location',
                spherical: true)
            .build(),
        {
          r'$geoNear': {
            'near': {
              'type': 'Point',
              'coordinates': [-73.99279, 40.719296]
            },
            'distanceField': 'dist.calculated',
            'maxDistance': 2,
            'query': {'category': 'Parks'},
            'includeLocs': 'dist.location',
            'spherical': true
          }
        });

    expect(SortByCount(Field('employee')).build(),
        {'\$sortByCount': '\$employee'});
    expect(
        SortByCount(MergeObjects([Field('employee'), Field('business')]))
            .build(),
        {
          '\$sortByCount': {
            '\$mergeObjects': ['\$employee', '\$business']
          }
        });
  });
  test('unionWith', () {
    expect(
        UnionWith(
          coll: 'warehouses',
          pipeline: [
            Project({'state': 1, '_id': 0})
          ],
        ).build(),
        {
          r'$unionWith': {
            'coll': 'warehouses',
            'pipeline': [
              {
                r'$project': {'state': 1, '_id': 0}
              }
            ]
          }
        });
    expect(
        UnionWith(coll: 'warehouses', pipeline: [
          Match(Expr(And([
            Eq(Field('stock_item'), Var('order_item')),
            Gte(Field('instock'), Var('order_qty'))
          ]))),
          Project({'stock_item': 0, '_id': 0})
        ]).build(),
        {
          r'$unionWith': {
            'coll': 'warehouses',
            'pipeline': [
              {
                r'$match': {
                  r'$expr': {
                    r'$and': [
                      {
                        r'$eq': [r'$stock_item', r'$$order_item']
                      },
                      {
                        r'$gte': [r'$instock', r'$$order_qty']
                      }
                    ]
                  }
                }
              },
              {
                r'$project': {'stock_item': 0, '_id': 0}
              }
            ]
          }
        });
  });
}
