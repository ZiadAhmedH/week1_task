import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/order_cubit.dart';
import '../logic/order_state.dart';
import 'add_order_view.dart';
import '../../../core/models/order_model.dart';

class OrderListView extends StatelessWidget {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf3ede3), // خلفية كريميه
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF4E342E), // بني داكن
        title: const Text(
          "☕ Ahwa Manager",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/reports'),
          ),
        ],
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoaded && state.orders.isNotEmpty) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return _buildOrderCard(context, order);
              },
            );
          }
          return const Center(
            child: Text(
              "No orders yet ☕\nClick + to add a new order",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Color(0xFF6D4C41)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6D4C41),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddOrderView()),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: order.isCompleted ? 0.5 : 1.0,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: Colors.brown.withOpacity(0.3),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF795548),
            child: Text(
              order.drink.name.characters.first.toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            order.drink.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: order.isCompleted ? Colors.grey : const Color(0xFF3E2723),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("For: ${order.customerName}"),
              if (order.specialInstructions!.isNotEmpty)
                Text(
                  "Note: ${order.specialInstructions}",
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                  ),
                ),
            ],
          ),
          trailing: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: order.isCompleted
                ? const Icon(Icons.check_circle, color: Colors.green, size: 28)
                : IconButton(
                    key: ValueKey(order.id),
                    icon: const Icon(Icons.done, color: Colors.brown),
                    onPressed: () {
                      context.read<OrderCubit>().markOrderCompleted(order);
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
