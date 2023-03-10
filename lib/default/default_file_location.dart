
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Finds an appropriate place on the user's device to put the file.
/// In this case we are choosing to use the temp directory.
/// This method is using the path_provider package to get that location.
Future<File> defaultFileLocation(String filename) async {
  final dir = await getTemporaryDirectory();
  return File("${dir.absolute.path}/$filename");
}