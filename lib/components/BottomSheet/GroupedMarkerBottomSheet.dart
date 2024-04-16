import 'package:flutter/material.dart';

import '../../DS/reporting_type.dart';
import '../../DS/shadows.dart';
import '../../DS/spacing.dart';
import '../../DS/typographies.dart';
import '../../models/signalement/signalement_model.dart';

class GroupedMarkerBottomSheet extends StatelessWidget {
  final List<SignalementModel> reports;
  final void Function(SignalementModel, bool) showSignalementDialog;

  const GroupedMarkerBottomSheet({
    super.key,
    required this.reports,
    required this.showSignalementDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      height: 300,
      child: Column(
        children: [
          const SizedBox(
            height: Spacing.standard,
          ),
          Text(
            'Signalements',
            style: TitleLargeMedium,
          ),
          const SizedBox(
            height: Spacing.standard,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reports.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(children: [
                  ListTile(
                    onTap: () => showSignalementDialog(reports[index], true),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: AssetImage(convertStringToReportingType(
                                    reports[index].selectedDangerItems.first)
                                .pin),
                            fit: BoxFit.fill,
                          ),
                          shape: const OvalBorder(
                            side: BorderSide(width: 1, color: Colors.white),
                          ),
                          shadows: Shadows.shadow1),
                    ),
                    title: Text(convertStringToReportingType(
                            reports[index].selectedDangerItems.first)
                        .title),
                  ),
                  const SizedBox(height: Spacing.standard)
                ]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
