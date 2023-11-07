import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart';

class CustomTextField extends StatefulWidget {
  final String placeholder;
  final bool isDisabled;
  final bool isError;
  final void Function(String)? onChanged;
  final IconData? rightIcon;
  final VoidCallback? onRightIconPressed;
  final TextInputType keyboardType;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    required this.placeholder,
    this.isDisabled = false,
    this.isError = false,
    this.onChanged,
    this.rightIcon,
    this.onRightIconPressed,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  }) : super(key: key);

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        labelText: widget.placeholder,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: MyColors.neutral40,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: MyColors.secondary40,
            width: 2,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: MyColors.error40,
            width: 2,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: MyColors.neutral70,
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        suffixIcon: widget.rightIcon != null
            ? IconButton(
                onPressed: widget.onRightIconPressed,
                icon: Icon(widget.rightIcon),
                color: MyColors.primary10,
              )
            : null,
      ),
    );
  }
}
