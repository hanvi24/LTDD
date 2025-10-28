import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String? sku;
  final double price;
  final int stock;
  final int? updatedAt;

  const ProductModel({
    required this.id,
    required this.name,
    this.sku,
    required this.price,
    required this.stock,
    this.updatedAt,
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? sku,
    double? price,
    int? stock,
    int? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'price': price,
      'stock': stock,
      'updated_at': updatedAt ?? DateTime.now().millisecondsSinceEpoch,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      sku: map['sku'] as String?,
      price: (map['price'] as num).toDouble(),
      stock: (map['stock'] as num).toInt(),
      updatedAt: map['updated_at'] as int?,
    );
  }

  @override
  List<Object?> get props => [id, name, sku, price, stock, updatedAt];
}
