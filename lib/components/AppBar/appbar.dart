import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/IconButton/icon_button.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool showIconButton;
  final bool showLogo;
  final bool whiteIcon;
  final VoidCallback? iconButtonOnPressed;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.showIconButton = true,
    this.showLogo = true,
    this.whiteIcon = false,
    this.iconButtonOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: (!showIconButton && (showLogo || title.isNotEmpty))
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: [
        if (showIconButton)
          CustomIconButton(
            type: IconButtonType.square,
            onPressed: iconButtonOnPressed ?? () => Navigator.of(context).pop(),
            icon: Icons.arrow_back_ios_new,
          ),
        if (showLogo)
          whiteIcon
              ? Image.asset('assets/images/Swafe_Logo_White.png',
                  width: 40, height: 40, fit: BoxFit.cover)
              : SvgPicture.asset('assets/images/Swafe_Logo.svg',
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
