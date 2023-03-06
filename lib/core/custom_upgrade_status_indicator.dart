
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upgrade/core/upgrade_manager.dart';
import 'package:upgrade/core/upgrade_state_change_notifier.dart';
import 'package:upgrade/models/upgrade_status.dart';

class CustomUpgradeStatusIndicator extends StatelessWidget {

  final Widget Function(BuildContext context, UpgradeStatus status) builder;

  const CustomUpgradeStatusIndicator({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: UpgradeManager.instance.state,
      child: Consumer<UpgradeStateChangeNotifier>(
        builder: (context, state, _) {
          return builder.call(context, state.status);
        },
      ),
    );
  }


}