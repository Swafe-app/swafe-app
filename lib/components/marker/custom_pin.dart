import 'package:flutter/material.dart';
import 'package:swafe/DS/reporting_type.dart';

class CustomMarker extends StatefulWidget {
  final ReportingType reportingType;

  const CustomMarker({
    Key? key,
    required this.reportingType
}) : super(key: key);

  @override
  CustomMarkerState createState() => CustomMarkerState();
}

class CustomMarkerState extends State<CustomMarker>{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.81),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 32,
                height: 36.38,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 32,
                        height: 36.38,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/bubble.svg'),
                            fit: BoxFit.fill,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x26000000),
                              blurRadius: 3,
                              offset: Offset(0, 1),
                              spreadRadius: 1,
                            ),BoxShadow(
                              color: Color(0x4C000000),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: AssetImage(widget.reportingType.pin),
                            fit: BoxFit.cover,
                          ),
                          shape: const OvalBorder(
                            side: BorderSide(width: 1, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}