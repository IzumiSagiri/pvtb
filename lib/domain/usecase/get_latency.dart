import 'package:fpdart/fpdart.dart';

import '../repository/settings.dart';

class GetLatency {
  GetLatency(this._settingsRepository);
  final SettingsRepository _settingsRepository;
  Effect<Null, Null, int> call() => _settingsRepository.getLatency();
}
