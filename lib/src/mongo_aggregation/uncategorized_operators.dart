import 'aggregation_base.dart';

/// `$expr` operator
class Expr extends Operator {
  /// Creates an `$expr` part of `$match` stage
  ///
  /// The operator is used in `match` aggregation stage to define match expression
  /// as aggregation expression.
  ///
  /// [expr] - aggregation expression which usually resolves into [bool]
  Expr(AggregationExpr expr) : super('expr', expr);
}

/// `$let` operator
class Let extends Operator {
  /// Creates `$let` operator expression
  ///
  /// Binds variables for use in the specified expression, and returns the
  /// result of the expression.
  ///
  /// * [vars] - Assignment block for the variables accessible in the in
  /// expression. To assign a variable, specify a string for the variable name
  /// and assign a valid expression for the value. The variable assignments
  /// have no meaning outside the in expression, not even within the vars block
  /// itself.
  /// * [inExpr] - The expression to evaluate.
  Let({required Map<String, dynamic> vars, required inExpr})
      : super('let', AEObject({'vars': AEObject(vars), 'in': inExpr}));
}

// TODO: Trigonometry Expression Operators
// TODO: Text Expression Operator
