import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fpdart/fpdart.dart';

abstract class RecordsRepository {
  Effect<Null, Null, IMap<DateTime, IList<int>>> getRecords();
  Effect<Null, Null, Null> deleteRecord(DateTime key);
  Effect<Null, Null, Null> saveRecord(int result, int average);
}
