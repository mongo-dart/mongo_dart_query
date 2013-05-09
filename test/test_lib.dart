library test_lib;
import 'package:unittest/unittest.dart';
import 'package:bson/bson.dart';
import 'package:mongo_dart_query/mongo_dart_query.dart';
testSelectorBuilderCreation(){
  SelectorBuilder selector = where;
  expect(selector.map is Map, isTrue);
  expect(selector.map,isEmpty);
}
testSelectorBuilderOnObjectId(){
  ObjectId id = new ObjectId();
  SelectorBuilder selector = where.id(id);
  expect(selector.map is Map, isTrue);
  expect(selector.map.length,greaterThan(0));  
}


run(){
  test("testSelectorBuilderCreation",testSelectorBuilderCreation);
  test("testSelectorBuilderOnObjectId",testSelectorBuilderOnObjectId);
}