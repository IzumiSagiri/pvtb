import 'package:fpdart/fpdart.dart';

abstract class StorageRepository {
  Effect<Null, Null, Null> writeLog(String contents);
}
