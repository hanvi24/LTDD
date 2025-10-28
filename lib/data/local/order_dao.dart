import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/order_model.dart';

class OrderDao {
  static const _databaseName = "app_database.db";
  static const _tableOrders = "orders";

  Future<Database> get database async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, _databaseName),
      version: 3, // ✅ Tăng version lên để chắc chắn onUpgrade chạy lại
      onCreate: (db, version) async {
        // ✅ Tạo bảng orders khi DB mới
        await db.execute('''
          CREATE TABLE $_tableOrders(
            id TEXT PRIMARY KEY,
            date TEXT,
            total REAL,
            items TEXT
          )
        ''');
        print('✅ Tạo bảng $_tableOrders khi khởi tạo DB');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // ✅ Nếu DB cũ hơn version hiện tại, đảm bảo bảng tồn tại
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $_tableOrders(
              id TEXT PRIMARY KEY,
              date TEXT,
              total REAL,
              items TEXT
            )
          ''');
          print('⚙️ Đã đảm bảo bảng $_tableOrders tồn tại (upgrade)');
        }
      },
      onOpen: (db) async {
        // ✅ Kiểm tra bảng tồn tại khi mở DB
        final tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table';",
        );
        print('📦 Các bảng hiện có: ${tables.map((e) => e['name']).toList()}');
      },
    );
  }

  /// Lấy tất cả đơn hàng
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final db = await database;
      final maps = await db.query(_tableOrders, orderBy: 'date DESC');
      print('📥 Lấy ${maps.length} đơn hàng từ DB');
      return maps.map((e) => OrderModel.fromMap(e)).toList();
    } catch (e) {
      print('❌ Lỗi khi lấy danh sách đơn hàng: $e');
      return [];
    }
  }

  /// Thêm đơn hàng mới
  Future<void> insertOrder(OrderModel order) async {
    try {
      final db = await database;
      await db.insert(
        _tableOrders,
        order.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('✅ Đã thêm đơn hàng: ${order.id}');
    } catch (e) {
      print('❌ Lỗi khi thêm đơn hàng: $e');
    }
  }

  /// Xóa đơn hàng
  Future<void> deleteOrder(String id) async {
    try {
      final db = await database;
      await db.delete(_tableOrders, where: 'id = ?', whereArgs: [id]);
      print('🗑️ Đã xóa đơn hàng $id');
    } catch (e) {
      print('❌ Lỗi khi xóa đơn hàng: $e');
    }
  }

  /// Tính tổng doanh thu tất cả đơn hàng
  Future<double> getTotalRevenue() async {
    try {
      final db = await database;
      final result = await db.rawQuery(
        'SELECT SUM(total) as sumTotal FROM $_tableOrders',
      );
      final value = result.first['sumTotal'];
      if (value == null) return 0.0;
      final sum = (value as num).toDouble();
      print('💰 Tổng doanh thu: $sum');
      return sum;
    } catch (e) {
      print('❌ Lỗi khi tính doanh thu: $e');
      return 0.0;
    }
  }
}
