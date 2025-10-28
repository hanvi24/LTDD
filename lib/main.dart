import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'app.dart';
import 'di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⚠️ XÓA DB CŨ (chạy 1 lần)
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'app_database.db');

  await di.init(); // khởi tạo lại DB và dependency
  runApp(const MyApp());
}
