import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/models/order_model.dart';
import '../../logic/order_cubit.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final bool isCurrentOrder;

  const OrderCard({
    super.key,
    required this.order,
    required this.isCurrentOrder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: order.isCompleted ? 0.7 : 1.0,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: isCurrentOrder ? 6 : 2,
        shadowColor: Colors.brown.withOpacity(0.3),
        color: isCurrentOrder ? Colors.white : const Color(0xFFFAFAFA),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showOrderDetails(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildOrderIcon(),
                const SizedBox(width: 16),
                Expanded(child: _buildOrderInfo()),
                _buildOrderAction(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderIcon() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.local_cafe,
            color: Color(0xFF795548),
            size: 24,
          ),
        ),
        if (isCurrentOrder)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOrderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isCurrentOrder ? 'In Progress' : 'Completed',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isCurrentOrder ? Colors.orange : Colors.green,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Order #${order.id}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: order.isCompleted
                ? Colors.grey[600]
                : const Color(0xFF3E2723),
          ),
        ),
        if (order.specialInstructions != null &&
            order.specialInstructions!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            order.specialInstructions!,
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildOrderAction(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "${DateTime.now()}",
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: order.isCompleted
              ? const Icon(Icons.check_circle, color: Colors.green, size: 24)
              : Container(
                  key: ValueKey(order.id),
                  decoration: BoxDecoration(
                    color: const Color(0xFF795548),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    onPressed: () => _showCompleteDialog(context),
                  ),
                ),
        ),
      ],
    );
  }

  // ==================== MODAL AND DIALOG METHODS ====================
  void _showOrderDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Order ID', '#${order.id}'),
            _buildDetailRow('Drink', order.drink.name),
            _buildDetailRow('Customer', order.customerName),
            if (order.specialInstructions?.isNotEmpty == true)
              _buildDetailRow('Instructions', order.specialInstructions!),
            _buildDetailRow(
              'Status',
              order.isCompleted ? 'Completed' : 'In Progress',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showCompleteDialog(BuildContext context) {
    // grab cubit instance from the parent context before opening the dialog
    final orderCubit = context.read<OrderCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Complete Order'),
        content: Text('Mark order #${order.id} as completed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              orderCubit.markOrderCompleted(order);
              orderCubit.loadOrders();
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF795548),
              foregroundColor: Colors.white,
            ),
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }

  // ==================== UTILITY METHODS ====================
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${_formatTime(dateTime)}';
  }
}
