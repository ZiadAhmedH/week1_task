import 'package:get_it/get_it.dart';
import '../../features/orders/data/order_repo.dart';
import '../../features/orders/logic/order_cubit.dart';
import '../../features/reports/data/report_service.dart';
import '../../features/reports/data/report_service_con.dart';
import '../../features/reports/logic/report_cubit.dart';

import '../services/order_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ========== Services ==========
  sl.registerLazySingleton<OrderService>(() => OrderRepository());
  sl.registerLazySingleton<ReportService>(() => SQLiteReportService());

  // ========== Cubits ==========
  sl.registerFactory(() => OrderCubit(sl<OrderService>()));
  sl.registerFactory(() => ReportCubit(sl<ReportService>()));
}
