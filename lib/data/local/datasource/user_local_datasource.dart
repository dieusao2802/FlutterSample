import 'package:sqflite/sqflite.dart';
import 'package:todo_list/data/local/database/user_database.dart';
import 'package:todo_list/data/models/user_model.dart';

class UserLocalDatasource {
  final AppDatabase _db;

  UserLocalDatasource(this._db);

  Future<void> insert(UserModel user) async {
    final db = await _db.database;
    await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<UserModel?> getByEmail(String email) async {
    final db = await _db.database;
    final maps = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }

  Future<void> deleteAll() async {
    final db = await _db.database;
    await db.delete('users');
  }
}
