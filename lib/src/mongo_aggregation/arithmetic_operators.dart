import 'aggregation_base.dart';

/// `$abs` operator
///
/// Returns the absolute value of an [expr]
class Abs extends Operator {
  /// Creates an `$abs` operator expression
  Abs(dynamic expr) : super('abs', expr);
}

/// `$add` operator
///
/// Adds numbers together or adds numbers and a date. If one of the arguments is
/// a date, `$add` treats the other arguments as milliseconds to add to the date.
class Add extends Operator {
  /// Creates an `$add` operator expression
  Add(List args) : super('add', AEList(args));
}

/// `$ceil` operator
///
/// Returns the smallest integer greater than or equal to the specified number.
class Ceil extends Operator {
  /// Creates `$ceil` operator expression
  Ceil(dynamic expr) : super('ceil', expr);
}

/// `$divide` operator
///
/// Divides one number by another and returns the result.
class Divide extends Operator {
  /// Creates `$divide` operator expression
  Divide(dynamic dividend, dynamic divisor)
      : super('divide', AEList([dividend, divisor]));
}

/// `$exp` operator
///
/// Raises Euler’s number (i.e. `e` ) to the specified exponent and returns the
/// result.
class Exp extends Operator {
  /// Creates `$exp` operator expression
  Exp(dynamic expr) : super('exp', expr);
}

/// `$floor` operator
///
/// Returns the largest integer less than or equal to the specified number.
class Floor extends Operator {
  /// Creates `$floor` operator expression
  Floor(dynamic expr) : super('floor', expr);
}

/// `$ln` operator
///
/// Calculates the natural logarithm `ln` of a number and returns the result as
/// a double.
class Ln extends Operator {
  /// Creates `$ln` operator expression
  Ln(dynamic expr) : super('ln', expr);
}

/// `$log` operator
///
/// Calculates the `log` of an [expr] in the specified [base] and returns the
/// result as a double.
class Log extends Operator {
  /// Creates `$log` operator expression
  Log(dynamic expr, base) : super('log', AEList([expr, base]));
}

/// `$log10` operator
///
/// Calculates the `log` base 10 of an [expr] and returns the result as a
/// double.
class Log10 extends Operator {
  /// Creates `$log10` operator expression
  Log10(dynamic expr) : super('log10', expr);
}

/// `$mod` operator
///
/// Divides one number by another and returns the remainder.
class Mod extends Operator {
  /// Creates `$mod` operator expression
  Mod(dynamic dividend, dynamic divisor)
      : super('mod', AEList([dividend, divisor]));
}

/// `$multiply` operator
///
/// Multiplies numbers together and returns the result. Pass the arguments to
/// `$multiply` in an array.
class Multiply extends Operator {
  /// Creates `$multiply` operator expression
  Multiply(List args) : super('multiply', AEList(args));
}

/// `$pow` operator
///
/// Raises an [expr] to the specified [exponent] and returns the result.
class Pow extends Operator {
  /// Creates `$pow` operator expression
  Pow(dynamic expr, dynamic exponent) : super('pow', AEList([expr, exponent]));
}

/// `$round` operator
///
/// Rounds an [expr] to to a whole integer or to a specified decimal [place].
class Round extends Operator {
  /// Creates `$round` operator expression
  Round(dynamic expr, [place]) : super('round', AEList([expr, place]));
}

/// `$sqrt` operator
///
/// Calculates the square root of a positive number and returns the result as a
/// double.
class Sqrt extends Operator {
  /// Creates `$sqrt` operator expression
  Sqrt(dynamic expr) : super('sqrt', expr);
}

/// `$subtract` operator
///
/// Subtracts two numbers to return the difference, or two dates to return the
/// difference in milliseconds, or a date and a number in milliseconds to return
/// the resulting date.
class Subtract extends Operator {
  /// Creates `$subtract` operator expression
  Subtract(dynamic minuend, dynamic subtrahend)
      : super('subtract', AEList([minuend, subtrahend]));
}

/// `$trunc` operator
///
/// Truncates an [expr] to a whole integer or to a specified decimal [place].
class Trunc extends Operator {
  /// Creates `$trunc` operator expression
  Trunc(dynamic expr, [place]) : super('trunc', AEList([expr, place]));
}
