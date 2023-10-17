import 'package:drift/drift.dart';
import 'package:my_app/db/db.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(db) : super(db);

  Future<void> insertUser(UsersCompanion user) {
    return into(users).insert(user);
  }
}
