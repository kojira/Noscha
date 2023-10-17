import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:my_app/dao/users_dao.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'db.g.dart';

@DataClassName('User')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pubkeyHex => text().withLength(min: 64, max: 64)();
  TextColumn get privkeyHex => text().withLength(min: 64, max: 64)();
  TextColumn get password => text().withLength(min: 16, max: 16)();
  TextColumn get name => text()();
  TextColumn get displayName => text()();
  TextColumn get bio => text()();
  TextColumn get avatar => text()();
  TextColumn get kind0 => text()();
  DateTimeColumn get updateAt => dateTime().nullable()();
}

@DriftDatabase(tables: [Users], daos: [UserDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'noscha.db'));
    return NativeDatabase(file);
  });
}
