import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

final class PVTResults {
  final int falseStarts, lapses;
  final IList<Duration> results;
  final IMap<DateTime, String> log;
  const PVTResults(
      {required this.falseStarts,
      required this.lapses,
      required this.results,
      required this.log});
  const PVTResults.empty()
      : falseStarts = 0,
        lapses = 0,
        results = const IList.empty(),
        log = const IMap.empty();
  PVTResults.start()
      : falseStarts = 0,
        lapses = 0,
        results = const IList.empty(),
        log = <DateTime, String>{DateTime.now(): 'start'}.lock;
  PVTResults copyWith(
          {counter, falseStarts, lapses, appearCount, results, log}) =>
      PVTResults(
          falseStarts: falseStarts ?? this.falseStarts,
          lapses: lapses ?? this.lapses,
          results: results ?? this.results,
          log: log ?? this.log);
  int get finalResult =>
      100 * results.length ~/ (falseStarts + lapses + results.length);
  int get finalAverage => results.isEmpty
      ? 0
      : results.map((_) => _.inMilliseconds).average.toInt();
}

sealed class PVTState {
  final int ticker;
  final PVTResults results;
  const PVTState(this.ticker, this.results);
  PVTState tick();
}

final class PVTInitial extends PVTState {
  const PVTInitial() : super(0, const PVTResults.empty());
  @override
  PVTState tick() {
    throw UnimplementedError();
  }

  @override
  String toString() {
    return 'PVTInitial';
  }
}

final class PVTRun extends PVTState {
  const PVTRun(super.ticker, super.results);
  @override
  PVTRun tick() => PVTRun(ticker + 1, results);
  @override
  String toString() {
    return 'PVTRun($ticker, false: ${results.falseStarts}, lapse: ${results.lapses}, results: ${results.results.length})';
  }
}

final class PVTFalseStart extends PVTState {
  const PVTFalseStart(super.ticker, super.results);
  @override
  PVTFalseStart tick() => PVTFalseStart(ticker + 1, results);
  @override
  String toString() {
    return 'PVTFalseStart($ticker, false: ${results.falseStarts}, lapse: ${results.lapses}, results: ${results.results.length})';
  }
}

final class PVTShow extends PVTState {
  final DateTime startTime;
  const PVTShow(this.startTime, super.ticker, super.results);
  @override
  PVTShow tick() => PVTShow(startTime, ticker + 1, results);
  @override
  String toString() {
    return 'PVTShow($ticker, startTime: $startTime, false: ${results.falseStarts}, lapse: ${results.lapses}, results: ${results.results.length})';
  }
}

final class PVTTap extends PVTState {
  final Duration _result;
  const PVTTap(this._result, super.ticker, super.results);
  @override
  PVTTap tick() => PVTTap(_result, ticker + 1, results);
  @override
  String toString() {
    return 'PVTTap($ticker, false: ${results.falseStarts}, lapse: ${results.lapses}, results: ${results.results.length})';
  }
}

final class PVTMiss extends PVTState {
  const PVTMiss(super.ticker, super.results);
  @override
  PVTMiss tick() => PVTMiss(ticker + 1, results);
  @override
  String toString() {
    return 'PVTMiss($ticker, false: ${results.falseStarts}, lapse: ${results.lapses}, results: ${results.results.length})';
  }
}

final class PVTBlank extends PVTState {
  const PVTBlank(super.ticker, super.results);
  @override
  PVTBlank tick() => PVTBlank(ticker + 1, results);
  @override
  String toString() {
    return 'PVTBlank($ticker, false: ${results.falseStarts}, lapse: ${results.lapses}, results: ${results.results.length})';
  }
}

final class PVTFinish extends PVTState {
  const PVTFinish(results) : super(0, results);
  @override
  PVTState tick() {
    throw UnimplementedError();
  }

  @override
  String toString() {
    return 'PVTFinish($ticker, false: ${results.falseStarts}, lapse: ${results.lapses}, results: ${results.results.length})';
  }
}

enum PVTEvent {
  started,
  tick,
  shown,
  tapped,
  missed,
  cleared,
}
