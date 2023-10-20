import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart';

enum IconButtonType { outlined, filled, square }

enum IconButtonSize { S, M, L, XL }

class IconButtonStyleData {
  final double iconSize;
  final double padding;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;

  IconButtonStyleData({
    required this.iconSize,
    required this.padding,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
  });
}

IconButtonStyleData getButtonStyle(
    IconButtonSize size, IconButtonType type, bool isDisabled, bool isLoading) {
  double iconSize = 24;
  double padding = 8;
  Color iconColor = Colors.transparent;
  Color backgroundColor = Colors.transparent;
  Color borderColor = Colors.transparent;

  // Logique pour déterminer les couleurs en fonction du type, de l'état 'isDisabled' et de l'état 'isLoading'
  if (type == IconButtonType.outlined) {
    iconColor = MyColors.secondary40;
    backgroundColor = Colors.transparent;
    borderColor = MyColors.secondary40;
    if (isDisabled || isLoading) {
      iconColor = MyColors.neutral60;
      borderColor = MyColors.neutral80;
    }
  } else if (type == IconButtonType.filled) {
    iconColor = MyColors.neutral100;
    backgroundColor = MyColors.secondary40;
    borderColor = Colors.transparent;
    if (isDisabled || isLoading) {
      iconColor = MyColors.neutral60;
      backgroundColor = MyColors.neutral80;
    }
  } else if (type == IconButtonType.square) {
    iconColor = MyColors.secondary40;
    backgroundColor = Colors.transparent;
    borderColor = MyColors.secondary40;
    if (isDisabled || isLoading) {
      iconColor = MyColors.neutral60;
      borderColor = MyColors.neutral80;
    }
  }

  // Logique pour déterminer la taille du bouton en fonction de taille S, M, L ou XL
  switch (size) {
    case IconButtonSize.S:
      iconSize = 16;
      padding = 2;
      break;
    case IconButtonSize.M:
      iconSize = 20;
      padding = 4;
      break;
    case IconButtonSize.L:
      iconSize = 24;
      padding = 8;
      break;
    case IconButtonSize.XL:
      iconSize = 32;
      padding = 8;
      break;
    default:
      break;
  }

  return IconButtonStyleData(
    iconSize: iconSize,
    padding: padding,
    iconColor: iconColor,
    backgroundColor: backgroundColor,
    borderColor: borderColor,
  );
}

class CustomIconButton extends StatefulWidget {
  final IconButtonSize size;
  final IconButtonType type;
  final bool isDisabled;
  final bool isLoading;
  final VoidCallback? onPressed;
  final IconData icon;
  final Color? fillColor;
  final Color? strokeColor;
  final Color? iconColor;

  const CustomIconButton({
    Key? key,
    this.size = IconButtonSize.L,
    this.type = IconButtonType.filled,
    this.isDisabled = false,
    this.isLoading = false,
    required this.icon,
    this.onPressed,
    this.fillColor,
    this.strokeColor,
    this.iconColor,
  }) : super(key: key);

  @override
  CustomIconButtonState createState() => CustomIconButtonState();
}

class CustomIconButtonState extends State<CustomIconButton> {
  @override
  Widget build(BuildContext context) {
    IconButtonStyleData styleData = getButtonStyle(
        widget.size, widget.type, widget.isDisabled, widget.isLoading);

    Color fillColor = widget.fillColor ?? styleData.backgroundColor;
    Color strokeColor = widget.strokeColor ?? styleData.borderColor;
    Color iconColor = widget.iconColor ?? styleData.iconColor;

    return InkWell(
      onTap: widget.isDisabled || widget.isLoading ? null : widget.onPressed,
      child: Container(
        padding: EdgeInsets.all(styleData.padding),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(
              widget.type == IconButtonType.square ? 8 : 50),
          border: Border.all(color: strokeColor, width: 2),
        ),
        child: Center(
          child: widget.isLoading
              ? SizedBox(
                  width: styleData.iconSize,
                  height: styleData.iconSize,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(MyColors.secondary40),
                  ),
                )
              : Icon(widget.icon, color: iconColor, size: styleData.iconSize),
        ),
      ),
    );
  }
}
