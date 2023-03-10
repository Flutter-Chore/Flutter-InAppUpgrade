
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upgrade/core/upgrade_manager.dart';
import 'package:upgrade/core/upgrade_state_change_notifier.dart';

class CustomUpgradeView extends StatelessWidget {

  final Widget Function(BuildContext context, UpgradeStateChangeNotifier state) builder;

  const CustomUpgradeView({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: UpgradeManager.instance.state,
      child: Consumer<UpgradeStateChangeNotifier>(
        builder: (context, state, _) {
          return builder.call(context, state);
        },
      ),
    );
  }
}