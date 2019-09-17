import 'package:meta/meta.dart';

/// Builder interface
abstract class Builder {
  dynamic build();
  const Builder();
}

/// Aggregation expression
abstract class AggregationExpr implements Builder {
  const AggregationExpr();
}

/// Basic aggregation operator
abstract class Operator extends AggregationExpr {
  final _args;
  final String _name;
  Operator(this._name, this._args);
  @override
  Map<String, dynamic> build() =>
      {'\$$_name': _args is AggregationExpr ? _args.build() : _args};
}

/// Basic accumulation operator
abstract class Accumulator extends Operator {
  Accumulator(String name, expr) : super(name, expr);
}

/// Aggregation expression's list
///
/// The list is used in aggregation expressions and is aggregation expression as well
class AEList extends Iterable implements AggregationExpr {
  final Iterable _iterable;
  factory AEList(Iterable iterable) {
    if (iterable == null) return null;
    return AEList.internal(iterable.where(_valueIsNotNull).map((value) {
      if (value is List) return AEList(value);
      if (value is Map<String, dynamic>) return AEObject(value);
      return value;
    }));
  }
  @protected
  AEList.internal(this._iterable);

  _AEIterator get iterator => _AEIterator(_iterable);
  @override
  List build() => _iterable
      .map((expr) => expr is AggregationExpr ? expr.build() : expr)
      .toList();
}

/// Iterator for [AEList]
class _AEIterator<T> implements Iterator<T> {
  final Iterable<T> _iterable;
  int _currentIndex = -1;
  T _current;

  _AEIterator(this._iterable);

  @override
  bool moveNext() {
    if (_currentIndex + 1 == _iterable.length) {
      _current = null;
      return false;
    }
    _current = _iterable.elementAt(++_currentIndex);
    return true;
  }

  T get current => _current;
}

/// Aggregation expression's object
///
/// The object is used in aggregation expressions and is aggregation expression as well
class AEObject extends Iterable<MapEntry<String, dynamic>>
    implements AggregationExpr {
  final Iterable<MapEntry<String, dynamic>> _iterable;

  factory AEObject(Map<String, dynamic> map) {
    if (map == null) return null;
    return AEObject.internal(map);
  }
  @protected
  AEObject.internal(Map<String, dynamic> map)
      : _iterable = map.entries.where(_valueIsNotNull).map((entry) {
          if (entry.value is List)
            return MapEntry(entry.key, AEList(entry.value as List));
          if (entry.value is Map<String, dynamic>)
            return MapEntry(entry.key, AEObject(entry.value as Map<String, dynamic>));
          return entry;
        });
  @override
  _AEIterator<MapEntry<String, dynamic>> get iterator =>
      _AEIterator<MapEntry<String, dynamic>>(_iterable);
  @override
  Map<String, dynamic> build() =>
      Map.fromEntries(_iterable).map((argName, argValue) => MapEntry(
          argName, argValue is AggregationExpr ? argValue?.build() : argValue));
}

/// Returns `true` if value is not null
///
/// The function is used  to filter not null elements in [AEObject] and [AEList]
/// constuctors
bool _valueIsNotNull(value) =>
    value is MapEntry ? value.value != null : value != null;

/// Field path expression
///
class Field extends AggregationExpr {
  final String _fieldPath;

  /// Creates a field path expression
  ///
  /// [fieldPath] - [String] describing a field path. To traverse an
  /// hierarchical document use dot notation. For example: `user.name`
  ///
  /// After build [Field] will look like `$fieldPath`
  const Field(String fieldPath) : _fieldPath = fieldPath;
  @override
  String build() => '\$$_fieldPath';
}

/// Constant expression
class Const extends AggregationExpr {
  final _value;
  const Const(this._value);
  @override
  dynamic build() => _value;
}

/// Literal expression
///
/// Literals can be of any type. However, MongoDB parses string literals that
/// start with a dollar sign $ as a path to a field and numeric/boolean literals
/// in expression objects as projection flags. To avoid parsing literals, use
/// the [Literal] expression
class Literal extends AggregationExpr {
  final _expr;

  /// Creates a literal expression
  const Literal(this._expr);
  @override
  Map<String, dynamic> build() => {'\$literal': _expr};
}

/// Aggregation expression's variable
///
/// [Var] can be used to insert user defined an system variables in aggregation
/// expressions
class Var extends AggregationExpr {
  /// Current datetime value.
  ///
  /// [now] has the same value for all members of the deployment and remains the
  /// same throughout all stages of the aggregation pipeline.
  static const now = Var('NOW');

  /// Current timestamp value.
  ///
  /// [clusterTime] is only available on replica sets and sharded clusters.
  /// [clusterTime] has the same value for all members of the deployment and
  /// remains the same throughout all stages of the pipeline.
  static const clusterTime = Var('CLUSTER_TIME');

  /// The root document.
  ///
  /// The top-level document, currently being processed in the aggregation
  /// pipeline stage.
  static const root = Var('ROOT');

  /// The start of the field path being processed in the aggregation pipeline stage.
  ///
  /// Unless documented otherwise, all stages start with curren the same as root.
  /// Current is modifiable. However, since $<field> is equivalent to $$CURRENT.<field>,
  /// rebinding CURRENT changes the meaning of $ accesses.
  static const current = Var('CURRENT');

  /// A variable which evaluates to the missing value.
  ///
  /// Allows for the conditional exclusion of fields. In a $projection, a field
  /// set to the variable REMOVE is excluded from the output.
  /// For an example of its usage, see
  /// [Conditionally Exclude Fields](https://docs.mongodb.com/manual/reference/operator/aggregation/project/#remove-example).
  static const remove = Var('REMOVE');

  /// One of the allowed results of a
  /// [$redact](https://docs.mongodb.com/manual/reference/operator/aggregation/redact/#pipe._S_redact) expression.
  static const discend = Var('DISCEND');

  /// One of the allowed results of a
  /// [$redact](https://docs.mongodb.com/manual/reference/operator/aggregation/redact/#pipe._S_redact) expression.
  static const prune = Var('PRUNE');

  /// One of the allowed results of a
  /// [$redact](https://docs.mongodb.com/manual/reference/operator/aggregation/redact/#pipe._S_redact) expression.
  static const keep = Var('KEEP');

  final String _name;

  /// Creates a variable expression
  ///
  /// After build variable will look like `$$name`
  const Var(String name) : _name = name;

  @override
  String build() => '\$\$$_name';
}

/// Aggregation stage base
abstract class AggregationStage implements AggregationExpr {
  final String _name;
  final _content;
  AggregationStage(this._name, this._content);

  @override
  Map<String, dynamic> build() =>
      {'\$$_name': _content is AggregationExpr ? _content.build() : _content};
}
