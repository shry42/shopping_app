import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProductDatabase {
  static Database? _database;
  static const String productsTable = 'products';
  static const String cartTable = 'cart';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    // Open/create the database at a specified path
    String path = join(await getDatabasesPath(), 'your_database.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      // Create necessary tables here
      await db.execute('''
        CREATE TABLE $productsTable (
          id INTEGER PRIMARY KEY,
          title TEXT,
          price REAL,
          discountedPrice REAL,
          brand TEXT,
          rating REAL,
          // Add other columns as needed
        )
      ''');
      await db.execute('''
        CREATE TABLE $cartTable (
          id INTEGER PRIMARY KEY,
          productId INTEGER,
          quantity INTEGER,
          // Add other columns as needed
        )
      ''');
    });
  }

  // Add functions for inserting/updating/querying data from the database
  // Example: insertProduct, getAllProducts, addToCart, getCartItems, etc.
}
