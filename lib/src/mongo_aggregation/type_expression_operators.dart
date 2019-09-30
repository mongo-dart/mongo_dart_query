import 'package:meta/meta.dart';

import 'aggregation_base.dart';

/// `$convert` operator
class Convert extends Operator {
  /// Creates `$convert` operator expression
  ///
  /// The argument can be any expression as long as it resolves to a string.
  ///
  /// * [input] - The argument can be any valid expression.
  /// * [to] - The argument can be any valid expression that resolves to one of
  /// the following numeric or string identifiers:
  ///   * 'double'
  ///   * 'string'
  ///   * 'objectId'
  ///   * 'bool'
  ///   * 'date'
  ///   * 'int'
  ///   * 'long'
  ///   * 'decimal'
  /// * [onError] - Optional. The value to return on encountering an error during
  /// conversion, including unsupported type conversions. The arguments can be
  /// any valid expression. If unspecified, the operation throws an error upon
  /// encountering an error and stops.
  /// * [onNull] - Optional. The value to return if the input is null or missing.
  /// The arguments can be any valid expression. If unspecified, `$convert` returns
  /// `null` if the input is null or missing.
  Convert({@required input, @required to, onError, onNull})
      : super(
            'convert',
            AEObject({
              'input': input,
              'to': to,
              'onError': onError,
              'onNull': onNull
            }));
}

/// `$toBool` operator
class ToBool extends Operator {
  /// Creates `$toBool` operator expression
  ///
  /// Converts a value to a boolean.
  ///
  /// The [ToBool] takes any valid expression.
  ToBool(expr) : super('toBool', expr);
}

/// `$toDecimal` operator
class ToDecimal extends Operator {
  /// Creates `$toDecimal` operator expression
  ///
  /// Converts a value to a decimal. If the value cannot be converted to a
  /// decimal, `$toDecimal` errors. If the value is `null` or missing,
  /// `$toDecimal` returns `null`.
  ///
  /// The [ToDecimal] takes any valid expression.
  ToDecimal(expr) : super('toDecimal', expr);
}

/// `$toDouble` operator
class ToDouble extends Operator {
  /// Creates `$toDouble` operator expression
  ///
  /// Converts a value to a double. If the value cannot be converted to an
  /// double, `$toDouble` errors. If the value is `null` or missing, `$toDouble`
  /// returns `null`.
  ///
  /// The [ToDouble] takes any valid expression.
  ToDouble(expr) : super('toDouble', expr);
}

/// `$toInt` operator
class ToInt extends Operator {
  /// Creates `$toInt` operator expression
  ///
  /// Converts a value to an integer. If the value cannot be converted to an
  /// integer, `$toInt` errors. If the value is `null` or missing, `$toInt`
  /// returns `null`.
  ///
  /// The [ToInt] takes any valid expression.
  ToInt(expr) : super('toInt', expr);
}

/// `$toLong` operator
class ToLong extends Operator {
  /// Creates `$toLong` operator expression
  ///
  /// Converts a value to a long. If the value cannot be converted to a long,
  /// `$toLong` errors. If the value is `null` or missing, `$toLong` returns
  /// `null`.
  ///
  /// The [ToLong] takes any valid expression.
  ToLong(expr) : super('toLong', expr);
}

/// `$toObjectId` operator
class ToObjectId extends Operator {
  /// Creates `$toObjectId` operator expression
  ///
  /// Converts a value to an ObjectId. If the value cannot be converted to an
  /// `ObjectId`, `$toObjectId` errors. If the value is `null` or missing,
  /// `$toObjectId` returns `null`.
  ///
  /// The [ToObjectId] takes any valid expression.
  ToObjectId(expr) : super('toObjectId', expr);
}

/// `$type` operator
class Type extends Operator {
  /// Creates `$type` operator expression
  ///
  /// Returns a string that specifies the BSON type of the argument.
  ///
  /// The argument can be any valid expression.
  Type(expr) : super('type', expr);
}
