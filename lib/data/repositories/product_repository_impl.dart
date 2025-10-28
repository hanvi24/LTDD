// lib/data/repositories/product_repository_impl.dart
import '../local/product_dao.dart';
import '../models/product_model.dart';
import 'product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDao productDao;
  ProductRepositoryImpl(this.productDao);

  @override
  Future<List<ProductModel>> getAllProducts() => productDao.getAllProducts();

  @override
  Future<void> addProduct(ProductModel product) =>
      productDao.insertProduct(product);

  @override
  Future<void> updateProduct(ProductModel product) =>
      productDao.updateProduct(product);

  @override
  Future<void> deleteProduct(String id) => productDao.deleteProduct(id);
}
