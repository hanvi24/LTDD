import 'package:equatable/equatable.dart';
import '../../data/models/order_model.dart';
import '../../data/models/product_model.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object?> get props => [];
}

class LoadOrdersEvent extends OrderEvent {}

class CreateOrderEvent extends OrderEvent {
  final OrderModel order;
  final List<ProductModel> purchased;
  const CreateOrderEvent(this.order, this.purchased);

  @override
  List<Object?> get props => [order, purchased];
}
