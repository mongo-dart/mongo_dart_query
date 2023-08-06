import 'package:fixnum/fixnum.dart';
import 'package:mongo_dart_query/src/expression/basic_expression.dart';

import '../expression/common/document_types.dart';
import '../expression/common/operators_def.dart';
import '../expression/field_expression.dart';

UpdateExpression get modify => UpdateExpression();

class UpdateExpression {
  final _expression = MapExpression.empty();

  //UpdateDocument get raw => _expression.rawContent as UpdateDocument;
  MongoDocument get raw => _expression.rawContent;

  @override
  String toString() => 'UpdateExpression($_expression)';

  void _updateOperation(String operator, String fieldName, value) =>
      _expression.mergeExpression(OperatorExpression(
          operator, FieldExpression(fieldName, ValueExpression.create(value))));

  // ************************
  // *** Field operators

  /// Sets the value of a field to the current date, either as a Date
  /// or a timestamp. The default type is Date.
  void $currentDate(String fieldName, {bool asTimestamp = false}) =>
      _updateOperation(op$currentDate, fieldName,
          asTimestamp ? opTimeStampeTypeDoc : opDateTypeDoc);

  /// Increments the value of the field by the specified amount.
  void $inc(String fieldName, value) =>
      _updateOperation(op$inc, fieldName, value);

  /// Only updates the field if the specified value is less than
  /// the existing field value
  void $min(String fieldName, value) =>
      _updateOperation(op$min, fieldName, value);

  /// Only updates the field if the specified value is greater than the
  /// existing field value.
  void $max(String fieldName, value) =>
      _updateOperation(op$max, fieldName, value);

  /// Multiplies the value of the field by the specified amount
  void $mul(String fieldName, value) =>
      _updateOperation(op$mul, fieldName, value);

  void $rename(String oldName, String newName) =>
      _updateOperation(op$rename, oldName, newName);

  void $set(String fieldName, value) =>
      _updateOperation(op$set, fieldName, value);

  void $setOnInsert(String fieldName, value) =>
      _updateOperation(op$setOnInsert, fieldName, value);

  void $unset(String fieldName) => _updateOperation(op$unset, fieldName, 1);

  // ************************
  // *** Array operators

  /// Adds elements to an array only if they do not already exist in the set.
  void $addToSet(String fieldName, value) =>
      _updateOperation(op$addToSet, fieldName, value);

  void addEachToSet(String fieldName, List value) =>
      _updateOperation(op$addToSet, fieldName, {op$each: value});

  /// The popFirst operator removes the first element of an array.
  void popFirst(String fieldName) => _updateOperation(op$pop, fieldName, -1);

  /// The popLast operator removes the last element of an array.
  void popLast(String fieldName) => _updateOperation(op$pop, fieldName, 1);

  /// The pull operator removes from an existing array all instances
  /// of a value that match a specified condition.
  void $pull(String fieldName, value) =>
      _updateOperation(op$pull, fieldName, value);

  /// Adds an item to an array.
  void $push(String fieldName, value) =>
      _updateOperation(op$push, fieldName, value);

  /// append multiple values to an array <field>.
  void pushEach(String fieldName, List values,

          /// Specify the position in the array to add elements.
          {int? position,

          /// The $sort modifier orders the elements of an array.
          /// You can pass an empty array [] to the values parameter such that
          /// only the $sort modifier has an effect.
          int? sort,

          /// Alternative to the sort parameter.
          /// If the array elements are documents, to sort by a field in
          /// the documents, specify a sort document with the field and the
          /// direction, i.e. { field: 1 } or { field: -1 }.
          /// Do not reference the containing array field in the
          /// sort specification (e.g. { "arrayField.field": 1 } is incorrect).
          IndexDocument? sortDocument,

          /// limit the size of updated arrays
          int? slice}) =>
      _updateOperation(op$push, fieldName, {
        op$each: values,
        if (position != null) op$position: position,
        if (sort != null)
          op$sort: sort
        else if (sortDocument != null)
          op$sort: sortDocument,
        if (slice != null) op$slice: slice
      });

  /// The $pullAll operator removes all instances of the specified values
  /// from an existing array.
  /// Unlike the $pull operator that removes elements by specifying a query,
  /// $pullAll removes elements that match the listed values.
  void $pullAll(String fieldName, List values) =>
      _updateOperation(op$pullAll, fieldName, values);

  ///  performs a bitwise "and" update of a field
  void bitAnd(String fieldName, int value) =>
      _updateOperation(op$Bit, fieldName, {opBitAnd: value});

  ///  performs a bitwise "and" update of a field with a 64 bit int

  void bitAnd64(String fieldName, Int64 value) =>
      _updateOperation(op$Bit, fieldName, {opBitAnd: value});

  ///  performs a bitwise "or" update of a field
  void bitOr(String fieldName, int value) =>
      _updateOperation(op$Bit, fieldName, {opBitOr: value});

  ///  performs a bitwise "or" update of a field with a 64 bit int
  void bitOr64(String fieldName, Int64 value) =>
      _updateOperation(op$Bit, fieldName, {opBitOr: value});

  ///  performs a bitwise "xor" update of a field
  void bitXor(String fieldName, int value) =>
      _updateOperation(op$Bit, fieldName, {opBitXor: value});

  ///  performs a bitwise "xor" update of a field with a 64 bit int
  void bitXor64(String fieldName, Int64 value) =>
      _updateOperation(op$Bit, fieldName, {opBitXor: value});
}
