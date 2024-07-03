import 'package:fpdart/fpdart.dart';

import '../repository/records.dart';

class SaveResult {
  SaveResult(this._recordsRepository);
  final RecordsRepository _recordsRepository;
  Effect<Null, Null, Null> call(int result, int average) =>
      _recordsRepository.saveRecord(result, average);
}
