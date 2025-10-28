import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_routes.dart';
import '../widgets/stat_card.dart';
import '../../services/sync_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _syncing = false;

  Future<void> _syncData() async {
    setState(() => _syncing = true);
    await SyncService().syncData();
    setState(() => _syncing = false);
    Get.snackbar(
      'Đồng bộ',
      'Đã hoàn tất đồng bộ dữ liệu!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý xuất nhập - bán hàng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _syncing ? null : _syncData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: const [
                Expanded(
                  child: StatCard(title: 'Sản phẩm', value: 'Quản lý kho'),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(title: 'Đơn hàng', value: 'Giao dịch'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  _buildMenuItem(
                    icon: Icons.inventory_2_outlined,
                    label: 'Sản phẩm',
                    color: Colors.blue,
                    onTap: () => Get.toNamed(AppRoutes.products),
                  ),
                  _buildMenuItem(
                    icon: Icons.receipt_long,
                    label: 'Đơn hàng',
                    color: Colors.orange,
                    onTap: () => Get.toNamed(AppRoutes.orders),
                  ),
                  _buildMenuItem(
                    icon: Icons.bar_chart,
                    label: 'Báo cáo',
                    color: Colors.green,
                    onTap: () => Get.toNamed(AppRoutes.reports),
                  ),
                  _buildMenuItem(
                    icon: Icons.cloud_sync,
                    label: _syncing ? 'Đang đồng bộ...' : 'Đồng bộ',
                    color: Colors.purple,
                    onTap: _syncing ? null : _syncData,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 38),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
