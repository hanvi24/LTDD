import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../../data/repositories/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc({required this.repository}) : super(ProductInitial()) {
    on<ProductLoadEvent>(_onLoad);
    on<ProductAddEvent>(_onAdd);
    on<ProductUpdateEvent>(_onUpdate);
    on<ProductDeleteEvent>(_onDelete);
  }

  Future<void> _onLoad(ProductLoadEvent event, Emitter emit) async {
    emit(ProductLoading());
    try {
      final products = await repository.getAllProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }

  Future<void> _onAdd(ProductAddEvent event, Emitter emit) async {
    try {
      await repository.addProduct(event.product);
      final products = await repository.getAllProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }

  Future<void> _onUpdate(ProductUpdateEvent event, Emitter emit) async {
    try {
      await repository.updateProduct(event.product);
      final products = await repository.getAllProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }

  Future<void> _onDelete(ProductDeleteEvent event, Emitter emit) async {
    try {
      await repository.deleteProduct(event.id);
      final products = await repository.getAllProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }
}
