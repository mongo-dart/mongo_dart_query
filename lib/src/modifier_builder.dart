part of mongo_dart_query;


ModifierBuilder get modify => new ModifierBuilder();

class ModifierBuilder{
  
  Map<String, dynamic> map = {};

  toString() => "ModifierBuilder($map)";

  void _updateOperation(String operator, String fieldName, value) {
    Map<String, dynamic> opMap = map[operator];
    if (opMap == null) {
      opMap = <String, dynamic>{};
      map[operator] = opMap;
    }
    opMap[fieldName] = value;
  }
  
  ModifierBuilder inc(String fieldName, value) {
    _updateOperation('\$inc', fieldName, value);
    return this;
  }
  
  ModifierBuilder min(String fieldName, value) {
    _updateOperation('\$min', fieldName, value);
    return this;
  }
  
  ModifierBuilder max(String fieldName, value) {
    _updateOperation('\$max', fieldName, value);
    return this;
  }
  
  ModifierBuilder rename(String oldName, String newName) {
    _updateOperation('\$rename', oldName, newName);
    return this;
  }

  ModifierBuilder set(String fieldName, value) {
    _updateOperation('\$set', fieldName, value);
    return this;
  }
  
  ModifierBuilder setOnInsert(String fieldName, value) {
    _updateOperation('\$setOnInsert', fieldName, value);
    return this;
  }

  ModifierBuilder unset(String fieldName) {
    _updateOperation('\$unset', fieldName, 1);
    return this;
  }

  ModifierBuilder push(String fieldName, value) {
    _updateOperation('\$push', fieldName,value);
    return this;
  }
  
  ModifierBuilder pushAll(String fieldName, List values) {
    _updateOperation('\$pushAll', fieldName, values);
    return this;
  }
  
  ModifierBuilder pull(String fieldName, value) {
    _updateOperation('\$pull', fieldName,value);
    return this;
  }
  
  ModifierBuilder pullAll(String fieldName, List values) {
    _updateOperation('\$pullAll', fieldName, values);
    return this;
  }
  
  ModifierBuilder addToSet(String fieldName, value) {
    _updateOperation('\$addToSet', fieldName,value);
    return this;
  }
  
  ModifierBuilder popFirst(String fieldName) {
    _updateOperation('\$pop', fieldName, -1);
    return this;
  }
  
  ModifierBuilder popLast(String fieldName) {
    _updateOperation('\$pop', fieldName, 1);
    return this;
  }

}
