import 'aggregation_base.dart';

/// `$and` operator
class And extends Operator {
  /// Creates `$and` operator expression
  ///
  /// Evaluates one or more expressions and returns `true` if all of the
  /// expressions are `true` or if evoked with no argument expressions. Otherwise,
  /// `$and` returns `false`.
  And(List args) : super('and', AEList(args));
}

/// `$or` operator
class Or extends Operator {
  /// Creates `$or` operator expression
  ///
  /// Evaluates one or more expressions and returns `true` if any of the expressions
  /// are `true`. Otherwise, `$or` returns `false`.
  Or(List args) : super('or', AEList(args));
}

/// `$not` operator
class Not extends Operator {
  /// Creates `$not` operator expression
  ///
  /// Evaluates a boolean and returns the opposite boolean value; i.e. when
  /// passed an expression that evaluates to `true`, `$not` returns `false`; when
  /// passed an expression that evaluates to `false`, $not returns `true`.
  Not(expr) : super('not', expr);
}
