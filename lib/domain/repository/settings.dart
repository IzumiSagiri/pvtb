import 'package:fpdart/fpdart.dart';

abstract class SettingsRepository {
  Effect<Null, Null, int> getLatency();
  Effect<Null, Null, Null> setLatency(double latency);
  Effect<Null, Null, Null> deleteLatency();
  Effect<Null, Null, bool> getSeen();
  Effect<Null, Null, Null> setSeen();
}
