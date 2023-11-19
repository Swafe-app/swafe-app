import 'package:flutter/material.dart';
import 'package:swafe/DS/shadows.dart';

class CustomIconButton extends StatefulWidget {
  final bool isLoading;
  final IconData? iconData;
  final String? image;
  final double size;
  final VoidCallback? onPressed;
  const CustomIconButton({
    super.key,
    this.isLoading = false,
    this.iconData,
    this.image,
    required this.size,
    this.onPressed,
  }) : assert(iconData != null || image != null || isLoading);

  @override
  CustomIconButtonState createState() => CustomIconButtonState();
}

class CustomIconButtonState extends State<CustomIconButton> {

  @override
  Widget build(BuildContext context) {
    return Container( child: widget.isLoading
        ? IconButton(
      icon: const CircularProgressIndicator(),
      onPressed: () {},
    )
        : IconButton(
      icon: Image.asset(widget.image!),
      iconSize: widget.size,
      onPressed: widget.onPressed,
      color: Colors.white,

    ),
    );
  }
}
