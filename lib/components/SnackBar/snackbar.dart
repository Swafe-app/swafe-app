import 'package:swafe/DS/colors.dart';
import 'package:flutter/material.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/Button/button.dart';

class CustomSnackbar extends StatefulWidget {
  final String label;
  final bool isError;

  const CustomSnackbar({
    super.key,
    required this.label,
    this.isError = false,
  });

  @override
  CustomSnackbarState createState() => CustomSnackbarState();
}

class CustomSnackbarState extends State<CustomSnackbar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          widget.isError ? Icons.highlight_off : Icons.check_circle_outline,
          size: 32,
          color: widget.isError ? MyColors.error40 : MyColors.success40,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: BodyLargeRegular.copyWith(color: MyColors.neutral100),
              ),
            ],
          ),
        ),
        // const SizedBox(width: 8),
        // const CustomButton(
        //   type: ButtonType.text,
        //   label: 'Annuler',
        //   textColor: MyColors.secondary70,
        // ),
      ],
    );
  }
}
