import 'package:ahwa_store_manger_app/features/orders/presentation/add_order_view.dart';
import 'package:ahwa_store_manger_app/features/reports/logic/report_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'features/orders/logic/order_cubit.dart';
import 'features/orders/presentation/order_list_view.dart';
import 'features/reports/presentaion/reports_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  late final OrderCubit _orderCubit;
  late final ReportCubit _reportCubit;

  @override
  void initState() {
    super.initState();
    _orderCubit = sl.get<OrderCubit>()..loadOrders();
    _reportCubit = sl.get<ReportCubit>();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      BlocProvider.value(
        value: sl.get<OrderCubit>()..loadOrders(),
        child: const OrderListView(),
      ),
      BlocProvider.value(
        value: sl.get<OrderCubit>(),
        child: const AddOrderView(),
      ),
      BlocProvider.value(
        value: sl.get<ReportCubit>()..loadReport(),
        child: const ReportsView(),
      ),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.orange,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: "Add Order",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Report"),
        ],
      ),
    );
  }
}
