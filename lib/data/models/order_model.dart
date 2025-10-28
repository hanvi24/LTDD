import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'product_model.dart';

class OrderItem {
  final ProductModel product;
  final int quantity;

  OrderItem({required this.product, required this.quantity});

  double get subtotal => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {'product': product.toMap(), 'quantity': quantity};
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      product: ProductModel.fromMap(Map<String, dynamic>.from(map['product'])),
      quantity: map['quantity'],
    );
  }
}

class OrderModel extends Equatable {
  final String id;
  final DateTime date;
  final double total;
  final List<OrderItem> items;

  const OrderModel({
    required this.id,
    required this.date,
    required this.total,
    required this.items,
  });

  /// Dùng khi lưu xuống SQLite (items -> JSON string)
  Map<String, dynamic> toMapForDb() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'total': total,
      'items': jsonEncode(items.map((e) => e.toMap()).toList()),
    };
  }

  /// Dùng khi lưu lên Firestore
  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date.toIso8601String(),
    'total': total,
    'items': items.map((e) => e.toMap()).toList(),
  };

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      date: DateTime.parse(map['date']),
      total: (map['total'] ?? 0).toDouble(),
      items: (jsonDecode(map['items']) as List<dynamic>)
          .map((e) => OrderItem.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id, date, total, items];
}
