import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:swafe/DS/shadows.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/BottomSheet/GroupedMarkerBottomSheet.dart';

import '../../models/signalement/signalement_model.dart';

class CustomGroupedMarker extends Marker {
  final String imagePath;
  final int numberReports;
  final List<SignalementModel> reports;
  final BuildContext ctx;
  final void Function(SignalementModel, bool) showSignalementDialog;

  CustomGroupedMarker({
    required this.imagePath,
    required this.numberReports,
    required super.point,
    required this.reports,
    required this.ctx,
    required this.showSignalementDialog,
  }) : super(
          width: 80.0,
          height: 80.0,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: ctx,
                  builder: (BuildContext context) {
                    return GroupedMarkerBottomSheet(
                      reports: reports,
                      showSignalementDialog: showSignalementDialog,
                    );
                  });
            },
            child: Stack(
              children: [
                Positioned(
                  left: 0.50,
                  top: 0,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: AssetImage(imagePath),
                          fit: BoxFit.fill,
                        ),
                        shape: const OvalBorder(
                          side: BorderSide(width: 1, color: Colors.white),
                        ),
                        shadows: Shadows.shadow1),
                  ),
                ),
                Positioned(
                  left: 36.50,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: ShapeDecoration(
                        color: const Color(0xFFDFD4FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        shadows: Shadows.shadow),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 15,
                          height: 15,
                          child: Text(
                            numberReports > 99
                                ? '99+'
                                : numberReports.toString(),
                            textAlign: TextAlign.center,
                            style: BodySmallRegular,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
}
