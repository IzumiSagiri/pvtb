import 'package:fpdart/fpdart.dart';
import '../repository/settings.dart';

class SetSeen {
  SetSeen(this._settingsRepository);
  final SettingsRepository _settingsRepository;
  Effect<Null, Null, Null> call() => _settingsRepository.setSeen();
}
