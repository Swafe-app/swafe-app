import 'package:swafe/DS/colors.dart';
import 'package:flutter/material.dart';

enum ButtonType { filled, outlined, text }

class ButtonStyleData {
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;

  ButtonStyleData({
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
  });
}

ButtonStyleData getButtonStyle(
    ButtonType type, bool isDisabled, bool isLoading) {
  Color textColor = Colors.transparent;
  Color backgroundColor = Colors.transparent;
  Color borderColor = Colors.transparent;

  if (type == ButtonType.filled) {
    textColor = MyColors.neutral100;
    backgroundColor = MyColors.secondary40;
    borderColor = Colors.transparent;
    if (isDisabled || isLoading) {
      textColor = MyColors.neutral60;
      backgroundColor = MyColors.neutral80;
    }
  } else if (type == ButtonType.outlined) {
    textColor = MyColors.secondary40;
    backgroundColor = Colors.transparent;
    borderColor = MyColors.secondary40;
    if (isDisabled || isLoading) {
      textColor = MyColors.neutral60;
      borderColor = MyColors.neutral80;
    }
  } else if (type == ButtonType.text) {
    textColor = MyColors.secondary40;
    backgroundColor = Colors.transparent;
    borderColor = Colors.transparent;
    if (isDisabled || isLoading) {
      textColor = MyColors.neutral60;
    }
  }

  return ButtonStyleData(
    textColor: textColor,
    backgroundColor: backgroundColor,
    borderColor: borderColor,
  );
}

class CustomButton extends StatefulWidget {
  final String label;
  final ButtonType type;
  final bool isDisabled;
  final bool isLoading;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? fillColor;
  final Color? strokeColor;
  final Color? textColor;
  final MainAxisSize mainAxisSize;

  const CustomButton({
    Key? key,
    required this.label,
    this.type = ButtonType.filled,
    this.isDisabled = false,
    this.isLoading = false,
    this.onPressed,
    this.icon,
    this.fillColor,
    this.strokeColor,
    this.textColor,
    this.mainAxisSize = MainAxisSize.max,
  }) : super(key: key);

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    ButtonStyleData styleData =
        getButtonStyle(widget.type, widget.isDisabled, widget.isLoading);

    Color fillColor =
        widget.fillColor ?? styleData.backgroundColor;
    Color strokeColor =
        widget.strokeColor ?? styleData.borderColor;
    Color textColor =
        widget.textColor ?? styleData.textColor;

    return ElevatedButton(
      onPressed:
          widget.isDisabled || widget.isLoading ? null : widget.onPressed,
      style: ButtonStyle(
        shadowColor: MaterialStateProperty.all(Colors.transparent),
        backgroundColor: MaterialStateProperty.all(fillColor),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
            vertical: 14, horizontal: widget.icon == null ? 24 : 16)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: strokeColor, width: 2),
        )),
      ),
      child: widget.isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(MyColors.secondary40),
              ),
            )
          : Row(
              mainAxisSize: widget.mainAxisSize,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null)
                  Icon(widget.icon, color: textColor, size: 16),
                if (widget.icon != null) const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "SF Pro Display",
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    height: 20 / 14,
                    letterSpacing: 0.056,
                    color: textColor,
                  ),
                ),
              ],
            ),
    );
  }
}
