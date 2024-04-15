import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';

import '../../DS/reporting_type.dart';

class CustomReport extends StatefulWidget {
  final ReportingType reportingType;
  final VoidCallback? onPressed;
  final bool isSelected;

  const CustomReport(
      {Key? key,
      required this.reportingType,
      this.onPressed,
      required this.isSelected})
      : super(key: key);

  @override
  CustomReportState createState() => CustomReportState();
}

class CustomReportState extends State<CustomReport> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed?.call();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: AssetImage(widget.reportingType.pin),
                fit: BoxFit.fill,
              ),
              shape: OvalBorder(
                side: BorderSide(
                    width: 3,
                    color: widget.isSelected
                        ? MyColors.secondary40
                        : MyColors.defaultWhite),
              ),
            ),
          ),
          Text(
            widget.reportingType.title,
            textAlign: TextAlign.center,
            style: TitleXSmallMedium.copyWith(height: 1),
          ),
        ],
      ),
    );
  }
}
