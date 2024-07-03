import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

Effect<SharedPreferences, Null, int> get() =>
    Effect<SharedPreferences, Null, int>.gen(($) {
      final prefs = $.sync<SharedPreferences>(Effect.env());
      if (prefs.containsKey('latency')) {
        return prefs.getInt('latency') ?? 47;
      } else {
        return 47;
      }
    });
Effect<SharedPreferences, Null, Null> set(double latency) =>
    Effect<SharedPreferences, Null, Null>.gen(($) {
      final prefs = $.sync<SharedPreferences>(Effect.env());
      prefs.setInt('latency', latency.round());
    });
Effect<SharedPreferences, Null, Null> delete() =>
    Effect<SharedPreferences, Null, Null>.gen(($) {
      final prefs = $.sync<SharedPreferences>(Effect.env());
      prefs.remove('latency');
    });
Effect<SharedPreferences, Null, bool> get2() =>
    Effect<SharedPreferences, Null, bool>.gen(($) {
      final prefs = $.sync<SharedPreferences>(Effect.env());
      if (prefs.containsKey('seen')) {
        return prefs.getBool('seen') ?? false;
      } else {
        return false;
      }
    });
Effect<SharedPreferences, Null, Null> set2() =>
    Effect<SharedPreferences, Null, Null>.gen(($) {
      final prefs = $.sync<SharedPreferences>(Effect.env());
      prefs.setBool('seen', true);
    });
