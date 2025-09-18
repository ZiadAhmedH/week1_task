import '../models/order_model.dart';

abstract class OrderService {
  Future<void> addOrder(Order order);
  Future<List<Order>> getAllOrders();
  Future<List<Order>> getPendingOrders();
  Future<void> updateOrder(Order order);
}
