import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/product_repository.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  double totalRevenue = 0;
  int totalProducts = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final orderRepo = Get.find<OrderRepository>();
    final productRepo = Get.find<ProductRepository>();
    final revenue = await orderRepo.getTotalRevenue();
    final products = await productRepo.getAllProducts();
    setState(() {
      totalRevenue = revenue;
      totalProducts = products.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Báo cáo')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('Tổng doanh thu'),
                trailing: Text(
                  '${totalRevenue.toStringAsFixed(0)} ₫',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Tổng số sản phẩm'),
                trailing: Text(
                  '$totalProducts',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Làm mới'),
              onPressed: _loadStats,
            ),
          ],
        ),
      ),
    );
  }
}
