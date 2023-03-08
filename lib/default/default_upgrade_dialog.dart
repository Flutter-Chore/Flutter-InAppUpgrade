
import 'package:flutter/material.dart';
import 'package:upgrade/core/custom_upgrade_view.dart';

class DefaultUpgradeDialog extends StatelessWidget {
  const DefaultUpgradeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomUpgradeView(
      builder: (context, state) {
        final size = MediaQuery.of(context).size;
        return SimpleDialog(
          title: Text('${state.latest!.title}'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          children: [
            Container(
              constraints: BoxConstraints(
                minWidth: size.width * 0.4,
                maxWidth: size.width * 0.7,
                minHeight: size.height * 0.4,
                maxHeight: size.height * 0.7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
              ),
            ),
          ],
        );
      },
    );
  }


}