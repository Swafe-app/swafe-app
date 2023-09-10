import 'package:flutter/material.dart';

enum ButtonType { filled, outlined, text }

const secondary40 = Color.fromRGBO(113, 77, 216, 1);
const neutral100 = Color.fromRGBO(255, 255, 255, 1);
const neutral80 = Color.fromRGBO(237, 237, 237, 1);
const neutral60 = Color.fromRGBO(138, 147, 154, 1);

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
    textColor = neutral100;
    backgroundColor = secondary40;
    borderColor = Colors.transparent;
    if (isDisabled || isLoading) {
      textColor = neutral60;
      backgroundColor = neutral80;
    }
  } else if (type == ButtonType.outlined) {
    textColor = secondary40;
    backgroundColor = Colors.transparent;
    borderColor = secondary40;
    if (isDisabled || isLoading) {
      textColor = neutral60;
      borderColor = neutral80;
    }
  } else if (type == ButtonType.text) {
    textColor = secondary40;
    backgroundColor = Colors.transparent;
    borderColor = Colors.transparent;
    if (isDisabled || isLoading) {
      textColor = neutral60;
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

  const CustomButton({
    super.key,
    required this.label,
    this.type = ButtonType.filled,
    this.isDisabled = false,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    ButtonStyleData styleData =
        getButtonStyle(widget.type, widget.isDisabled, widget.isLoading);

    return ElevatedButton(
      onPressed:
          widget.isDisabled || widget.isLoading ? null : widget.onPressed,
      style: ButtonStyle(
        shadowColor: MaterialStateProperty.all(Colors.transparent),
        backgroundColor: MaterialStateProperty.all(styleData.backgroundColor),
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 14, horizontal: 24)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: styleData.borderColor, width: 2),
        )),
      ),
      child: widget.isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(84, 55, 168, 1)),
              ),
            )
          : Text(
              widget.label,
              style: TextStyle(
                // fontFamily: 'SF Pro Display',
                fontSize: 14,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                height: 20 / 14,
                letterSpacing: 0.056,
                color: styleData.textColor,
              ),
            ),
    );
  }
}
