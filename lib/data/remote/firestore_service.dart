import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // PRODUCTS
  Future<void> uploadProduct(ProductModel product) async {
    await firestore.collection('products').doc(product.id).set(product.toMap());
  }

  Future<List<ProductModel>> fetchProducts() async {
    final snapshot = await firestore.collection('products').get();
    return snapshot.docs.map((d) => ProductModel.fromMap(d.data())).toList();
  }

  // ORDERS
  Future<void> uploadOrder(OrderModel order) async {
    await firestore.collection('orders').doc(order.id).set(order.toMap());
  }

  Future<List<OrderModel>> fetchOrders() async {
    final snapshot = await firestore.collection('orders').get();
    return snapshot.docs.map((d) => OrderModel.fromMap(d.data())).toList();
  }

  // Delete all (optional)
  Future<void> clearAll() async {
    final prods = await firestore.collection('products').get();
    for (var doc in prods.docs) {
      await doc.reference.delete();
    }
    final orders = await firestore.collection('orders').get();
    for (var doc in orders.docs) {
      await doc.reference.delete();
    }
  }
}
