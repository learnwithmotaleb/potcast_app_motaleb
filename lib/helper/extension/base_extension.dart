import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/helper/local_db/local_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension BasePathExtensions on String {
  String get addBasePath {
    return RoutePath.basePath + this;
  }
}

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}


extension BannerHelper on DBHelper {
  static const String _lastBannerTime = "last_banner_time";

  Future<bool> shouldShowBanner({int secondsGap = 30}) async {
    final prefs = await SharedPreferences.getInstance();
    final lastShown = prefs.getString(_lastBannerTime);
    final now = DateTime.now();

    if (lastShown == null) {
      return true; // First time
    }

    final diff = now.difference(DateTime.parse(lastShown)).inSeconds;
    return diff >= secondsGap;
  }

  Future<void> markBannerShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastBannerTime, DateTime.now().toIso8601String());
  }
}

