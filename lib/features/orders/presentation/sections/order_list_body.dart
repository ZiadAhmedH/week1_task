import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/order_cubit.dart';
import '../../logic/order_state.dart';
import 'list_content.dart';

class OrderListBody extends StatelessWidget {
  const OrderListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF795548)),
          );
        }

        if (state is OrderError) {
          return _buildErrorState(context, state.message);
        }

        if (state is OrderLoaded) {
          if (state.orders.isEmpty) {
            return _buildEmptyState();
          }
          return OrderListContent(orders: state.orders);
        }

        return _buildEmptyState();
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<OrderCubit>().loadOrders(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_cafe,
            size: 80,
            color: Colors.brown.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            "No orders yet ☕",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6D4C41),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Click + to add a new order",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Color(0xFF8D6E63)),
          ),
        ],
      ),
    );
  }
}
