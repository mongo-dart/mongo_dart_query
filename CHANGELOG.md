# Changelog

## 5.0.1

- Fixed match operator, the case insensitive flag was inverted (true instead of false and viceversa)

## 5.0.0

Changed dependency on Bson package. This have the following consequenses:

- BSON classes are mainly used for internal use. See the Bson github site for more details
  - BsonRegexp now it is not normally needed, use RegExp instead.
  - BsonNull is not needed, you can use null directly.
  - A new JsCode class has been created, it is no more needed the use of BsonCode.
- Uuid dependecy has been updated and this means that the UuidValue class has been slightly changed. The .fromString constructure must be used mainly instead of the default one. Check the Uuid package Pub site for details.  

## 4.0.5

- Added `escapePatern` parameter to `match` method in `SelectorBuilder`. This parameter allows to escape the pattern passed to the method. Usefule when, for example you have to search for some string conatining a RegExp special character like points (ex '<john.doe@noone.com>')

## 4.0.4

- Missing Export (Fix)

## 4.0.3

- SetWindowFields() (aggregation). Fix.

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
