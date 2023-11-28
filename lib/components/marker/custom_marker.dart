import 'package:flutter/cupertino.dart';
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
          width: 130.0,
          height: 150.0,
          builder: (ctx) => Stack(children: [
            Center(child: SvgPicture.asset(reportingType.threat)),
            Positioned(
                right: 50,
                bottom: 60,
                child: SizedBox(
                    height: 70,
                    width: 70,
                    child: SvgPicture.asset(
                      'assets/images/bubble.svg',
                      width: 50,
                      height: 50,
                    ))),
            Positioned(
                right: 62,
                bottom: 77,
                child: SizedBox(
                    height: 45,
                    width: 45,
                    child: Image.asset(reportingType.pin)))
          ]),
          point: point,
        );
}
