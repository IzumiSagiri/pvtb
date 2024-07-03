import 'package:fpdart/fpdart.dart';

import '../repository/storage.dart';

class WriteLog {
  WriteLog(this._storageRepository);
  final StorageRepository _storageRepository;
  Effect<Null, Null, Null> call(String contents) =>
      _storageRepository.writeLog(contents);
}
