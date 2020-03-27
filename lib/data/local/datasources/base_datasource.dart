import 'package:sembast/sembast.dart';

class BaseDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _store = StoreRef.main();

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
//  Future<Database> get _db async => await AppDatabase.instance.database;

  // database instance
  final Future<Database> _db;

  // Constructor
  BaseDataSource(this._db);

  // DB functions:--------------------------------------------------------------
  Future save() async {
    return await _store.record(getKey()).put(await _db, toJson);
  }

  String getKey() {
    return 'key';
  }

  Map<String, dynamic> get toJson => <String, dynamic>{};

  void fromJson(Map<String, dynamic> json) {}

  Future restore() async {
    try {
      final Map<String, dynamic> data =
          await _store.record(getKey()).get(await _db) as Map<String, dynamic>;
      fromJson(data);
    } catch (e) {
      print(e);
    }
  }
}
