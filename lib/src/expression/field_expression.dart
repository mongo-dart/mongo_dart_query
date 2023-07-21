import 'basic_expression.dart';

class FieldExpression<T extends ExpressionContent> extends Expression {
  FieldExpression(String fieldName, T value) : super(fieldName, value);
  String get fieldName => entry.key;
}
