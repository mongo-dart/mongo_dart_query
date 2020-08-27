import 'package:mongo_dart_query/src/mongo_aggregation/aggregation_base.dart';
import 'package:test/test.dart';

void main() {
  test('field', () {
    expect(Field('field').build(), '\$field');
  });

  test('literal', () {
    expect(Literal('\$value').build(), {'\$literal': '\$value'});
  });

  test('variable', () {
    expect(Var('variable').build(), '\$\$variable');
  });

  test('system variables', () {
    expect(Var.now.build(), '\$\$NOW');
    expect(Var.clusterTime.build(), '\$\$CLUSTER_TIME');
    expect(Var.root.build(), '\$\$ROOT');
    expect(Var.current.build(), '\$\$CURRENT');
    expect(Var.remove.build(), '\$\$REMOVE');
    expect(Var.discend.build(), '\$\$DISCEND');
    expect(Var.prune.build(), '\$\$PRUNE');
    expect(Var.keep.build(), '\$\$KEEP');
  });

  test('AEList filter null elements', () {
    expect(AEList([1, 'string', null, 2]).build(),
        containsAllInOrder([1, 'string', 2]));
  });

  test('AEObject filter null values', () {
    expect(
        AEObject({'num': 1, 'string': 'value', 'null': null, 'two': 2}).build(),
        {'num': 1, 'string': 'value', 'two': 2});
  });

  test('AElist#build', () {
    expect(AEList([1, TestExpr(), 'string']).build(),
        containsAllInOrder([1, 'test', 'string']));
  });

  test('AEObject#build', () {
    expect(AEObject({'num': 1, 'expr': TestExpr(), 'string': 'value'}).build(),
        {'num': 1, 'expr': 'test', 'string': 'value'});
  });
}

class TestExpr implements AggregationExpr {
  @override
  String build() => 'test';
}
