
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upgrade/core/upgrade_manager.dart';
import 'package:upgrade/core/upgrade_state_change_notifier.dart';

class CustomUpgradeDialog extends StatelessWidget {

  final Widget Function(BuildContext context, dynamic releaseNotes) builder;

  const CustomUpgradeDialog({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: UpgradeManager.instance.state,
      child: Consumer<UpgradeStateChangeNotifier>(
        builder: (context, state, _) {
          final notes = state.latest?.releaseNotes;
          if (notes == null) {
            return const Text("No releaseNotes.");
          }
          return builder.call(context, notes);
        },
      ),
    );
  }


}