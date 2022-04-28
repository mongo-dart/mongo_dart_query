import '../mongo_aggregation.dart';

/// There is
abstract class ShapeOperator extends Operator {
  ShapeOperator(String name, args) : super(name, args);
}

enum GeometryObjectType {
  // ignore: constant_identifier_names
  Point,
  // ignore: constant_identifier_names
  LineString,
  // ignore: constant_identifier_names
  Polygon,
  // ignore: constant_identifier_names
  MultiPoint,
  // ignore: constant_identifier_names
  MultiLineString,
  // ignore: constant_identifier_names
  MultiPolygon
}

/// https://docs.mongodb.com/manual/reference/operator/query/geometry/#mongodb-query-op.-geometry
class Geometry extends ShapeOperator {
  Geometry(
      {required this.type,
      required List coordinates,
      Map<String, dynamic>? crs})
      : super('geometry', {
          'type': type.toString().split('.').last,
          'coordinates': coordinates,
          if (crs != null) 'crs': crs
        });

  Geometry.point(List<double> point, {Map<String, dynamic>? crs})
      : type = GeometryObjectType.Point,
        super('geometry', {
          'type': GeometryObjectType.Point.toString().split('.').last,
          'coordinates': point,
          if (crs != null) 'crs': crs
        });

  GeometryObjectType type;
}

/// https://docs.mongodb.com/manual/reference/operator/query/box/#mongodb-query-op.-box
class Box extends ShapeOperator {
  Box({required List<num> bottomLeft, required List<num> upperRight})
      : super('box', [bottomLeft, upperRight]);
}

/// https://docs.mongodb.com/manual/reference/operator/query/box/#mongodb-query-op.-box
class Center extends ShapeOperator {
  Center({required List<num> center, required num radius})
      : super('center', [center, radius]);
}

/// https://docs.mongodb.com/manual/reference/operator/query/box/#mongodb-query-op.-box
class CenterSphere extends ShapeOperator {
  CenterSphere({required List<num> center, required num radius})
      : super('centerSphere', [center, radius]);
}
