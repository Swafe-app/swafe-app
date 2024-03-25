import 'package:app_tutorial/app_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swafe/DS/spacing.dart';
import 'package:swafe/DS/typographies.dart';

class TutorialItemContent extends StatelessWidget {
  const TutorialItemContent({
    super.key,
    required this.title,
    required this.content,
    required this.targetKey,
    this.iscenter,
  });

  final GlobalKey targetKey;
  final String title;
  final String content;
  final bool? iscenter;

  @override
  Widget build(BuildContext context) {
    final RenderBox renderBox =
        targetKey.currentContext?.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final width = MediaQuery.of(context).size.width;
    var containerWidth = iscenter == true ? width * (0.8 + 0.1) : width * 0.8;
    return Stack(
      children: [
        Positioned(
          top: position.dy -
              renderBox.size.height -
              MediaQuery.of(context).size.height * 0.125,
          left: iscenter == true ? (width - containerWidth) / 2 : null,
          right: iscenter == true ? (width - containerWidth) / 2 : 0,
          child: Container(
            width: containerWidth,
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.all(10.0),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TitleSmallMedium,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: Spacing.small),
                Text(
                  content,
                  style: BodyLargeMedium,
                ),
              ],
            ),
          ),
        ),
        if (iscenter == null)
          Positioned(
              top: position.dy -
                  renderBox.size.height +
                  MediaQuery.of(context).size.height * 0.04,
              right: 25,
              child: SizedBox(
                child: SvgPicture.asset(
                  'assets/images/arrow.svg',
                  width: 20,
                  height: 20,
                ),
              )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () => Tutorial.skipAll(context),
                    child: const Text(
                      'Terminé',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  const TextButton(
                    onPressed: null,
                    child:
                        Text(
                          'Suivant >>',
                          style: TextStyle(color: Colors.white),
                        ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
