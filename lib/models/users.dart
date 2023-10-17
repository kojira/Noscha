part 'users.g.dart';

import 'package:drift/drift.dart';

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
