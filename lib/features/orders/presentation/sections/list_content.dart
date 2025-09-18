import 'package:flutter/material.dart';

import '../../../../core/models/order_model.dart';
import '../widgets/order_card.dart';

class OrderListContent extends StatelessWidget {
  final List<Order> orders;

  const OrderListContent({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final currentOrders = orders.where((order) => !order.isCompleted).toList();
    final pastOrders = orders.where((order) => order.isCompleted).toList();

    return CustomScrollView(
      slivers: [
        if (currentOrders.isNotEmpty) ...[
          _buildSectionHeader('Current Order'),
          _buildOrderSection(currentOrders, isCurrentOrder: true),
        ],
        if (pastOrders.isNotEmpty) ...[
          _buildSectionHeader('Past Orders'),
          _buildOrderSection(pastOrders, isCurrentOrder: false),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3E2723),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSection(
    List<Order> orders, {
    required bool isCurrentOrder,
  }) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: OrderCard(
            order: orders[index],
            isCurrentOrder: isCurrentOrder,
          ),
        );
      }, childCount: orders.length),
    );
  }
}
