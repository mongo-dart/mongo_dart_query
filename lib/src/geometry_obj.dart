
import '../mongo_aggregation.dart';

class GeometryObject extends AggregationExpr {
  GeometryObject({required this.type, required this.coordinates});

  GeometryObject.point(List<double> point)
      : type = GeometryObjectType.Point,
        coordinates = point;

  GeometryObjectType type;
  List coordinates;

  @override
  Map<String, dynamic> build() {
    return {
      'type': type.toString().split('.').last,
      'coordinates': coordinates
    };
  }
}

enum GeometryObjectType {
  Point,
  LineString,
  Polygon,
  MultiPoint,
  MultiLineString,
  MultiPolygon
}
