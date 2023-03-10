
import 'package:flutter/material.dart';
import 'package:upgrade/core/custom_upgrade_status_indicator.dart';

class DefaultUpgradeStatusIndicator extends StatelessWidget {
  const DefaultUpgradeStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomUpgradeStatusIndicator(
      builder: (context, status) {
        return Text(status.name);
      },
    );
  }
}