import 'drink_model.dart';

class Order {
  final int? id;
  final String customerName;
  final Drink drink;
  final String? specialInstructions;
  bool isCompleted;



  Order({
    this.id,
    required this.customerName,
    required this.drink,
    this.specialInstructions,
    this.isCompleted = false,

  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'drink': drink.name,
      'specialInstructions': specialInstructions,
      'isCompleted': isCompleted ? 1 : 0,

    };
  }
}
