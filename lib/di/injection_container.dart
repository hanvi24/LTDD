import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';

// Nếu bạn đã chạy flutterfire configure
// import '../config/firebase_options.dart';

import '../data/local/app_database.dart';
import '../data/local/product_dao.dart';
import '../data/local/order_dao.dart';

import '../data/repositories/product_repository.dart';
import '../data/repositories/order_repository.dart';

import '../data/repositories/product_repository_impl.dart';
import '../data/repositories/order_repository_impl.dart';

import '../data/remote/firestore_service.dart';

Future<void> init() async {
  // 1. Firebase init (bỏ qua nếu chưa cấu hình)
  try {
    await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // print('Firebase init skipped: $e');
  }

  // 2. DB khởi tạo
  await AppDatabase.instance.database;
  Get.put<AppDatabase>(AppDatabase.instance, permanent: true);

  // 3. DAOs
  Get.put<ProductDao>(ProductDao(), permanent: true);
  Get.put<OrderDao>(OrderDao(), permanent: true);

  // 4. Repositories
  Get.put<ProductRepository>(
    ProductRepositoryImpl(Get.find<ProductDao>()),
    permanent: true,
  );

  Get.put<OrderRepository>(
    OrderRepositoryImpl(Get.find<OrderDao>(), Get.find<ProductDao>()),
    permanent: true,
  );

  // 5. Firestore service
  Get.put<FirestoreService>(FirestoreService(), permanent: true);

  // 6. Helpers
  Get.put<Uuid>(const Uuid(), permanent: true);
}
