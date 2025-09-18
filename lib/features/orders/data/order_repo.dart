import '../../../core/models/drink_model.dart';
import '../../../core/models/order_model.dart';
import '../../../core/services/order_service.dart';
import 'order_db_helper.dart';

class OrderRepository implements OrderService {
  final dbHelper = OrderDBHelper();

  @override
  Future<void> addOrder(Order order) async {
    final db = await dbHelper.database;
    await db.insert('orders', order.toMap());
  }

  @override
  Future<List<Order>> getAllOrders() async {
    final db = await dbHelper.database;
    final maps = await db.query('orders');
    return maps.map((m) => _mapToOrder(m)).toList();
  }

  @override
  Future<List<Order>> getPendingOrders() async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'orders',
      where: 'isCompleted = ?',
      whereArgs: [0],
    );
    return maps.map((m) => _mapToOrder(m)).toList();
  }

  @override
  Future<void> updateOrder(Order order) async {
    final db = await dbHelper.database;
    await db.update(
      'orders',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  Order _mapToOrder(Map<String, dynamic> map) {
    Drink drink;
    switch (map['drink']) {
      case "Espresso":
        drink = Espresso();
        break;
      case "Turkish Coffee":
        drink = TurkishCoffee();
        break;
      case "Latte":
        drink = Latte();
        break;
      default:
        drink = DarkCoffee();
    }
    return Order(
      id: map['id'],
      customerName: map['customerName'],
      drink: drink,
      specialInstructions: map['specialInstructions'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
