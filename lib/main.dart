import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/service_locator.dart';
import 'features/orders/logic/order_cubit.dart';
import 'features/orders/presentation/order_list_view.dart';
import 'features/reports/logic/report_cubit.dart';
import 'features/reports/presentaion/reports_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies(); // 🟤 تسجيل الـ dependencies

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<OrderCubit>()..loadOrders()),
        BlocProvider(create: (_) => sl<ReportCubit>()),
      ],
      child: MaterialApp(
        title: 'Ahwa Store Manager',
        theme: ThemeData(primarySwatch: Colors.brown, useMaterial3: true),
        home: const OrderListView(),
        routes: {
          '/reports': (_) => BlocProvider(
            create: (_) => sl<ReportCubit>()..loadReport(),
            child: const ReportsView(),
          ),
        },
      ),
    );
  }
}
