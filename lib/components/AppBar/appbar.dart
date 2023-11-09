import 'package:flutter/material.dart';
import 'package:swafe/DS/typographies.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool showIconButton;
  final bool showLogo;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.showIconButton = true,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: (!showIconButton && (showLogo || title.isNotEmpty))
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: [
        if (showIconButton)
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        if (showLogo)
          Image.asset('assets/images/Swafe_Logo.png',
              width: 40, height: 40, fit: BoxFit.cover),
        if (title.isNotEmpty) Text(title, style: TitleLargeMedium),
        if ((showIconButton && (showLogo || title.isNotEmpty)))
          const SizedBox(
            width: 40,
            height: 40,
          )
      ],
    );
  }
}
