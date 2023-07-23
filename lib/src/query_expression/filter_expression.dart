import '../expression/basic_expression.dart';
import '../expression/common/document_types.dart';
import '../expression/field_expression.dart';
import '../expression/logical_expression.dart';

enum LogicType { and, or, nor }

// a = 5 and b = 6 or a = 7 and (b = 9 or c = 4) or c = 2

class FilterExpression extends MapExpression {
  //FilterExpression({this.level = 0}) : super(op$And, ListExpression.empty());
  FilterExpression({this.level = 0}) : super.empty();

  LogicType? logicType;
  int level = 0;

  /// Or or Nor Nodes int the top level
  bool topNodes = false;
  bool expressionProcessed = false;
  final /* List<Expression> */ _sequence = <ExpressionContent>[];
  FilterExpression? _openChild;

  bool get isOpenSublevel => _openChild != null;
  bool get notEmpty => _sequence.isNotEmpty;
  MongoDocument get content => valueMap;

  @override
  MongoDocument get rawContent {
    if (isOpenSublevel) {
      _sequence.add(MapExpression(_openChild!.rawContent));
      _openChild = null;
      expressionProcessed = false;
    }
    if (!expressionProcessed) {
      processExpression();
    }
    //return key == op$And ? content.mergeContent2map : super.raw;
    return content;
  }

  // TODO Revert after debug
  //@override
  //String toString() => 'UpdateExpression($raw)';

  // TODO check
  void processExpression() {
    LogicalExpression? actualContainer;
    expressionProcessed = true;
    for (var element in _sequence) {
      if (element is AndExpression) {
        if (actualContainer == null) {
          actualContainer = element;
          continue;
        } else if (actualContainer is AndExpression) {
          actualContainer.add(element.content);
        } else if (actualContainer is OrExpression) {
          actualContainer.add(element.content);
        } else if (actualContainer is NorExpression) {
          actualContainer.add(element.content);
        }
      } else if (element is OrExpression) {
        if (actualContainer == null) {
          actualContainer = element;
          continue;
        } else if (actualContainer is AndExpression) {
          element.add(actualContainer.content);
          actualContainer = element;
        } else if (actualContainer is OrExpression) {
          actualContainer.add(element.content);
        } else if (actualContainer is NorExpression) {
          element.add(actualContainer.content);
          actualContainer = element;
        }
      } else if (element is NorExpression) {
        if (actualContainer == null) {
          actualContainer = element;
          continue;
        } else if (actualContainer is AndExpression) {
          element.add(actualContainer.content);
          actualContainer = element;
        } else if (actualContainer is NorExpression) {
          actualContainer.add(element.content);
        } else if (actualContainer is OrExpression) {
          element.add(actualContainer.content);
          actualContainer = element;
        }
      } else {
        if (actualContainer == null) {
          //content.addAll(element.raw);
          actualContainer = AndExpression()..add(element);
        } else if (actualContainer is AndExpression) {
          actualContainer.add(element);
        } else if (actualContainer is OrExpression) {
          if (actualContainer.content.values.last is AndExpression) {
            (actualContainer.content.values.last as AndExpression).add(element);
          } else {
            actualContainer.add(AndExpression([element]));
          }
        } else if (actualContainer is NorExpression) {
          if (actualContainer.content.values.last is AndExpression) {
            (actualContainer.content.values.last as AndExpression).add(element);
          } else {
            actualContainer.add(element);
          }
        }
      }
    }
    content.addAll(actualContainer?.raw ?? emptyMongoDocument);
  }

  void addDocument(MongoDocument document) {
    for (var element in document.entries) {
      if (element.key.startsWith(r'$')) {
        _sequence.add(OperatorExpression(
            element.key, ValueExpression.create(element.value)));
      } else {
        _sequence.add(FieldExpression(
            element.key, ValueExpression.create(element.value)));
      }
    }
  }

  void addFieldOperator(FieldExpression expression) => isOpenSublevel
      ? _openChild!.addFieldOperator(expression)
      : _sequence.add(expression);

  void addOperator(OperatorExpression expression) {
    if (isOpenSublevel) {
      _openChild!.addOperator(expression);
      return;
    }
    assert(expression is! LogicalExpression,
        'Here should not be a Logical Expression');
    _sequence.add(expression);
  }

  void get open {
    if (isOpenSublevel) {
      return _openChild!.open;
    }
    _openChild = FilterExpression(level: level + 1);
  }

  void get close {
    if (isOpenSublevel && _openChild!.isOpenSublevel) {
      return _openChild!.close;
    }
    if (_openChild == null) {
      throw StateError('No open parenthesis found');
    }
    if (_openChild!.notEmpty) {
      _openChild!.processExpression();
      _sequence.add(_openChild!);
    }

    _openChild = null;
  }

  void logicAnd() {
    if (isOpenSublevel) {
      return _openChild!.logicAnd();
    }
    // if the previous is a logical expression or there is no previous
    // expression, ignore it.
    var andExp = AndExpression();
    while (_sequence.isNotEmpty) {
      var last = _sequence.removeLast();
      if (last is OrExpression || last is NorExpression) {
        if (andExp.isNotEmpty) {
          (last as LogicalExpression).content.add(andExp);
          andExp = AndExpression();
          _sequence.add(last);
          break;
        }
      }
      if (last is AndExpression) {
        if (andExp.isNotEmpty) {
          last.add(andExp.content);
        }
        andExp = last;
      } else {
        andExp.add(last);
      }
    }
    if (andExp.isEmpty) {
      return;
    }
    //if (key == op$And) {
    //  content.add(andExp.content);
    //  return;
    //}
    _sequence.add(andExp);
  }

  void logicOr() {
    if (isOpenSublevel) {
      return _openChild!.logicOr();
    }
    // if the previous is a logical expression or there is no previous
    // expression, ignore it.
    if (_sequence.isEmpty || _sequence.last is OrExpression) {
      return;
    }
    var orExp = OrExpression();
    var tempAndExp = AndExpression();
    while (_sequence.isNotEmpty) {
      var last = _sequence.removeLast();
      if (last is OrExpression) {
        if (orExp.isNotEmpty) {
          last.add(orExp.content);
        }
        orExp = last;
      } else {
        tempAndExp.add(last);
      }
    }
    if (tempAndExp.isNotEmpty) {
      //if (tempAndExp.content.values.length == 1) {
      orExp.add(MapExpression(tempAndExp.content.content2map));
      //} else {
      //  orExp.add(tempAndExp);
      //}
    }
    if (orExp.isEmpty) {
      return;
    }
    //if (key == op$And) {
    //  content.add(andExp.content);
    //  return;
    //}
    _sequence.add(orExp);
  }

  void logicNor() {
    if (isOpenSublevel) {
      return _openChild!.logicNor();
    }
    // if the previous is a logical expression or there is no previous
    // expression, ignore it.
    if (_sequence.isEmpty || _sequence.last is LogicalExpression) {
      return;
    }
  }
}
