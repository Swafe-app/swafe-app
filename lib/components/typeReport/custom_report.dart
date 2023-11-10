import 'package:flutter/material.dart';

import '../../DS/reporting_type.dart';
import '../../DS/typographies.dart';

class CustomReport extends StatefulWidget {
  final ReportingType reportingType;
  final VoidCallback? onPressed;

  const CustomReport({Key? key, required this.reportingType, this.onPressed})
      : super(key: key);

  @override
  CustomReportState createState() => CustomReportState();
}

class CustomReportState extends State<CustomReport> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        if (widget.onPressed != null) {
      widget.onPressed!(),
    },setState(() {
      // Toggle the isSelected state
      // If it was selected, make it unselected; if it was unselected, make it selected
      _isSelected = !_isSelected;
    })},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
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
                    side: BorderSide(width: 3, color: _isSelected ? Colors.purple : Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
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
    );
  }
}
