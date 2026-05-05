import 'package:sqflite/sqflite.dart';
import 'package:todo_list/data/services/database_service.dart';
import 'package:todo_list/model/user.dart';

class UserDbService {
  final DatabaseService _dbService;

  UserDbService(this._dbService);

  Future<void> insertUser(User user) async {
    final db = await _dbService.database;
    await db.insert(
      'users',
      user.toMap(), // Sử dụng toMap() đã định nghĩa trong Model
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUser(String email) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('users', where: 'email = ?', whereArgs: [email]);

    if (maps.isEmpty) return null;

    // Sử dụng factory fromMap để convert dữ liệu tự động
    return User.fromMap(maps[0]);
  }

  Future<bool> removeUser() async {
    final db = await _dbService.database;
    await db.delete('users');
    return true;
  }
}
