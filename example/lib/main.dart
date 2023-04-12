
import 'package:flutter/material.dart';
import 'package:upgrade/upgrade.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    UpgradeManager.instance.init(
      url: "http://192.168.1.3:8000/appcast/latest",
      currentVersionPath: "assets/version/version.json",
    );
  }

  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: CustomUpgradeView(
              builder: (context, state) => _buildAppcastItemInfo(title: "Upgrade Current Version", item: state.current),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: CustomUpgradeView(
              builder: (context, state) => _buildAppcastItemInfo(title: "Upgrade Latest Version", item: state.latest),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: CustomUpgradeStatusIndicator(
                builder: (context, status) {
                  return Text(status.name);
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Download Progress"),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: SizedBox(
                      width: 256,
                      child: LinearProgressIndicator(value: progress, minHeight: 8,),
                    ),
                  ),
                ],
              ),
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
                GestureDetector(
                  onTap: () => UpgradeManager.instance.download(onReceiveProgress: (received, total, _) {
                    setState(() {
                      progress = received / total;
                    });
                  }),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    child: Text("Download"),
                  ),
                ),
                GestureDetector(
                  onTap: () => UpgradeManager.instance.install(),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    child: Text("Install"),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAppcastItemInfo({required String title, AppcastItem? item}) {
    if (item == null) {
      return Text("$title: null", style: const TextStyle(fontWeight: FontWeight.bold));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Text("releaseNotes: ${item.releaseNotes}"),
        Text("version: ${item.version.toString()}"),
        Text("displayVersionString: ${item.displayVersionString}"),
        Text("os: ${item.os}"),
        Text("minimumSystemVersion: ${item.minimumSystemVersion}"),
        Text("maximumSystemVersion: ${item.maximumSystemVersion}"),
      ],
    );
  }
}
