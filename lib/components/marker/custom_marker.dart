import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../DS/reporting_type.dart';
import 'package:latlong2/latlong.dart';

class CustomMarker extends Marker {
  final ReportingType reportingType;

  CustomMarker({
    required this.reportingType,
    required LatLng point,
  }) : super(
    width: 50.0,
    height: 50.0,
    builder: (ctx) => SvgPicture.asset(reportingType.pin),
    point: point,
  );
}