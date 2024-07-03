import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:pvtb/domain/usecase/delete_latency.dart';
import 'package:pvtb/domain/usecase/delete_record.dart';
import 'package:pvtb/domain/usecase/get_latency.dart';
import 'package:pvtb/domain/usecase/get_records.dart';
import 'package:pvtb/domain/usecase/get_seen.dart';
import 'package:pvtb/domain/usecase/save_result.dart';
import 'package:pvtb/domain/usecase/set_seen.dart';
import 'package:pvtb/domain/usecase/write_log.dart';
import 'package:pvtb/presentation/views/pvt_introduction.dart';
import 'package:pvtb/presentation/views/settings.dart';

import '../../domain/usecase/set_latency.dart';
import 'data.dart';

class MyHomePage extends StatefulWidget {
  final GetSeen _getSeen;
  final SetSeen _setSeen;
  final GetRecords _getRecords;
  final DeleteRecord _deleteRecord;
  final GetLatency _getLatency;
  final SetLatency _setLatency;
  final DeleteLatency _deleteLatency;
  final SaveResult _saveResult;
  final WriteLog _writeLog;
  final Directory _directory;
  const MyHomePage(
      this._getSeen,
      this._setSeen,
      this._getRecords,
      this._deleteRecord,
      this._getLatency,
      this._setLatency,
      this._deleteLatency,
      this._saveResult,
      this._writeLog,
      this._directory,
      {super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool _seen = widget._getSeen().runSync();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) => _seen
      ? Scaffold(
          appBar: [
            AppBar(title: const Text('Test your sleepiness')),
            AppBar(title: const Text('Your data')),
            AppBar(title: const Text('Settings'))
          ].elementAt(_currentIndex),
          body: [
            PVTIntroduction(widget._getLatency, widget._saveResult,
                widget._writeLog, widget._directory),
            Data(widget._getRecords, widget._deleteRecord),
            Settings(
                widget._getLatency, widget._setLatency, widget._deleteLatency)
          ].elementAt(_currentIndex),
          bottomNavigationBar: NavigationBar(
              destinations: const [
                NavigationDestination(
                    icon: Icon(Icons.videogame_asset), label: 'Test'),
                NavigationDestination(
                  icon: Icon(Icons.table_rows),
                  label: 'Track',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                )
              ],
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) =>
                  setState(() => _currentIndex = index)))
      : IntroductionScreen(
          pages: [
              PageViewModel(
                  title: 'A Whac-A-Mole PVT-B test',
                  body: 'A 3 min PVT test to check your sleepiness.',
                  image: Center(child: Image.asset('assets/1.png'))),
              PageViewModel(
                  title: 'Sleep-deprived person gets lower score',
                  body:
                      'If you\'re sleepy, you can\'t focus and miss more hits.',
                  image: Center(child: Image.asset('assets/2.png'))),
              PageViewModel(
                  title:
                      'Sleep-deprived person has slightly longer reaction time',
                  body:
                      'If you\'re sleepy, your reaction time is slightly slower.\nYour performance score is probably more useful than your reaction time.',
                  image: Center(child: Image.asset('assets/3.png')))
            ],
          onDone: () {
            widget._setSeen().runFuture();
            setState(() => _seen = true);
          },
          next: const Icon(Icons.navigate_next),
          done: const Text('Done',
              style: TextStyle(fontWeight: FontWeight.w600)));
}
