import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';

class CustomTextField extends StatefulWidget {
  final String placeholder;
  final bool isDisabled;
  final bool isError;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final IconData? rightIcon;
  final VoidCallback? onRightIconPressed;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController? controller;

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
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        labelText: widget.placeholder,
        labelStyle: BodyLargeMedium,
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
        focusedErrorBorder: const OutlineInputBorder(
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
