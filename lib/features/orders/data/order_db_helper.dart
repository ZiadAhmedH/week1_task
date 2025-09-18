import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class OrderDBHelper {
  static final OrderDBHelper _instance = OrderDBHelper._internal();
  factory OrderDBHelper() => _instance;
  OrderDBHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'orders.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customerName TEXT,
            drink TEXT,
            specialInstructions TEXT,
            isCompleted INTEGER
          )
        ''');
      },
    );
  }
}
