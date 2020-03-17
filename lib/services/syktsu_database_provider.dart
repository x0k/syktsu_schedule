import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db_config.dart';

import 'services/database_provider.dart';

class SyktsuDatabaseProvider extends DatabaseProvider {
  SyktsuDatabaseProvider._privateConstructor();
  static final SyktsuDatabaseProvider instance =
      SyktsuDatabaseProvider._privateConstructor();

  Database _database;

  @override
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _createDatabase();
    return _database;
  }

  _createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    var database = await openDatabase(path,
        version: dbVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return database;
  }

  void _onUpgrade(Database database, int oldVersion, int newVersion) {}
  void _onCreate(Database database, int version) async {
    await Future.wait(sqlCommands.map((command) => database.execute(command)));
  }
}
