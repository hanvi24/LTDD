import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'presentation/theme/app_theme.dart';
import 'utils/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quản lý xuất nhập - bán hàng',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,

      // ✅ Thay Home thành Login
      initialRoute: AppRoutes.login,

      getPages: AppRoutes.pages,
    );
  }
}
