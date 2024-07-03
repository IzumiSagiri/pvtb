import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fpdart/fpdart.dart';

import '../repository/records.dart';

class GetRecords {
  GetRecords(this._recordsRepository);
  final RecordsRepository _recordsRepository;
  Effect<Null, Null, IMap<DateTime, IList<int>>> call() =>
      _recordsRepository.getRecords();
}
