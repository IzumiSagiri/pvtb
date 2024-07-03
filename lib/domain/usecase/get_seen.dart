import 'package:fpdart/fpdart.dart';

import '../repository/settings.dart';

class GetSeen {
  GetSeen(this._settingsRepository);
  final SettingsRepository _settingsRepository;
  Effect<Null, Null, bool> call() => _settingsRepository.getSeen();
}
