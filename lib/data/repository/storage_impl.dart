import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:pvtb/domain/repository/storage.dart';

import '../source/local/storage.dart';

class StorageRepositoryImpl implements StorageRepository {
  const StorageRepositoryImpl(this._directory);
  final Directory _directory;
  @override
  Effect<Null, Null, Null> writeLog(String contents) =>
      write(contents).provideEnv(_directory);
}
