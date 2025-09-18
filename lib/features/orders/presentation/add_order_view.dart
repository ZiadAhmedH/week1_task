import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/drink_model.dart';
import '../../../core/models/order_model.dart';
import '../logic/order_cubit.dart';
import '../logic/order_state.dart';

class AddOrderView extends StatefulWidget {
  const AddOrderView({super.key});

  @override
  State<AddOrderView> createState() => _AddOrderViewState();
}

class _AddOrderViewState extends State<AddOrderView> {
  final _nameController = TextEditingController();
  final _instructionsController = TextEditingController();

  final List<Drink> _drinks = [
    DarkCoffee(),
    TurkishCoffee(),
    Espresso(),
    Latte(),
  ];

  late Drink _selectedDrink;

  @override
  void initState() {
    super.initState();
    _selectedDrink = _drinks.first;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderLoaded) {
        } else if (state is OrderError) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        }
      },

      builder: (context, state) {
        final isLoading = state is OrderLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFf3ede3),
          appBar: AppBar(
            backgroundColor: const Color(0xFF4E342E),
            title: const Text(
              "➕ Add Order",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: "Customer Name",
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                _buildDropdown(),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _instructionsController,
                  label: "Special Instructions",
                  icon: Icons.note,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6D4C41),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                          final order = Order(
                            customerName: _nameController.text,
                            drink: _selectedDrink,
                            specialInstructions: _instructionsController.text,
                          );
                          context.read<OrderCubit>().addOrder(order);
                          // Clear inputs after adding
                          _nameController.clear();
                          _instructionsController.clear();
                          setState(() {
                            _selectedDrink = _drinks.first;
                          });
                        },
                  icon: const Icon(Icons.coffee, color: Colors.white),
                  label: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          "Save Order",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF6D4C41)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.brown.shade200),
      ),
      child: DropdownButton<Drink>(
        isExpanded: true,
        value: _selectedDrink,
        underline: const SizedBox(),
        onChanged: (value) => setState(() => _selectedDrink = value!),
        items: _drinks
            .map(
              (drink) =>
                  DropdownMenuItem(value: drink, child: Text(drink.name)),
            )
            .toList(),
      ),
    );
  }
}
