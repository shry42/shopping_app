import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:techsevin/models/product.dart';

class CartDatabase {
  static const _databaseName = "cart.db";
  static const _databaseVersion = 1;
  //
  static const table = 'cart';
  //
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnDescription = 'description';
  static const columnPrice = 'price';
  static const columnDiscountPercentage = 'discountPercentage';
  static const columnRating = 'rating';
  static const columnStock = 'stock';
  static const columnBrand = 'brand';
  static const columnCategory = 'category';
  static const columnThumbnail = 'thumbnail';
  static const columnImages = 'images';
  static const columnQuantity = 'quantity';

  // Make this a singleton class
  CartDatabase._privateConstructor();
  static final CartDatabase instance = CartDatabase._privateConstructor();

  // Only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Lazily instantiate the database if unavailable
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database, creating if it doesn't exist
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
           CREATE TABLE $table (
             $columnId INTEGER PRIMARY KEY,
             $columnTitle TEXT NOT NULL,
             $columnDescription TEXT NOT NULL,
             $columnPrice REAL,
             $columnDiscountPercentage REAL,
             $columnRating REAL,
             $columnStock INTEGER,
             $columnBrand TEXT,
             $columnCategory TEXT,
             $columnThumbnail TEXT,
             $columnImages TEXT,
             $columnQuantity INTEGER
           )
           ''');
  }

  // Insert a product into the database
  Future<int> insert(Product product) async {
    Database db = await instance.database;
    return await db.insert(table, product.toSQLJson());
  }

  // Retrieve all cart from the database
  Future<RxList<Product>> getAllProducts() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table);
    return RxList.generate(maps.length, (i) {
      return Product.fromSQLJson(maps[i]);
    });
  }

  Future<Product?> getProductById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Product.fromSQLJson(maps.first);
    } else {
      return null; // Return null if no product with the specified id is found
    }
  }

  // Update a product in the database
  Future<int> update(Product product) async {
    Database db = await instance.database;
    return await db.update(table, product.toSQLJson(),
        where: '$columnId = ?', whereArgs: [product.id]);
  }

  // Delete a product from the database
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
