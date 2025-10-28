import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_event.dart';
import 'order_state.dart';
import '../../data/repositories/order_repository.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repo;

  OrderBloc({required this.repo}) : super(OrderInitial()) {
    on<LoadOrdersEvent>(_onLoadOrders);
    on<CreateOrderEvent>(_onCreateOrder);
  }

  /// Load danh sách đơn hàng
  Future<void> _onLoadOrders(
    LoadOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final orders = await repo.getAllOrders();
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderFailure('Không thể tải danh sách đơn hàng: $e'));
    }
  }

  /// Tạo đơn hàng mới và giảm tồn kho sản phẩm
  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      await repo.createOrder(event.order, event.purchased);
      final updatedOrders = await repo.getAllOrders();
      emit(OrderLoaded(updatedOrders));
    } catch (e) {
      emit(OrderFailure('Không thể tạo đơn hàng: $e'));
    }
  }
}
