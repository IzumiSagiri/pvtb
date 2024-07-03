import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pvtb/data/repository/records_impl.dart';
import 'package:pvtb/data/repository/settings_impl.dart';
import 'package:pvtb/data/repository/storage_impl.dart';
import 'package:pvtb/presentation/app.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/timestamp.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance(),
      settingsRepository = SettingsRepositoryImpl(prefs),
      dbFactory = databaseFactoryIo,
      appDocumentsDir = await getApplicationDocumentsDirectory(),
      extStorageDir = await getExternalStorageDirectory(),
      db = await dbFactory.openDatabase('${appDocumentsDir.path}/0.db'),
      store = StoreRef<Timestamp, List>.main(),
      recordsRepository = RecordsRepositoryImpl(store, db),
      storageRepository = StorageRepositoryImpl(extStorageDir!);
  runApp(MyApp(
      settingsRepository, recordsRepository, storageRepository, extStorageDir));
}
