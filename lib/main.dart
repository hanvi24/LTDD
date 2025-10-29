import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'di/injection_container.dart' as di;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⚙️ Khởi tạo dependency và DB
  await di.init();

  runApp(const MyApp());
}
