import 'package:ahwa_store_manger_app/features/orders/presentation/sections/order_list_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/order_cubit.dart';
import '../logic/order_state.dart';
import '../../../core/models/order_model.dart';

class OrderListView extends StatelessWidget {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf3ede3),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF4E342E),
        centerTitle: true,
        title: const Text(
          "☕ Ahwa Store",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: const OrderListBody(),
    );
  }
}
