import 'package:meta/meta.dart';

import 'aggregation_base.dart';

/// `$cmp` operator
///
/// Compares two values and returns:
///
/// * -1 if the first value is less than the second.
/// * 1 if the first value is greater than the second.
/// * 0 if the two values are equivalent.
class Cmp extends Operator {
  /// Creates `$cmp` operator expression
  Cmp(a, b) : super('cmp', AEList([a, b]));
}

/// `$eq` operator
///
/// Compares two values and returns:
///
/// * `true` when the values are equivalent.
/// * `false` when the values are not equivalent.
class Eq extends Operator {
  /// Creates `$eq` operator expression
  Eq(a, b) : super('eq', AEList([a, b]));
}

/// `$gt` operator
///
/// Compares two values and returns:
///
/// * `true` when the first value is greater than the second value.
/// * `false` when the first value is less than or equivalent to the second
/// value.
class Gt extends Operator {
  /// Creates `$gt` operator expression
  Gt(a, b) : super('gt', AEList([a, b]));
}

/// `$gte` operator
///
/// Compares two values and returns:
///
/// * `true` when the first value is greater than or equivalent to the second
/// value.
/// * `false` when the first value is less than the second value.
class Gte extends Operator {
  /// Creates `$gte` operator expression
  Gte(a, b) : super('gte', AEList([a, b]));
}

/// `$lt` operator
///
/// Compares two values and returns:
///
/// * `true` when the first value is less than the second value.
/// * `false` when the first value is greater than or equivalent to the second
/// value.
class Lt extends Operator {
  /// Creates `$lt` operator expression
  Lt(a, b) : super('lt', AEList([a, b]));
}

/// `lte` operator
///
/// Compares two values and returns:
///
/// * `true` when the first value is less than or equivalent to the second value.
/// * `false` when the first value is greater than the second value.
class Lte extends Operator {
  /// Creates `$lte` operator expression
  Lte(a, b) : super('lte', AEList([a, b]));
}

/// `$ne` operator
///
/// Compares two values and returns:
///
/// * `true` when the values are not equivalent.
/// * `false` when the values are equivalent.
class Ne extends Operator {
  /// Creates `$ne` operator expression
  Ne(a, b) : super('ne', AEList([a, b]));
}

/// `$cond` operator
///
/// Evaluates a boolean expression to return one of the two specified return
/// expressions.
///
/// The arguments can be any valid expression.
class Cond extends Operator {
  /// Creates `$cond` operator expression
  Cond({@required ifExpr, @required thenExpr, @required elseExpr})
      : super('cond', AEList([ifExpr, thenExpr, elseExpr]));
}

/// `$ifNull` operator
///
/// Evaluates an [expression] and returns the value of the [expression] if the
/// [expression] evaluates to a non-null value. If the [expression] evaluates
/// to a null value, including instances of undefined values or missing fields,
/// returns the value of the [replacement] expression.
class IfNull extends Operator {
  /// Creates `$ifNull` operator expression
  IfNull(expression, replacement)
      : super('ifNull', AEList([expression, replacement]));
}

/// `$switch` operator
///
/// Evaluates a series of case expressions. When it finds an expression which
/// evaluates to true, $switch executes a specified expression and breaks out
/// of the control flow.
class Switch extends Operator {
  /// Creates `$switch` operator expression
  ///
  /// * [branches] - An array of control branch object. Each branch is an
  /// instance of [Case]
  /// * [defaultExpr] - Optional. The path to take if no branch case expression
  /// evaluates to true. Although optional, if default is unspecified and no
  /// branch case evaluates to true, $switch returns an error.
  Switch({required List<Case> branches, defaultExpr})
      : super(
            'switch',
            AEObject({
              'branches': AEList(branches),
              if (defaultExpr != null) 'default': defaultExpr
            }));
}

/// Case branch for [Switch] operator
class Case extends AEObject {
  /// Creates [Case] branch for Switch operator
  ///
  /// * [caseExpr] - Can be any valid expression that resolves to a boolean. If
  /// the result is not a boolean, it is coerced to a boolean value.
  /// * [thenExpr] - Can be any valid expression.
  Case({required AggregationExpr caseExpr, @required thenExpr})
      : super.internal({'case': caseExpr, 'then': thenExpr});
}
