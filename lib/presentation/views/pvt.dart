import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mvu_layer/mvu.dart';
import 'package:pvtb/domain/usecase/get_latency.dart';
import 'package:pvtb/domain/usecase/save_result.dart';
import 'package:pvtb/domain/usecase/write_log.dart';

import '../viewmodel/pvt_state.dart';
import '../viewmodel/pvt_update.dart';

class PVT extends StatefulWidget {
  final GetLatency _getLatency;
  final SaveResult _saveResult;
  final WriteLog _writeLog;
  final Directory _directory;
  const PVT(this._getLatency, this._saveResult, this._writeLog, this._directory,
      {super.key});
  @override
  State<PVT> createState() => _PVTState();
}

class _PVTState extends State<PVT> {
  late final _latency = widget._getLatency().runSync();
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(),
      body: MVUBuilder(
          init: init,
          update: (PVTEvent msg, PVTState model) =>
              update(Duration(milliseconds: _latency), msg, model),
          view: (BuildContext context, PVTState state,
                  Dispatch<PVTEvent> dispatch) =>
              switch (state) {
                PVTInitial() => Column(children: [
                    const LinearProgressIndicator(minHeight: 20, value: 1),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: const EdgeInsets.all(24),
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 3),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(7))),
                            child: Text('0 / 0',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.merge(TextStyle(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.bold))))),
                    const SizedBox(height: 96),
                    ElevatedButton(
                        onPressed: () => dispatch(PVTEvent.started),
                        child: const Text('I\'m ready!'))
                  ]),
                PVTFinish() => Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Text('Finished!',
                            style: Theme.of(context).textTheme.displaySmall),
                        const SizedBox(height: 50),
                        Text('Your performance score',
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 25),
                        Text(state.results.finalResult.toString(),
                            style: Theme.of(context).textTheme.displaySmall),
                        const SizedBox(height: 50),
                        Text('Your average RT',
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 25),
                        Text(state.results.finalAverage.toString(),
                            style: Theme.of(context).textTheme.displaySmall),
                        const SizedBox(height: 50),
                        ElevatedButton(
                            onPressed: () => widget
                                ._saveResult(state.results.finalResult,
                                    state.results.finalAverage)
                                .runFuture()
                                .then((_) => context.mounted
                                    ? showDialog(
                                        context: context,
                                        builder: (_) => const AlertDialog(
                                              content: Text('Saved!'),
                                            ))
                                    : null),
                            child: const Text('Save')),
                        const SizedBox(height: 25),
                        ElevatedButton(
                            onPressed: () => widget
                                ._writeLog(const ListToCsvConverter().convert(
                                    state.results.log.entries
                                        .map((_) => [
                                              _.key.millisecondsSinceEpoch,
                                              _.value
                                            ])
                                        .toList()))
                                .runFuture()
                                .then((_) => context.mounted
                                    ? showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              content: Text(
                                                  'Dumped to ${widget._directory.path}'),
                                            ))
                                    : null),
                            child: const Text('Dump log to file'))
                      ])),
                _ => Column(children: [
                    LinearProgressIndicator(
                        minHeight: 20, value: state.ticker / pvtLength),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: const EdgeInsets.all(24),
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 3),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(7))),
                            child: Text(
                                '${state.results.results.length} / ${state.results.falseStarts + state.results.lapses + state.results.results.length}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.merge(TextStyle(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.bold))))),
                    switch (state) {
                      PVTRun() || PVTBlank() => GestureDetector(
                          child:
                              Image.asset('assets/whacamole.png', height: 500),
                          onTapDown: (_) => dispatch(PVTEvent.tapped),
                          onLongPressDown: (_) => dispatch(PVTEvent.tapped),
                          onLongPressStart: (_) => dispatch(PVTEvent.tapped)),
                      PVTFalseStart() => Stack(
                          children: [
                            Image.asset('assets/whacamole3.png', height: 500),
                            const Positioned(
                                top: 100, right: 100, child: Text('too early'))
                          ],
                        ),
                      PVTShow() => GestureDetector(
                          child:
                              Image.asset('assets/whacamole1.png', height: 500),
                          onTapDown: (_) => dispatch(PVTEvent.tapped),
                          onLongPressDown: (_) => dispatch(PVTEvent.tapped),
                          onLongPressStart: (_) => dispatch(PVTEvent.tapped),
                        ),
                      PVTTap() => Stack(
                          children: [
                            Image.asset('assets/whacamole2.png', height: 500),
                            Positioned(
                                top: 100,
                                right: 100,
                                child: Text(
                                    '${state.results.results.last.inMilliseconds} ms'))
                          ],
                        ),
                      PVTMiss() => Stack(
                          children: [
                            Image.asset('assets/whacamole4.png', height: 500),
                            const Positioned(
                                top: 100, right: 100, child: Text('miss'))
                          ],
                        ),
                      _ => const Placeholder()
                    }
                  ])
              },
          subscriptions: subscriptions));
}
