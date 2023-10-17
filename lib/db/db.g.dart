// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pubkeyHexMeta =
      const VerificationMeta('pubkeyHex');
  @override
  late final GeneratedColumn<String> pubkeyHex = GeneratedColumn<String>(
      'pubkey_hex', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 64, maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _privkeyHexMeta =
      const VerificationMeta('privkeyHex');
  @override
  late final GeneratedColumn<String> privkeyHex = GeneratedColumn<String>(
      'privkey_hex', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 64, maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 16, maxTextLength: 16),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
      'bio', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
      'avatar', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _kind0Meta = const VerificationMeta('kind0');
  @override
  late final GeneratedColumn<String> kind0 = GeneratedColumn<String>(
      'kind0', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updateAtMeta =
      const VerificationMeta('updateAt');
  @override
  late final GeneratedColumn<DateTime> updateAt = GeneratedColumn<DateTime>(
      'update_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        pubkeyHex,
        privkeyHex,
        password,
        name,
        displayName,
        bio,
        avatar,
        kind0,
        updateAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pubkey_hex')) {
      context.handle(_pubkeyHexMeta,
          pubkeyHex.isAcceptableOrUnknown(data['pubkey_hex']!, _pubkeyHexMeta));
    } else if (isInserting) {
      context.missing(_pubkeyHexMeta);
    }
    if (data.containsKey('privkey_hex')) {
      context.handle(
          _privkeyHexMeta,
          privkeyHex.isAcceptableOrUnknown(
              data['privkey_hex']!, _privkeyHexMeta));
    } else if (isInserting) {
      context.missing(_privkeyHexMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('bio')) {
      context.handle(
          _bioMeta, bio.isAcceptableOrUnknown(data['bio']!, _bioMeta));
    } else if (isInserting) {
      context.missing(_bioMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
    } else if (isInserting) {
      context.missing(_avatarMeta);
    }
    if (data.containsKey('kind0')) {
      context.handle(
          _kind0Meta, kind0.isAcceptableOrUnknown(data['kind0']!, _kind0Meta));
    } else if (isInserting) {
      context.missing(_kind0Meta);
    }
    if (data.containsKey('update_at')) {
      context.handle(_updateAtMeta,
          updateAt.isAcceptableOrUnknown(data['update_at']!, _updateAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pubkeyHex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pubkey_hex'])!,
      privkeyHex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}privkey_hex'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      bio: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bio'])!,
      avatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar'])!,
      kind0: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind0'])!,
      updateAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_at']),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String pubkeyHex;
  final String privkeyHex;
  final String password;
  final String name;
  final String displayName;
  final String bio;
  final String avatar;
  final String kind0;
  final DateTime? updateAt;
  const User(
      {required this.id,
      required this.pubkeyHex,
      required this.privkeyHex,
      required this.password,
      required this.name,
      required this.displayName,
      required this.bio,
      required this.avatar,
      required this.kind0,
      this.updateAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pubkey_hex'] = Variable<String>(pubkeyHex);
    map['privkey_hex'] = Variable<String>(privkeyHex);
    map['password'] = Variable<String>(password);
    map['name'] = Variable<String>(name);
    map['display_name'] = Variable<String>(displayName);
    map['bio'] = Variable<String>(bio);
    map['avatar'] = Variable<String>(avatar);
    map['kind0'] = Variable<String>(kind0);
    if (!nullToAbsent || updateAt != null) {
      map['update_at'] = Variable<DateTime>(updateAt);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      pubkeyHex: Value(pubkeyHex),
      privkeyHex: Value(privkeyHex),
      password: Value(password),
      name: Value(name),
      displayName: Value(displayName),
      bio: Value(bio),
      avatar: Value(avatar),
      kind0: Value(kind0),
      updateAt: updateAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updateAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      pubkeyHex: serializer.fromJson<String>(json['pubkeyHex']),
      privkeyHex: serializer.fromJson<String>(json['privkeyHex']),
      password: serializer.fromJson<String>(json['password']),
      name: serializer.fromJson<String>(json['name']),
      displayName: serializer.fromJson<String>(json['displayName']),
      bio: serializer.fromJson<String>(json['bio']),
      avatar: serializer.fromJson<String>(json['avatar']),
      kind0: serializer.fromJson<String>(json['kind0']),
      updateAt: serializer.fromJson<DateTime?>(json['updateAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pubkeyHex': serializer.toJson<String>(pubkeyHex),
      'privkeyHex': serializer.toJson<String>(privkeyHex),
      'password': serializer.toJson<String>(password),
      'name': serializer.toJson<String>(name),
      'displayName': serializer.toJson<String>(displayName),
      'bio': serializer.toJson<String>(bio),
      'avatar': serializer.toJson<String>(avatar),
      'kind0': serializer.toJson<String>(kind0),
      'updateAt': serializer.toJson<DateTime?>(updateAt),
    };
  }

  User copyWith(
          {int? id,
          String? pubkeyHex,
          String? privkeyHex,
          String? password,
          String? name,
          String? displayName,
          String? bio,
          String? avatar,
          String? kind0,
          Value<DateTime?> updateAt = const Value.absent()}) =>
      User(
        id: id ?? this.id,
        pubkeyHex: pubkeyHex ?? this.pubkeyHex,
        privkeyHex: privkeyHex ?? this.privkeyHex,
        password: password ?? this.password,
        name: name ?? this.name,
        displayName: displayName ?? this.displayName,
        bio: bio ?? this.bio,
        avatar: avatar ?? this.avatar,
        kind0: kind0 ?? this.kind0,
        updateAt: updateAt.present ? updateAt.value : this.updateAt,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('pubkeyHex: $pubkeyHex, ')
          ..write('privkeyHex: $privkeyHex, ')
          ..write('password: $password, ')
          ..write('name: $name, ')
          ..write('displayName: $displayName, ')
          ..write('bio: $bio, ')
          ..write('avatar: $avatar, ')
          ..write('kind0: $kind0, ')
          ..write('updateAt: $updateAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pubkeyHex, privkeyHex, password, name,
      displayName, bio, avatar, kind0, updateAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.pubkeyHex == this.pubkeyHex &&
          other.privkeyHex == this.privkeyHex &&
          other.password == this.password &&
          other.name == this.name &&
          other.displayName == this.displayName &&
          other.bio == this.bio &&
          other.avatar == this.avatar &&
          other.kind0 == this.kind0 &&
          other.updateAt == this.updateAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> pubkeyHex;
  final Value<String> privkeyHex;
  final Value<String> password;
  final Value<String> name;
  final Value<String> displayName;
  final Value<String> bio;
  final Value<String> avatar;
  final Value<String> kind0;
  final Value<DateTime?> updateAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.pubkeyHex = const Value.absent(),
    this.privkeyHex = const Value.absent(),
    this.password = const Value.absent(),
    this.name = const Value.absent(),
    this.displayName = const Value.absent(),
    this.bio = const Value.absent(),
    this.avatar = const Value.absent(),
    this.kind0 = const Value.absent(),
    this.updateAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String pubkeyHex,
    required String privkeyHex,
    required String password,
    required String name,
    required String displayName,
    required String bio,
    required String avatar,
    required String kind0,
    this.updateAt = const Value.absent(),
  })  : pubkeyHex = Value(pubkeyHex),
        privkeyHex = Value(privkeyHex),
        password = Value(password),
        name = Value(name),
        displayName = Value(displayName),
        bio = Value(bio),
        avatar = Value(avatar),
        kind0 = Value(kind0);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? pubkeyHex,
    Expression<String>? privkeyHex,
    Expression<String>? password,
    Expression<String>? name,
    Expression<String>? displayName,
    Expression<String>? bio,
    Expression<String>? avatar,
    Expression<String>? kind0,
    Expression<DateTime>? updateAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pubkeyHex != null) 'pubkey_hex': pubkeyHex,
      if (privkeyHex != null) 'privkey_hex': privkeyHex,
      if (password != null) 'password': password,
      if (name != null) 'name': name,
      if (displayName != null) 'display_name': displayName,
      if (bio != null) 'bio': bio,
      if (avatar != null) 'avatar': avatar,
      if (kind0 != null) 'kind0': kind0,
      if (updateAt != null) 'update_at': updateAt,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? pubkeyHex,
      Value<String>? privkeyHex,
      Value<String>? password,
      Value<String>? name,
      Value<String>? displayName,
      Value<String>? bio,
      Value<String>? avatar,
      Value<String>? kind0,
      Value<DateTime?>? updateAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      pubkeyHex: pubkeyHex ?? this.pubkeyHex,
      privkeyHex: privkeyHex ?? this.privkeyHex,
      password: password ?? this.password,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
      kind0: kind0 ?? this.kind0,
      updateAt: updateAt ?? this.updateAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pubkeyHex.present) {
      map['pubkey_hex'] = Variable<String>(pubkeyHex.value);
    }
    if (privkeyHex.present) {
      map['privkey_hex'] = Variable<String>(privkeyHex.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (kind0.present) {
      map['kind0'] = Variable<String>(kind0.value);
    }
    if (updateAt.present) {
      map['update_at'] = Variable<DateTime>(updateAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('pubkeyHex: $pubkeyHex, ')
          ..write('privkeyHex: $privkeyHex, ')
          ..write('password: $password, ')
          ..write('name: $name, ')
          ..write('displayName: $displayName, ')
          ..write('bio: $bio, ')
          ..write('avatar: $avatar, ')
          ..write('kind0: $kind0, ')
          ..write('updateAt: $updateAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $UsersTable users = $UsersTable(this);
  late final UserDao userDao = UserDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [users];
}
