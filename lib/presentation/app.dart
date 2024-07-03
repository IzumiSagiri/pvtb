import 'dart:io';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pvtb/domain/repository/records.dart';
import 'package:pvtb/domain/repository/settings.dart';
import 'package:pvtb/domain/repository/storage.dart';
import 'package:pvtb/domain/usecase/delete_latency.dart';
import 'package:pvtb/domain/usecase/delete_record.dart';
import 'package:pvtb/domain/usecase/get_latency.dart';
import 'package:pvtb/domain/usecase/get_records.dart';
import 'package:pvtb/domain/usecase/get_seen.dart';
import 'package:pvtb/domain/usecase/save_result.dart';
import 'package:pvtb/domain/usecase/set_latency.dart';
import 'package:pvtb/domain/usecase/write_log.dart';
import 'package:pvtb/presentation/views/home.dart';

import '../domain/usecase/set_seen.dart';

class MyApp extends StatelessWidget {
  final SettingsRepository _settingsRepository;
  final RecordsRepository _recordsRepository;
  final StorageRepository _storageRepository;
  final Directory _directory;
  const MyApp(this._settingsRepository, this._recordsRepository,
      this._storageRepository, this._directory,
      {super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'PVT',
      theme: FlexThemeData.light(
              scheme: FlexScheme.gold,
              surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
              blendLevel: 20,
              appBarOpacity: 0.95,
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              useMaterial3: true)
          .copyWith(
              textTheme: GoogleFonts.ralewayTextTheme(FlexThemeData.light(
        scheme: FlexScheme.gold,
      ).textTheme)
                  .merge(TextTheme(
                      displayLarge: GoogleFonts.scopeOne(),
                      displaySmall: GoogleFonts.scopeOne(),
                      titleLarge: GoogleFonts.scopeOne(),
                      titleMedium: GoogleFonts.scopeOne(),
                      bodyLarge: TextStyle(
                          color: FlexThemeData.light(
                            scheme: FlexScheme.gold,
                          ).primaryColorDark,
                          fontWeight: FontWeight.w500),
                      bodyMedium: TextStyle(
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w500),
                      labelLarge:
                          GoogleFonts.raleway(fontWeight: FontWeight.bold)))),
      home: MyHomePage(
          GetSeen(_settingsRepository),
          SetSeen(_settingsRepository),
          GetRecords(_recordsRepository),
          DeleteRecord(_recordsRepository),
          GetLatency(_settingsRepository),
          SetLatency(_settingsRepository),
          DeleteLatency(_settingsRepository),
          SaveResult(_recordsRepository),
          WriteLog(_storageRepository),
          _directory));
}
