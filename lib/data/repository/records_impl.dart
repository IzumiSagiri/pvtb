import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pvtb/domain/repository/records.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/timestamp.dart';

import '../source/database/sembast_service.dart';

class RecordsRepositoryImpl implements RecordsRepository {
  const RecordsRepositoryImpl(this._storeRef, this._database);
  final StoreRef<Timestamp, List> _storeRef;
  final Database _database;
  @override
  Effect<Null, Null, IMap<DateTime, IList<int>>> getRecords() =>
      get().provideEnv((storeRef: _storeRef, database: _database));
  @override
  Effect<Null, Null, Null> deleteRecord(DateTime key) =>
      delete(key).provideEnv((storeRef: _storeRef, database: _database));
  @override
  Effect<Null, Null, Null> saveRecord(int result, int average) =>
      save(result, average)
          .provideEnv((storeRef: _storeRef, database: _database));
}
