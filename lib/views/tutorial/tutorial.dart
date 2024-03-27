import 'package:app_tutorial/app_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:swafe/views/tutorial/tutorialItemcontent.dart';

class YourClass extends StatefulWidget {
  const YourClass({super.key});

  @override
  YourClassState createState() => YourClassState();
}

class YourClassState extends State<YourClass> {
  final policeButton = GlobalKey(debugLabel: 'callPoliceButton');
  final reportButton = GlobalKey(debugLabel: 'reportButton');
  List<TutorialItem> targets = [];

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}