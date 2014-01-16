part of mongo_dart_query;

SelectorBuilder get where => new SelectorBuilder();

class SelectorBuilder{
  static final RegExp objectIdRegexp = new RegExp(".ObjectId...([0-9a-f]{24})....");
  Map map = {};
  bool _isQuerySet = false;
  Map get _query {
    if (!_isQuerySet) {
      map['\$query'] = {};
      _isQuerySet = true;
    }
    return map['\$query'];
  }
  int paramSkip = 0;
  int paramLimit = 0;
  Map paramFields;

  String toString()=>"SelectorBuilder($map)";

  _addExpression(String fieldName, value) {
    Map exprMap = {};
    exprMap[fieldName] = value;
    if (_query.isEmpty) {
      _query[fieldName] = value;
    } else {
      _addExpressionMap(exprMap);
    }
  }
  _addExpressionMap(Map expr) {
    if (_query.containsKey('\$and')) {
      List expressions = _query['\$and'];
      expressions.add(expr);
    } else {
      var expressions = [_query];
      expressions.add(expr);
      map['\$query'] = {'\$and': expressions};
    }
  }

  SelectorBuilder eq(String fieldName,value){
    _addExpression(fieldName,value);
    return this;
  }
  SelectorBuilder id(ObjectId value){
    _addExpression('_id', value);
    return this;
  }
  SelectorBuilder ne(String fieldName, value){
    _addExpression(fieldName,{"\$ne":value});
    return this;
  }
  SelectorBuilder gt(String fieldName,value){
    _addExpression(fieldName,{"\$gt":value});
    return this;
  }
  SelectorBuilder lt(String fieldName,value){
    _addExpression(fieldName,{"\$lt":value});
    return this;
  }
  SelectorBuilder gte(String fieldName,value){
    _addExpression(fieldName,{"\$gte":value});
    return this;
  }
  SelectorBuilder lte(String fieldName,value){
    _addExpression(fieldName,{"\$lte":value});
    return this;
  }
  SelectorBuilder all(String fieldName, List values){
    _addExpression(fieldName,{"\$all":values});
    return this;
  }
  SelectorBuilder nin(String fieldName, List values){
    _addExpression(fieldName,{"\$nin":values});
    return this;
  }
  SelectorBuilder oneFrom(String fieldName, List values){
    _addExpression(fieldName,{"\$in":values});
    return this;
  }
  SelectorBuilder exists(String fieldName){
    _addExpression(fieldName,{"\$exists":true});
    return this;
  }
  SelectorBuilder notExists(String fieldName){
    _addExpression(fieldName,{"\$exists":false});
    return this;
  }
  SelectorBuilder mod(String fieldName, int value){
    _addExpression(fieldName,{"\$mod":[value,0]});
    return this;
  }
  SelectorBuilder match(String fieldName, String pattern,{bool multiLine, bool caseInsensitive, bool dotAll, bool extended}){
    _addExpression(fieldName,{'\$regex': new BsonRegexp(pattern,multiLine:multiLine, caseInsensitive:caseInsensitive,
        dotAll:dotAll,extended:extended)});
    return this;
  }
  
  SelectorBuilder inRange(String fieldName, min, max, {bool minInclude: true, bool maxInclude: false}) {
    Map rangeMap = {};
    if (minInclude){
      rangeMap["\$gte"] = min;
    }
    else{
      rangeMap["\$gt"] = min;
    }
    if (maxInclude){
      rangeMap["\$lte"] = max;
    }
    else{
      rangeMap["\$lt"] = max;
    }
    _addExpression(fieldName,rangeMap);
    return this;
  }
  SelectorBuilder sortBy(String fieldName, {bool descending: false}){
    _query;
    if (!map.containsKey("orderby")){
      map["orderby"] = new LinkedHashMap();
    }
    int order = 1;
    if (descending){
      order = -1;
    }
    map["orderby"][fieldName] = order;
    return this;
  }
  SelectorBuilder hint(String fieldName, {bool descending: false}){
    _query;
    if (!map.containsKey("\$hint")){
      map["\$hint"] = new LinkedHashMap();
    }
    int order = 1;
    if (descending){
      order = -1;
    }
    map["\$hint"][fieldName] = order;
    return this;
  }
  
  SelectorBuilder comment(String commentStr){
    _query;
    map["\$comment"] = commentStr;
    return this;
  }
  SelectorBuilder explain(){
    _query;
    map["\$explain"] = true;
    return this;
  }
  SelectorBuilder snapshot(){
    _query;
    map["\$snapshot"] = true;
    return this;
  }
  SelectorBuilder showDiskLoc(){
    _query;
    map["\$showDiskLoc"] = true;
    return this;
  }
  SelectorBuilder returnKey(){
    _query;
    map["\$sreturnKey"] = true;
    return this;
  }
 
  SelectorBuilder jsQuery(String javaScriptCode){
    _query["\$where"] = new BsonCode(javaScriptCode);
    return this;
  }


  SelectorBuilder fields(List<String> fields) {
     if (paramFields != null) {
       throw 'Fields parameter may be set only once for selector';
     }
     paramFields = {};
     for (var field in fields) {
       paramFields[field] = 1;
     }
     return this;
  }
  SelectorBuilder excludeFields(List<String> fields) {
    if (paramFields != null) {
      throw 'Fields parameter may be set only once for selector';
    }
    paramFields = {};
    for (var field in fields) {
      paramFields[field] = 0;
    }
    return this;
  }

  SelectorBuilder limit(int limit) {
    paramLimit = limit;
    return this;
  }

  SelectorBuilder skip(int skip) {
    paramSkip = skip;
    return this;
  }

  SelectorBuilder raw(Map rawSelector) {
    map = rawSelector;
    return this;
  }
  SelectorBuilder within(String fieldName, value){
    _addExpression(fieldName,{"\$within":{"\$box":value}});
    return this;
  }
  SelectorBuilder near(String fieldName, var value, [double maxDistance]){
    if (maxDistance != null){
      _addExpression(fieldName,{"\$near":value});
    } else {
      _addExpression(fieldName,{"\$near":value,"\$maxDistance":maxDistance});
    }
    return this;
  }
/// Combine current expression with expression in parameter. 
/// [See MongoDB doc](http://docs.mongodb.org/manual/reference/operator/and/#op._S_and)
/// [SelectorBuilder] provides implicit `and` operator for chained queries so these two expression will produce
/// identical MongoDB queries
///  
///     where.eq('price', 1.99).lt('qty', 20).eq('sale', true);
///     where.eq('price', 1.99).and(where.lt('qty',20)).and(where.eq('sale', true))
///
/// Both these queries would produce json map:
///  
///     {'\$query': {'\$and': [{'price':1.99},{'qty': {'\$lt': 20 }}, {'sale': true }]}}
  SelectorBuilder and(SelectorBuilder other) {
    if (_query.isEmpty) {
      throw new StateError('`And` opertion is not supported on empty query');
    }
    _addExpressionMap(other._query);
    return this;
  }
/// Combine current expression with expression in parameter by logical operator **OR**. 
/// [See MongoDB doc](http://docs.mongodb.org/manual/reference/operator/and/#op._S_or)
/// For example  
///    inventory.find(where.eq('price', 1.99).and(where.lt('qty',20).or(where.eq('sale', true))));
/// 
/// This query will select all documents in the inventory collection where:
/// * the **price** field value equals 1.99 and
/// * either the **qty** field value is less than 20 or the **sale** field value is true 
/// MongoDB json query from this expression would be
///      {'\$query': {'\$and': [{'price':1.99}, {'\$or': [{'qty': {'\$lt': 20 }}, {'sale': true }]}]}}
  SelectorBuilder or(SelectorBuilder other) {
    if (_query.isEmpty) {
      throw new StateError('`And` opertion is not supported on empty query');
    }
    if (_query.containsKey('\$or')) {
      List expressions = _query['\$or'];
      expressions.add(other._query);
    } else {
      var expressions = [_query];
      expressions.add(other._query);
      map['\$query'] = {'\$or': expressions};
    }
    return this;
  }
  
  String getQueryString(){
    var result = JSON.encode(map);
    result = result.replaceAllMapped(objectIdRegexp, (Match match)=>'ObjectId("${match.group(1)}")');
    return result;
  }  

}
