import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';

import '../../DS/colors.dart';
import '../../DS/reporting_type.dart';

class CustomMarker extends Marker {
  final ReportingType reportingType;

  CustomMarker({
    required this.reportingType,
    required LatLng point,
  }) : super(
          width: 132.0,
          height: 137.0,
          child: Stack(
            children: [
              Center(
                child: SvgPicture.asset(reportingType.threat),
              ),
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
                  ),
                ),
              ),
              Positioned(
                right: 62,
                bottom: 77,
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: ShapeDecoration(
                    image:
                        DecorationImage(image: AssetImage(reportingType.pin)),
                    shape: const OvalBorder(
                      side: BorderSide(width: 3, color: MyColors.defaultWhite),
                    ),
                  ),
                ),
              ),
            ],
          ),
          point: point,
        );
}
