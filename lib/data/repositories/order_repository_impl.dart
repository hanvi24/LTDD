import 'package:sqflite/sqflite.dart';
import '../local/order_dao.dart';
import '../local/product_dao.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import 'order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDao orderDao;
  final ProductDao productDao;

  OrderRepositoryImpl(this.orderDao, this.productDao);

  @override
  Future<List<OrderModel>> getAllOrders() async {
    return orderDao.getAllOrders();
  }

  /// ✅ Tạo order và giảm tồn kho (thực hiện trong transaction)
  @override
  Future<void> createOrder(
    OrderModel order,
    List<ProductModel> purchased,
  ) async {
    final db = await orderDao.database;

    try {
      // ✅ Đảm bảo bảng orders tồn tại
      await db.execute('''
        CREATE TABLE IF NOT EXISTS orders(
          id TEXT PRIMARY KEY,
          date TEXT,
          total REAL,
          items TEXT
        )
      ''');

      // ✅ Chạy transaction an toàn
      await db.transaction((txn) async {
        await txn.insert(
          'orders',
          order.toMapForDb(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        print('✅ Đã thêm đơn hàng: ${order.id}');

        // ✅ Giảm tồn kho sản phẩm
        for (var item in order.items) {
          final newStock = item.product.stock - item.quantity;
          await txn.update(
            'products',
            {'stock': newStock},
            where: 'id = ?',
            whereArgs: [item.product.id],
          );
        }
      });
    } catch (e) {
      print('❌ Lỗi khi tạo đơn hàng: $e');
      rethrow;
    }
  }

  @override
  Future<double> getTotalRevenue() async {
    return orderDao.getTotalRevenue();
  }

  @override
  Future<void> deleteOrder(String id) async {
    await orderDao.deleteOrder(id);
  }
}
