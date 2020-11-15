import 'package:meta/meta.dart';

import 'aggregation_base.dart';

/// `$arrayElemAt` operator
///
/// Returns the element at the specified [array] [index].
class ArrayElemAt extends Operator {
  /// Creates `$arrayToObject` operator expression
  ArrayElemAt(array, index) : super('arrayElemAt', AEList([array, index]));
}

/// `$arrayToObject` operator
///
/// Converts an array into a single document; the array must be either:
///
/// an array of two-element arrays where the first element is the field name,
/// and the second element is the field value:
/// ```
/// [ [ "item", "abc123"], [ "qty", 25 ] ]
/// ```
/// or
///
/// an array of documents that contains two fields, `k` and `v` where:
///
/// * The `k` field contains the field name.
/// * The `v` field contains the value of the field.
class ArrayToObject extends Operator {
  /// Creates `$arrayToObject` operator expression
  ArrayToObject(array)
      : super('arrayToObject', array is List ? AEList(array) : array);
}

/// `$concatArrays` operator
///
/// Concatenates [arrays] to return the concatenated array.
class ConcatArrays extends Operator {
  /// Creates `$concatArrays` operator expression
  ConcatArrays(List arrays)
      : super('concatArrays',
            AEList(arrays.map((elem) => elem is List ? AEList(elem) : elem)));
}

/// `$filter` operator
///
/// Selects a subset of an array to return based on the specified condition.
/// Returns an array with only those elements that match the condition. The
/// returned elements are in the original order.
class Filter extends Operator {
  /// Creates `$filter` operator expression
  ///
  /// * [input] - an expression that resolves to an array.
  /// * [as] - Optional. A name for the variable that represents each individual
  /// element of the input array. If no name is specified, the variable name
  /// defaults to `this`.
  /// * [cond] - An expression that resolves to a boolean value used to determine
  /// if an element should be included in the output array. The expression
  /// references each element of the input array individually with the variable
  /// name specified in [as].
  Filter({required input, String? as, required cond})
      : super('filter',
            AEObject({'input': input, if (as != null) 'as': as, 'cond': cond}));
}

/// `$in` operator
///
/// Returns a boolean indicating whether a specified [value] is in an [array].
class In extends Operator {
  /// Creates `$in` operator expression
  In(value, array)
      : super('in', AEList([value, array is List ? AEList(array) : array]));
}

/// `$indexOfArray` operator
///
/// Searches an [array] for an occurence of a specified [value] and returns the
/// array index (zero-based) of the first occurence. If the value is not found,
/// returns `-1`.
class IndexOfArray extends Operator {
  /// Creates `$indexOfArray` operator expression
  ///
  /// * [array] - Can be any valid expression as long as it resolves to an array.
  /// * [value] - Can be any valid expression.
  /// * [start] - Optional. An integer, or a number that can be represented as
  /// integers (such as 2.0), that specifies the starting index position for the
  /// search. Can be any valid expression that resolves to a non-negative integral
  /// number. If unspecified, the starting index position for the search is the
  /// first element.
  IndexOfArray(array, value, start, end)
      : super('indexOfArray',
            AEList([array is List ? AEList(array) : array, value, start, end]));
}

/// `$isArray` operator
///
/// Determines if the operand is an array. Returns a boolean.
class IsArray extends Operator {
  /// Creates `$isArray` operator expression
  IsArray(expr) : super('isArray', expr);
}

/// `$map` operator
///
/// Applies an expression to each item in an array and returns an array with the
/// applied results.
/// name specified in [as].
class MapOp extends Operator {
  /// Creates `$map` operator expression
  ///
  /// * [input] - 	An expression that resolves to an array.
  /// * [as] - Optional. A name for the variable that represents each individual
  /// element of the input array. If no name is specified, the variable name
  /// defaults to `this`.
  /// * [inExpr] - An expression that is applied to each element of the input
  /// array. The expression references each element individually with the variable
  MapOp({@required input, String? as, @required inExpr})
      : super(
            'map',
            AEObject({
              'input': input is List ? AEList(input) : input,
              if (as != null) 'as': as,
              'in': inExpr
            }));
}

/// `$objectToArray`
///
/// Converts a document to an array. The return array contains an element for
/// each field/value pair in the original document. Each element in the return
/// array is a document that contains two fields `k` and `v`:
///
/// * The `k` field contains the field name in the original document.
/// * The `v` field contains the value of the field in the original document.
class ObjectToArray extends Operator {
  /// Creates `$objectToArray` operator expression
  ObjectToArray(expr)
      : super('objectToArray',
            expr is Map<String, dynamic> ? AEObject(expr) : expr);
}

/// `$range` operator
///
/// Returns an array whose elements are a generated sequence of numbers. `$range`
/// generates the sequence from the specified starting number by successively
/// incrementing the starting number by the specified step value up to but not
/// including the end point.
class Range extends Operator {
  /// Creates `$range` operator expression
  ///
  /// * [start] - An integer that specifies the start of the sequence. Can be any
  /// valid expression that resolves to an integer.
  /// * [end] - An integer that specifies the exclusive upper limit of the sequence.
  /// Can be any valid expression that resolves to an integer.
  /// * [step] - Optional. An integer that specifies the increment value. Can be
  /// any valid expression that resolves to a non-zero integer. Defaults to 1.
  Range(start, end, [step]) : super('range', AEList([start, end, step]));
}

/// `$reduce` operator
///
/// Applies an expression to each element in an array and combines them into a
/// single value.
class Reduce extends Operator {
  /// Creates `$reduce` operator expression
  ///
  /// * [input] - Can be any valid expression that resolves to an array. If the
  /// argument resolves to a value of null or refers to a missing field, $reduce
  /// returns null. If the argument does not resolve to an array or null nor refers
  /// to a missing field, `$reduce` returns an error.
  /// * [initialValue] - The initial cumulative value set before [inExpr] is applied to
  /// the first element of the input array.
  /// * [inExpr] - A valid expression that $reduce applies to each element in the
  /// input array in left-to-right order. Wrap the input value with $reverseArray
  /// to yield the equivalent of applying the combining expression from right-to-left.
  /// During evaluation of the in expression, two variables will be available:
  ///
  /// * `value` is the variable that represents the cumulative value of the expression.
  /// * `this` is the variable that refers to the element being processed.
  Reduce({@required input, @required initialValue, @required inExpr})
      : super(
            'reduce',
            AEObject(
                {'input': input, 'initialValue': initialValue, 'in': inExpr}));
}

/// `$reverseArray` operator
///
/// Accepts an array expression as an argument and returns an array with the
/// elements in reverse order.
class ReverseArray extends Operator {
  /// Creates `$reverseArray` operator expression
  ReverseArray(array)
      : super('reverseArray', array is List ? AEList(array) : array);
}

/// `$size` operator
///
/// Counts and returns the total the number of items in an array.
class Size extends Operator {
  /// Creates `$size` operator expression
  Size(array) : super('size', array is List ? AEList(array) : array);
}

/// `$slice` operator
///
/// Returns a subset of an array.
class Slice extends Operator {
  /// Creates `$slice` operator expression
  ///
  /// * [array] - Any valid expression as long as it resolves to an array.
  /// * [position] - Optional. Any valid expression as long as it resolves to an
  /// integer.
  ///
  ///   * If positive, `$slice` determines the starting position from the start of
  /// the array. If [position] is greater than the number of elements, the `$slice`
  /// returns an empty array.
  ///   *If negative, `$slice` determines the starting position from the end of the
  /// array. If the absolute value of the [position] is greater than the number of
  /// elements, the starting position is the start of the array.
  /// * [n] - Any valid expression as long as it resolves to an integer. If
  /// [position] is specified, [n] must resolve to a positive integer.
  ///
  ///   * If positive, $slice returns up to the first n elements in the array. If
  /// the [position] is specified, `$slice` returns the first n elements starting
  /// from the position.
  ///   * If negative, `$slice` returns up to the last `n` elements in the array. [n]
  /// cannot resolve to a negative number if [position] is specified
  Slice(array, n, [position])
      : super('slice',
            AEList([array is List ? AEList(array) : array, position, n]));
}

/// `$zip` operator
///
/// Transposes an array of input arrays so that the first element of the output
/// array would be an array containing, the first element of the first input
/// array, the first element of the second input array, etc.
///
/// For example, $zip would transform `[ [ 1, 2, 3 ], [ "a", "b", "c" ] ]` into
/// `[ [ 1, "a" ], [ 2, "b" ], [ 3, "c" ] ]`.
class Zip extends Operator {
  /// Creates `$zip` operator expression
  ///
  /// * [inputs] - An array of expressions that resolve to arrays. The elements
  /// of these input arrays combine to form the arrays of the output array.
  /// If any of the inputs arrays resolves to a value of null or refers to a
  /// missing field, $zip returns null. If any of the inputs arrays does not
  /// resolve to an array or null nor refers to a missing field, $zip returns an
  /// error.
  /// * [useLongestLength] - A boolean which specifies whether the length of the
  /// longest array determines the number of arrays in the output array. The
  /// default value is false: the shortest array length determines the number of
  /// arrays in the output array.
  /// * [defaults] - An array of default element values to use if the input arrays
  /// have different lengths. You must specify useLongestLength: true along with
  /// this field, or else `$zip` will return an error. If [useLongestLength]:
  /// `true` but [defaults] is empty or not specified, `$zip` uses `null` as the
  /// default value. If specifying a non-empty [defaults], you must specify a
  /// default for each input array or else `$zip` will return an error.
  Zip({required List inputs, bool useLongestLength = false, List? defaults})
      : super(
            'zip',
            AEObject({
              'inputs': AEList(
                  inputs.map((elem) => elem is List ? AEList(elem) : elem)),
              'useLongestLength': useLongestLength,
              if (defaults != null && defaults.isNotEmpty)
                'defaults': AEList(defaults)
            }));
}

/// `$mergeObjects` operator
///
/// Combines multiple documents into a single document.
///
/// * When used as a `$group` stage accumulator, `$mergeObjects` has the
/// following form:
/// ```
/// { $mergeObjects: <document> }
/// ```
/// * When used in other expressions, including in the $group stage but not as
/// an accumulator:
/// ```
/// { $mergeObjects: [ <document1>, <document2>, ... ] }
/// ```
/// The <document> can be any valid expression that resolves to a document.
class MergeObjects extends Accumulator {
  /// Creates `$mergeObjects` operator expression
  MergeObjects(objects)
      : super(
            'mergeObjects',
            objects is List
                ? AEList(objects.map(
                    (obj) => obj is Map<String, dynamic> ? AEObject(obj) : obj))
                : objects);
}
