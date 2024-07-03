import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pvtb/domain/usecase/get_latency.dart';
import 'package:pvtb/domain/usecase/save_result.dart';
import 'package:pvtb/domain/usecase/write_log.dart';
import 'package:pvtb/presentation/views/pvt.dart';

class PVTIntroduction extends StatelessWidget {
  final GetLatency _getLatency;
  final SaveResult _saveResult;
  final WriteLog _writeLog;
  final Directory _directory;
  const PVTIntroduction(
      this._getLatency, this._saveResult, this._writeLog, this._directory,
      {super.key});
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Text(
            'This is a PVT-B test based on Mathias Basner\'s paper published in 2011.\n\nYou whack the mole as soon as it appears, and the reaction time is calculated.\n\nResponses without a stimulus or RTs<100 ms are counted as false starts.\n\nLapses are defined as RTs≥355 ms.\n\nThe performance score is calculated as 100% minus the number of lapses and false starts relative to the number of valid stimuli and false starts.\n\n',
            style: Theme.of(context).textTheme.bodyMedium),
        Text(
            'This test takes 3 minutes.\n\nMost people will feel that this is a little too long.\n\nThis is necessary to test your sleep deprivation.\n\nPlease try to be patient!',
            style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 48),
        ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) =>
                    PVT(_getLatency, _saveResult, _writeLog, _directory))),
            child: const Text('Start'))
      ]));
}
