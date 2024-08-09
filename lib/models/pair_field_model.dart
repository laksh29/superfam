// abstract class to help define it in schema to avoid confusions

class PairFields {
  static const List<String> values = [
    id,
    key,
    value,
    createdTime,
  ];

  static const String tableName = "pairs";
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = "TEXT NOT NULL";
  static const String intType = "INTEGER NOT NULL";
  static const String id = "_id";
  static const String key = "key";
  static const String value = "value";
  static const String createdTime = "created_time";
}
