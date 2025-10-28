import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product_model.dart';

class ProductDao {
  static const _databaseName = "app_database.db";
  static const _tableProducts = "products";

  Future<Database> get database async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, _databaseName),
      version: 2, // ✅ nâng version lên (1 → 2)
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableProducts(
            id TEXT PRIMARY KEY,
            name TEXT,
            sku TEXT,
            price REAL,
            stock INTEGER,
            updated_at INTEGER   -- ✅ thêm dòng này
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE $_tableProducts ADD COLUMN updated_at INTEGER',
          );
        }
      },
    );
  }

  Future<List<ProductModel>> getAllProducts() async {
    final db = await database;
    final maps = await db.query(_tableProducts, orderBy: 'name ASC');
    return maps.map((e) => ProductModel.fromMap(e)).toList();
  }

  Future<void> insertProduct(ProductModel product) async {
    final db = await database;
    await db.insert(
      _tableProducts,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteProduct(String id) async {
    final db = await database;
    await db.delete(_tableProducts, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateProduct(ProductModel product) async {
    final db = await database;
    await db.update(
      _tableProducts,
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }
}
