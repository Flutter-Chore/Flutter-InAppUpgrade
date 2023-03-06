import 'package:flutter/material.dart';

import 'package:upgrade/core/custom_upgrade_view.dart';
import 'package:upgrade/core/upgrade_manager.dart';
import 'package:upgrade/default/default_upgrade_status_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    UpgradeManager.instance.init(
      url: "http://localhost:8000/appcast/latest",
      currentVersionPath: "assets/version/version.json",
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: CustomUpgradeView(
                builder: (context, state) {
                  if (state.current == null) {
                    return const Text("Upgrade Current Version: null", style: TextStyle(fontWeight: FontWeight.bold));
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Upgrade Current Version: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("title: ${state.current!.title}"),
                      Text("description: ${state.current!.description}"),
                      Text("releaseNotes: ${state.current!.releaseNotes}"),
                      Text("version: ${state.current!.version.toString()}"),
                      Text("displayVersionString: ${state.current!.displayVersionString}"),
                      Text("os: ${state.current!.os}"),
                      Text("minimumSystemVersion: ${state.current!.minimumSystemVersion}"),
                      Text("maximumSystemVersion: ${state.current!.maximumSystemVersion}"),
                      Text("fileURL: ${state.current!.fileURL}"),
                    ],
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: CustomUpgradeView(
                builder: (context, state) {
                  if (state.latest == null) {
                    return const Text("Upgrade Latest Version: null", style: TextStyle(fontWeight: FontWeight.bold));
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Upgrade Latest Version: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("title: ${state.latest!.title}"),
                      Text("description: ${state.latest!.description}"),
                      Text("releaseNotes: ${state.latest!.releaseNotes}"),
                      Text("version: ${state.latest!.version.toString()}"),
                      Text("displayVersionString: ${state.latest!.displayVersionString}"),
                      Text("os: ${state.latest!.os}"),
                      Text("minimumSystemVersion: ${state.latest!.minimumSystemVersion}"),
                      Text("maximumSystemVersion: ${state.latest!.maximumSystemVersion}"),
                      Text("fileURL: ${state.latest!.fileURL}"),
                    ],
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => UpgradeManager.instance.checkForUpdates(),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: Text("Check for Updates"),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    child: DefaultUpgradeStatusIndicator(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
