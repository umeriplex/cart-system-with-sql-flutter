import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'cart_modal.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDB();
  }

  initDB() async {
    io.Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, 'cart.db');
    var db = await openDatabase(path, version: 2, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart (id INTEGER PRIMARY KEY , productId VARCHAR UNIQUE,productName TEXT,initPrice INTEGER, productPrice INTEGER , quantity INTEGER, unitTag TEXT , image TEXT )');
  }

  Future<CartModel> insert(CartModel cartModel) async {
    var dbClient = await db;
    await dbClient!.insert('cart', cartModel.toMap());
    return cartModel;
  }

  Future<List<CartModel>> getCartData() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryRes = await dbClient!.query('cart');
    return queryRes.map((e) => CartModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async{
    var dbClient = await db;
    return await dbClient!.delete('cart',where: 'id = ?',whereArgs: [id]);
  }

  Future<int> updateQ(CartModel cartModel) async{
    var dbClient = await db;
    return await dbClient!.update('cart',cartModel.toMap(),where: 'id = ?',whereArgs: [cartModel.id]);
  }
}
