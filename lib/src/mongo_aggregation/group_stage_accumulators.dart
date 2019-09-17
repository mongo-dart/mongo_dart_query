import 'aggregation_base.dart';

/// `$addToSet` operator
class AddToSet extends Accumulator {
  /// Creates `$addToSet` operator expression
  ///
  /// Returns an array of all unique values that results from applying an
  /// expression to each document in a group of documents that share the
  /// same group by key. Order of the elements in the output array is
  /// unspecified.
  AddToSet(expr) : super('addToSet', expr);
}

/// `$avg` operator
class Avg extends Accumulator {
  /// Creates `$avg` operator expression
  ///
  /// Returns the average value of the numeric values. $avg ignores non-numeric values.
  Avg(expr) : super('avg', expr is List ? AEList(expr) : expr);
}

/// `$first` operator
class First extends Accumulator {
  /// Creates `$first` operator expression
  ///
  /// Returns the value that results from applying an expression to the first
  /// document in a group of documents that share the same group by key. Only
  /// meaningful when documents are in a defined order.
  First(expr) : super('first', expr);
}

/// `$last` operator
class Last extends Accumulator {
  /// Creates `$last` operator expression
  ///
  /// Returns the value that results from applying an expression to the last
  /// document in a group of documents that share the same group by a field.
  /// Only meaningful when documents are in a defined order.
  Last(expr) : super('last', expr);
}

/// `$max` operator
class Max extends Accumulator {
  /// Creates `$max` operator expression
  ///
  /// Returns the maximum value. `$max` compares both value and type, using the
  /// specified BSON comparison order for values of different types.
  Max(expr) : super('max', expr is List ? AEList(expr) : expr);
}

/// `$min` operator
class Min extends Accumulator {
  /// Creates `$min` operator expression
  ///
  /// Returns the minimum value. `$min` compares both value and type, using the
  /// specified BSON comparison order for values of different types.
  Min(expr) : super('min', expr is List ? AEList(expr) : expr);
}

/// `$push` operator
class Push extends Accumulator {
  /// Creates `$push` operator expression
  ///
  /// Returns an array of all values that result from applying an expression to
  /// each document in a group of documents that share the same group by key.
  Push(expr) : super('push', expr);

  /// Creates `$push` operator expression
  ///
  /// More readable way to create `Push(AEList([...]))`
  Push.list(List list) : super('push', AEList(list));

  /// Creates `$push` operator expression
  ///
  /// More readable way to create `Push(AOBject({...}))`
  Push.object(Map<String, dynamic> object) : super('push', AEObject(object));
}

/// `$stdDevPop` operator
class StdDevPop extends Accumulator {
  /// Creates `$stdDevPop` operator expression
  ///
  /// Calculates the population standard deviation of the input values. Use if
  /// the values encompass the entire population of data you want to represent
  /// and do not wish to generalize about a larger population. `$stdDevPop` ignores
  /// non-numeric values.
  StdDevPop(expr) : super('stdDevPop', expr is List ? AEList(expr) : expr);
}

/// `$stdDevSamp` operator
class StdDevSamp extends Accumulator {
  /// Creates `$stdDevSamp` operator expression
  ///
  /// Calculates the sample standard deviation of the input values. Use if the
  /// values encompass a sample of a population of data from which to generalize
  /// about the population. $stdDevSamp ignores non-numeric values.
  StdDevSamp(expr) : super('stdDevSamp', expr is List ? AEList(expr) : expr);
}

/// `$sum` operator
class Sum extends Accumulator {
  /// Creates `$sum` operator expression
  ///
  /// Calculates and returns the sum of numeric values. $sum ignores non-numeric
  /// values.
  Sum(expr) : super('sum', expr is List ? AEList(expr) : expr);
}
