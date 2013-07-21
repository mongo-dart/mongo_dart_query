part of mongo_dart_query;


ModifierBuilder get modify => new ModifierBuilder();

class ModifierBuilder{
  Map map = {};

  toString()=>"ModifierBuilder($map)";
  Map _pair2Map(String fieldName, value) {
    var res = {};
    res[fieldName] = value;
    return res;
  }
  ModifierBuilder inc(String fieldName,value) {
    map['\$inc'] = _pair2Map(fieldName,value);
    return this;
  }

  ModifierBuilder set(String fieldName,value) {
    Map setMap = map['\$set'];
    if (setMap == null) {
      setMap = {};
    }
    setMap[fieldName] = value;
    map['\$set'] = setMap;
    return this;
  }

  ModifierBuilder unset(String fieldName) {
    Map unSetMap = map['\$unset'];
    if (unSetMap == null) {
      unSetMap = {};
    }
    unSetMap[fieldName] = 1;
    map['\$unset'] = unSetMap;
    return this;
  }

  ModifierBuilder push(String fieldName, value) {
    map['\$push'] = _pair2Map(fieldName, value);
    return this;
  }

}
