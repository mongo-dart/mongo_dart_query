# Changelog

## 1.0.0-nullsafety

## 0.4.2

* Fixed problem in SelectorBuilder:
if you set a raw map, then you couldn't add any new query expression or you loose the inital raw map "query" section.
* Lint clean-up
* Updated sdk constraint to 2.5.2

## 0.4.1

* class `Set` of aggregation stages moved to class `SetStage` to resolve conflict with `dart:core` library

## 0.4.0 - September 30th, 2019 (@alexd1971, @vadimtsushko)

* Aggregation pipeline builder [PR#14](https://github.com/mongo-dart/mongo_dart_query/pull/14)

## 0.3.1 - June 30th, 2018 (@thosakwe, @aemino)

* Merged [PR #11](https://github.com/mongo-dart/mongo_dart_query/pull/11) from @aemino,
which adds Dart 2 fixes for this package, namely coercin of generic types avoiding implicit casts
