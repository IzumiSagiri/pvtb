import 'dart:async';
import 'dart:math';

import 'package:mvu_layer/mvu.dart';
import 'package:pvtb/presentation/viewmodel/pvt_state.dart';

import '../../logger.dart';

const timeOutDuration = Duration(milliseconds: 355), pvtLength = 180;
Subs<PVTEvent> subscriptions(PVTState model) => [
      if (model is! PVTInitial && model is! PVTFinish)
        (
          ["timer-1"],
          (dispatch) => Timer.periodic(const Duration(seconds: 1),
              (timer) => dispatch(PVTEvent.tick)).cancel
        )
    ];
(PVTState, Cmd<PVTEvent>) init() => (const PVTInitial(), Cmd.none());
(PVTState, Cmd<PVTEvent>) update(
    Duration latency, PVTEvent msg, PVTState model) {
  final (PVTState, Cmd<PVTEvent>) temp = switch (msg) {
    PVTEvent.started => (
        PVTRun(0, PVTResults.start()),
        Cmd.ofFunc(
            () => Future.delayed(
                Duration(milliseconds: (4000 * Random().nextDouble()).toInt())),
            onMissing: PVTEvent.shown)
      ),
    PVTEvent.tick => (
        model.ticker >= pvtLength - 1
            ? PVTFinish(model.results
                .copyWith(log: model.results.log.add(DateTime.now(), 'finish')))
            : model.tick(),
        Cmd.none()
      ),
    PVTEvent.shown when model is PVTRun || model is PVTBlank => (
        PVTShow(
            DateTime.now(),
            model.ticker,
            model.results
                .copyWith(log: model.results.log.add(DateTime.now(), 'show'))),
        Cmd.ofFunc(() => Future.delayed(timeOutDuration + latency),
            onMissing: PVTEvent.missed)
      ),
    PVTEvent.shown => (model, Cmd.none()),
    PVTEvent.tapped when model is PVTShow => switch (
          DateTime.now().difference(model.startTime) - latency) {
        < const Duration(milliseconds: 100) => (
            PVTFalseStart(
                model.ticker,
                model.results.copyWith(
                    falseStarts: model.results.falseStarts + 1,
                    log: model.results.log.add(DateTime.now(), 'early'))),
            Cmd.ofFunc(() => Future.delayed(const Duration(seconds: 1)),
                onMissing: PVTEvent.cleared)
          ),
        > timeOutDuration => (
            PVTMiss(
                model.ticker,
                model.results.copyWith(
                    lapses: model.results.lapses + 1,
                    log: model.results.log.add(DateTime.now(),
                        'late(if_you_see_this_something_went_wrong)'))),
            Cmd.ofFunc(() => Future.delayed(const Duration(seconds: 1)),
                onMissing: PVTEvent.cleared)
          ),
        Duration temp => (
            PVTTap(
                temp,
                model.ticker,
                model.results.copyWith(
                    results: model.results.results.add(temp),
                    log: model.results.log.add(DateTime.now(), 'success'))),
            Cmd.ofFunc(() => Future.delayed(const Duration(seconds: 1)),
                onMissing: PVTEvent.cleared)
          )
      },
    PVTEvent.tapped when model is PVTRun || model is PVTBlank => (
        PVTFalseStart(
            model.ticker,
            model.results.copyWith(
                falseStarts: model.results.falseStarts + 1,
                log: model.results.log.add(DateTime.now(), 'tooearly'))),
        Cmd.ofFunc(() => Future.delayed(const Duration(seconds: 1)),
            onMissing: PVTEvent.cleared)
      ),
    PVTEvent.tapped => (model, Cmd.none()),
    PVTEvent.missed when model is PVTShow => (
        PVTMiss(
            model.ticker,
            model.results.copyWith(
                lapses: model.results.lapses + 1,
                log: model.results.log.add(DateTime.now(), 'missed'))),
        Cmd.ofFunc(() => Future.delayed(const Duration(seconds: 1)),
            onMissing: PVTEvent.cleared)
      ),
    PVTEvent.missed => (model, Cmd.none()),
    PVTEvent.cleared
        when model is PVTFalseStart || model is PVTTap || model is PVTMiss =>
      (
        PVTBlank(model.ticker, model.results),
        Cmd.ofFunc(
            () => Future.delayed(
                Duration(milliseconds: (3000 * Random().nextDouble()).toInt())),
            onMissing: PVTEvent.shown)
      ),
    PVTEvent.cleared => (model, Cmd.none()),
  };
  logger.d('$model -$msg-> ${temp.$1}');
  return temp;
}
