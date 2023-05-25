
/// The [Appcast] class is an RSS feed like struct with one channel that has
/// a collection of items that each describe one app version.
///
/// based on the Sparkle framework by Andy Matuschak at:
///     https://sparkle-project.org/documentation/publishing/
///

import 'package:upgrade/models/appcast_item.dart';

class Appcast {
  List<AppcastItem> items;

  Appcast({
    required this.items,
  });

  AppcastItem? best() {
    if (items.isEmpty) { return null; }

    AppcastItem? best;
    for (var item in items) {
      if (item.isSupportingHost()) {
        best ??= item;
        if (item.version > best.version) {
          best = item;
        }
      }
    }
    return best;
  }

  void add(AppcastItem item) {
    items.add(item);
  }

  factory Appcast.fromJson(List<Map<String, dynamic>> json) {
    return Appcast(items: json.map((item) => AppcastItem.fromJson(item)).toList());
  }

  List<Map<String, dynamic>> toJson() {
    return items.map((item) => item.toJson()).toList();
  }
}

