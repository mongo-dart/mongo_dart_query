import 'package:mongo_dart_query/src/query_expression/filter_expression.dart';

import 'basic_expression.dart';
import 'common/document_types.dart';
import 'common/operators_def.dart';

class NotExpression extends OperatorExpression {
  NotExpression(OperatorExpression operatorExp) : super(op$Not, operatorExp);
}

class LogicalExpression extends OperatorExpression<ListExpression> {
  LogicalExpression(String operator, ListExpression value)
      : super(operator, value);
  bool get isEmpty => content.isEmpty;
  bool get isNotEmpty => content.isNotEmpty;
}

class AndExpression extends LogicalExpression {
  AndExpression([List<ExpressionContent>? values])
      : super(op$And, ListExpression(values ?? <ExpressionContent>[]));

  void add(ExpressionContent operatorExp) {
    var keyList = content.keysList;
    if (keyList == null) {
      content.add(operatorExp);
      return;
    }
    if (operatorExp is Expression) {
      if (keyList.contains(operatorExp.key)) {
        var index = keyList.indexOf(operatorExp.key);
        content.mergeAtElement(operatorExp, index);
      } else {
        content.add(operatorExp);
      }
      return;
    } else if (operatorExp is FilterExpression) {
      content.add(ValueExpression.create(operatorExp.rawContent));
      return;
    } else if (operatorExp is MapExpression) {
      content.add(operatorExp);
      return;
    } else if (operatorExp is ListExpression) {
      for (var entry in operatorExp.content2map.entries) {
        if (keyList.contains(entry.key)) {
          var index = keyList.indexOf(entry.key);
          content.mergeAtElement(MapExpression(entry.value), index);
        } else {
          content.add(MapExpression({entry.key: entry.value}));
        }
      }
      return;
    }
    content.add(operatorExp);
  }

  @override
  MongoDocument get raw =>
      {if (content.canBeSimplified) ...content.content2map else ...super.raw};
}

class OrExpression extends LogicalExpression {
  OrExpression([List<ExpressionContent>? values])
      : super(op$Or, ListExpression(values ?? <ExpressionContent>[]));
  void add(ExpressionContent operatorExp) => content.add(operatorExp);
}

class NorExpression extends LogicalExpression {
  NorExpression([List<ExpressionContent>? values])
      : super(op$Nor, ListExpression(values ?? <ExpressionContent>[]));
  void add(ExpressionContent operatorExp) => content.add(operatorExp);
}
