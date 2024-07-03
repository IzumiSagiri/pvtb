import 'package:fpdart/fpdart.dart';
import '../repository/settings.dart';

class SetLatency {
  SetLatency(this._settingsRepository);
  final SettingsRepository _settingsRepository;
  Effect<Null, Null, Null> call(double latency) =>
      _settingsRepository.setLatency(latency);
}
