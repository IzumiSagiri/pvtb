import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/timestamp.dart';

Effect<Env, Null, IMap<DateTime, IList<int>>> get() =>
    Effect<Env, Null, IMap<DateTime, IList<int>>>.gen(($) async {
      final (:storeRef, :database) = $.sync<Env>(Effect.env());
      final data = await storeRef.find(database);
      return Map.fromEntries(data.map<MapEntry<DateTime, IList<int>>>((e) =>
          MapEntry<DateTime, IList<int>>(
              e.key.toDateTime(), e.value.cast<int>().lock))).lock;
    });
Effect<Env, Null, Null> delete(DateTime key) =>
    Effect<Env, Null, Null>.gen(($) {
      final (:storeRef, :database) = $.sync<Env>(Effect.env());
      storeRef.record(Timestamp.fromDateTime(key)).delete(database);
    });
Effect<Env, Null, Null> save(int result, int average) =>
    Effect<Env, Null, Null>.gen(($) {
      final (:storeRef, :database) = $.sync<Env>(Effect.env());
      storeRef.record(Timestamp.now()).put(database, [result, average]);
    });
typedef Env = ({StoreRef<Timestamp, List> storeRef, Database database});
