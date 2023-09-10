# Changelog

## 4.0.3

- ToDo

## 4.0.2

- SetWindowFields() (aggregation)

## 4.0.1

- addEachToSet method

## 4.0.0

- Inherited Bson 4.0.0 that introduces **breaking changes**

## 3.0.0

- Inherited Decimal 2.3.0 that can introduce **breaking changes**

## 2.0.1

- Fix - Geometry class was not exported

## 2.0.0

- Lint fixes
- Corrected "and" references in selectorBuilder.or(…)

## 2.0.0-1.0.beta

- New UnionWith Stage
- Removed Pedantic -> Moved to Lints

### Breaking changes

- Moved to Bson 2.0.0 that uses Decimal instead of Rational

## 1.0.2

- added geoNear aggregation stage
- SelectorBuilder clone()

## 1.0.1

- $mul operator

## 1.0.0

- Update dependencies for final version

## 1.0.0-nullsafety.2

- updated dependencies

## 1.0.0-nullsafety

### Potential breaking changes

- `AEList` and `AEObject` constructors do not accept null parameters
- The `AEList` iterator `current` getter now throws instead of returning null if `current` is undefined (`moveNext` not called or end of Iterable)
- In `SelectorBuilder` the `paramFields` map cannot be set directly any more, but the related method must be used (fields, excludeFields and metaTextScore)

## 0.4.2

- Fixed problem in SelectorBuilder:
if you set a raw map, then you couldn't add any new query expression or you loose the inital raw map "query" section.
- Lint clean-up
- Updated sdk constraint to 2.5.2

## 0.4.1

- class `Set` of aggregation stages moved to class `SetStage` to resolve conflict with `dart:core` library

## 0.4.0 - September 30th, 2019 (@alexd1971, @vadimtsushko)

- Aggregation pipeline builder [PR#14](https://github.com/mongo-dart/mongo_dart_query/pull/14)

## 0.3.1 - June 30th, 2018 (@thosakwe, @aemino)

- Merged [PR #11](https://github.com/mongo-dart/mongo_dart_query/pull/11) from @aemino,
which adds Dart 2 fixes for this package, namely coercin of generic types avoiding implicit casts
