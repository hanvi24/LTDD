// lib/data/repositories/order_repository.dart
import '../models/order_model.dart';
import '../models/product_model.dart';

/// Repository trừu tượng cho Order
abstract class OrderRepository {
  Future<List<OrderModel>> getAllOrders();
  Future<void> createOrder(OrderModel order, List<ProductModel> purchased);
  Future<double> getTotalRevenue();
  Future<void> deleteOrder(String id);
}
