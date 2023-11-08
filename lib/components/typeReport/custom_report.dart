import 'package:flutter/material.dart';

import '../../DS/reporting_type.dart';
import '../../DS/typographies.dart';

class CustomReport extends StatefulWidget {
  final ReportingType reportingType;
  final VoidCallback? onPressed;

  const CustomReport({Key? key, required this.reportingType, this.onPressed}) : super(key: key);

  @override
  CustomReportState createState() => CustomReportState();
}

class CustomReportState extends State<CustomReport> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Column(
        children: [
          SizedBox(
            width: 92,
            height: 114,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 74,
                  height: 74,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 74,
                        height: 74,
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image:
                            AssetImage(widget.reportingType.pin),
                            fit: BoxFit.fill,
                          ),
                          shape: const OvalBorder(
                            side: BorderSide(width: 3, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 92,
                  child: Text(
                    widget.reportingType.title,
                    textAlign: TextAlign.center,
                    style: typographyList
                        .firstWhere(
                            (element) => element.name == 'Title XSmall Medium')
                        .style,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
