import 'package:sqflite/sqflite.dart';
import 'app_database.dart';

class UserDao {
  Future<int> insertUser(String username, String password) async {
    final db = await AppDatabase.instance.database;
    return db.insert('users', {
      'username': username,
      'password': password,
    }, conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<Map<String, dynamic>?> getUser(
    String username,
    String password,
  ) async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<bool> usernameExists(String username) async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }
}
