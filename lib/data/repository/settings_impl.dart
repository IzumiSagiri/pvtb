import 'package:fpdart/fpdart.dart';
import 'package:pvtb/domain/repository/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../source/database/shared_preferences.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._sharedPreferences);
  final SharedPreferences _sharedPreferences;
  @override
  Effect<Null, Null, int> getLatency() => get().provideEnv(_sharedPreferences);
  @override
  Effect<Null, Null, Null> setLatency(double latency) =>
      set(latency).provideEnv(_sharedPreferences);
  @override
  Effect<Null, Null, Null> deleteLatency() =>
      delete().provideEnv(_sharedPreferences);
  @override
  Effect<Null, Null, bool> getSeen() => get2().provideEnv(_sharedPreferences);
  @override
  Effect<Null, Null, Null> setSeen() => set2().provideEnv(_sharedPreferences);
}
