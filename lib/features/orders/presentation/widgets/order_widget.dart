import 'package:flutter/material.dart';

import '../../../../core/models/order_model.dart';

class OrderTile extends StatelessWidget {
  final Order order;
  final VoidCallback onComplete;

  const OrderTile({super.key, required this.order, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${order.customerName} - ${order.drink.name}"),
      subtitle: Text(order.specialInstructions ?? "No instructions"),
      trailing: order.isCompleted
          ? const Icon(Icons.check, color: Colors.green)
          : IconButton(icon: const Icon(Icons.done), onPressed: onComplete),
    );
  }
}
