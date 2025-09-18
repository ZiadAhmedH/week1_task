import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/order_model.dart';
import '../../../core/services/order_service.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderService orderService;

  OrderCubit(this.orderService) : super(OrderInitial());

  Future<void> loadOrders() async {
    emit(OrderLoading());
    try {
      final orders = await orderService.getAllOrders();
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError("Failed to load orders: $e"));
    }
  }

  Future<void> addOrder(Order order) async {
    emit(OrderLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));

      await orderService.addOrder(order);
      final orders = await orderService.getAllOrders();
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError("Failed to add order: $e"));
    }
  }

  Future<void> markOrderCompleted(Order order) async {
    emit(OrderLoading());
    try {
      order.isCompleted = true;
      await orderService.updateOrder(order);
      final orders = await orderService.getAllOrders();
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError("Failed to update order: $e"));
    }
  }
}
