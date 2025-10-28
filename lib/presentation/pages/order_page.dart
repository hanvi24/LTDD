import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/order_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/product_repository.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late final OrderRepository orderRepo;
  late final ProductRepository productRepo;
  List<OrderModel> orders = [];
  List<ProductModel> products = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    orderRepo = Get.find<OrderRepository>();
    productRepo = Get.find<ProductRepository>();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => loading = true);
    products = await productRepo.getAllProducts();
    orders = await orderRepo.getAllOrders();
    setState(() => loading = false);
  }

  void _showCreateOrderDialog() {
    final uuid = Get.find<Uuid>();
    final id = uuid.v4();
    ProductModel? selectedProduct;
    int quantity = 1;

    showDialog(
      context: context,
      builder: (context) {
        double total = 0;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            total = selectedProduct == null
                ? 0
                : (selectedProduct!.price * quantity);
            return AlertDialog(
              title: const Text('Tạo đơn hàng mới'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Mã đơn: $id',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),

                    // Dropdown chọn sản phẩm
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Chọn mã sản phẩm',
                        border: OutlineInputBorder(),
                      ),
                      items: products
                          .map(
                            (p) => DropdownMenuItem(
                              value: p.id,
                              child: Text('${p.sku ?? p.id}'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setStateDialog(() {
                          selectedProduct = products.firstWhere(
                            (p) => p.id == value,
                            orElse: () => products.first,
                          );
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    // Hiển thị tên sản phẩm
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Tên sản phẩm',
                        border: const OutlineInputBorder(),
                        hintText: selectedProduct?.name ?? 'Chưa chọn sản phẩm',
                      ),
                      controller: TextEditingController(
                        text: selectedProduct?.name ?? '',
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Số lượng
                    Row(
                      children: [
                        const Text('Số lượng:'),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: quantity > 1
                              ? () => setStateDialog(() => quantity--)
                              : null,
                        ),
                        Text('$quantity'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setStateDialog(() => quantity++),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    // Tổng tiền
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Thành tiền: ${total.toStringAsFixed(0)} ₫',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: selectedProduct == null
                      ? null
                      : () async {
                          final order = OrderModel(
                            id: id,
                            date: DateTime.now(),
                            items: [
                              OrderItem(
                                product: selectedProduct!,
                                quantity: quantity,
                              ),
                            ],
                            total: total,
                          );
                          await orderRepo.createOrder(order, [
                            selectedProduct!,
                          ]);
                          Get.back();
                          await _loadData();
                          Get.snackbar(
                            'Thành công',
                            'Đã tạo đơn hàng mới',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                  child: const Text('Tạo đơn'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đơn hàng')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? const Center(child: Text('Chưa có đơn hàng nào'))
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: orders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final o = orders[i];
                  return ListTile(
                    title: Text('Đơn ${o.id.substring(0, 6)}'),
                    subtitle: Text(
                      'Ngày: ${o.date.toLocal()}\nSản phẩm: ${o.items.length}',
                    ),
                    trailing: Text('${o.total.toStringAsFixed(0)} ₫'),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateOrderDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
