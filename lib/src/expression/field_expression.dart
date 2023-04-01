import 'basic_expression.dart';

class FieldExpression extends Expression {
  FieldExpression(String fieldName, value) : super(fieldName, value);
  String get fieldName => entry.key;
}
