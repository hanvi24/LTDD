import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object?> get props => [];
}

class ProductLoadEvent extends ProductEvent {}

class ProductAddEvent extends ProductEvent {
  final ProductModel product;
  const ProductAddEvent(this.product);
  @override
  List<Object?> get props => [product];
}

class ProductUpdateEvent extends ProductEvent {
  final ProductModel product;
  const ProductUpdateEvent(this.product);
  @override
  List<Object?> get props => [product];
}

class ProductDeleteEvent extends ProductEvent {
  final String id;
  const ProductDeleteEvent(this.id);
  @override
  List<Object?> get props => [id];
}
