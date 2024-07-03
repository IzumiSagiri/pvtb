import 'package:fpdart/fpdart.dart';

import '../repository/records.dart';

class DeleteRecord {
  DeleteRecord(this._recordsRepository);
  final RecordsRepository _recordsRepository;
  Effect<Null, Null, Null> call(DateTime key) =>
      _recordsRepository.deleteRecord(key);
}
