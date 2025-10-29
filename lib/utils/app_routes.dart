import 'package:get/get.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/product_page.dart';
import '../presentation/pages/order_page.dart';
import '../presentation/pages/report_page.dart';
import '../presentation/pages/login_page.dart';
import '../presentation/pages/register_page.dart';
import '../presentation/pages/profile_page.dart'; // ✅ thêm dòng này

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const products = '/products';
  static const orders = '/orders';
  static const reports = '/reports';
  static const profile = '/profile'; // ✅ thêm dòng này

  static final pages = [
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: register, page: () => const RegisterPage()),
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: products, page: () => const ProductPage()),
    GetPage(name: orders, page: () => const OrderPage()),
    GetPage(name: reports, page: () => const ReportPage()),
    GetPage(name: profile, page: () => const ProfilePage()), // ✅ thêm dòng này
  ];
}
