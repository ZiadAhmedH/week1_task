import 'package:ahwa_store_manger_app/features/reports/data/report_service.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/models/report_model.dart';
import '../../orders/data/order_db_helper.dart';

class SQLiteReportService implements ReportService {
  final OrderDBHelper dbHelper = OrderDBHelper();

  @override
  Future<Report> fetchReport() async {
    final db = await dbHelper.database;

    // 1. Total orders
    final totalOrdersRes = await db.rawQuery(
      'SELECT COUNT(*) as count FROM orders',
    );
    final totalOrders = Sqflite.firstIntValue(totalOrdersRes) ?? 0;

    // 2. Total customers (distinct names)
    final totalCustomersRes = await db.rawQuery(
      'SELECT COUNT(DISTINCT customerName) as count FROM orders',
    );
    final totalCustomers = Sqflite.firstIntValue(totalCustomersRes) ?? 0;

    // 3. Top drink
    final topDrinkRes = await db.rawQuery('''
      SELECT drink, COUNT(drink) as count
      FROM orders
      GROUP BY drink
      ORDER BY count DESC
      LIMIT 1
    ''');

    // 4. Total revenue (assuming each drink has a fixed price)

    String topDrink = "No Orders";
    int topDrinkCount = 0;
    if (topDrinkRes.isNotEmpty) {
      topDrink = topDrinkRes.first['drink'] as String;
      topDrinkCount = topDrinkRes.first['count'] as int;
    }

    return Report(
      topDrink: topDrink,
      topDrinkCount: topDrinkCount,
      totalOrders: totalOrders,
      totalCustomers: totalCustomers,
      totalRevenue: 200.2,
    );
  }
}
