import 'package:fpdart/fpdart.dart';

import '../repository/settings.dart';

class DeleteLatency {
  DeleteLatency(this._settingsRepository);
  final SettingsRepository _settingsRepository;
  Effect<Null, Null, Null> call() => _settingsRepository.deleteLatency();
}
