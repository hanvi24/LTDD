import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../logic/product/product_bloc.dart';
import '../../logic/product/product_event.dart';
import '../../logic/product/product_state.dart';
import '../widgets/product_card.dart';
import 'product_form_page.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = Get.find<ProductRepository>();
    return BlocProvider(
      create: (_) =>
          ProductBloc(repository: repository)..add(ProductLoadEvent()),
      child: const ProductView(),
    );
  }
}

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final uuid = Get.find<Uuid>();
    return Scaffold(
      appBar: AppBar(title: const Text('Sản phẩm')),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading || state is ProductInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            if (state.products.isEmpty) {
              return const Center(
                child: Text('Chưa có sản phẩm nào. Thêm bằng nút +'),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: state.products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, index) {
                final p = state.products[index];
                return ProductCard(
                  product: p,
                  onEdit: () async {
                    final updated = await Navigator.of(context)
                        .push<ProductModel>(
                          MaterialPageRoute(
                            builder: (_) => ProductFormPage(product: p),
                          ),
                        );
                    if (updated != null) {
                      context.read<ProductBloc>().add(
                        ProductUpdateEvent(updated),
                      );
                      Get.snackbar(
                        'Thành công',
                        'Sản phẩm đã được cập nhật',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  onDelete: () {
                    // confirm
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Xác nhận'),
                        content: const Text(
                          'Bạn có chắc muốn xóa sản phẩm này?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              context.read<ProductBloc>().add(
                                ProductDeleteEvent(p.id),
                              );
                              Get.snackbar(
                                'Đã xóa',
                                'Sản phẩm đã được xóa',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            child: const Text('Xóa'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is ProductFailure) {
            return Center(child: Text('Lỗi: ${state.message}'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newProduct = await Navigator.of(context).push<ProductModel>(
            MaterialPageRoute(builder: (_) => ProductFormPage()),
          );
          if (newProduct != null) {
            context.read<ProductBloc>().add(ProductAddEvent(newProduct));
            Get.snackbar(
              'Thêm thành công',
              'Sản phẩm đã được thêm',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
