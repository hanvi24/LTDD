import 'package:get/get.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/product_page.dart';
import '../presentation/pages/order_page.dart';
import '../presentation/pages/report_page.dart';

class AppRoutes {
  static const home = '/';
  static const products = '/products';
  static const orders = '/orders';
  static const reports = '/reports';

  static final pages = [
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: products, page: () => const ProductPage()),
    GetPage(name: orders, page: () => const OrderPage()),
    GetPage(name: reports, page: () => const ReportPage()),
  ];
}
