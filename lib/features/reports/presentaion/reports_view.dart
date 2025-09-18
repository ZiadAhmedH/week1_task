import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../data/report_service.dart';
import '../../../core/models/report_model.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  final ReportService _reportService = GetIt.I<ReportService>();

  late Future<Report> _reportFuture;

  @override
  void initState() {
    super.initState();
    _reportFuture = _reportService.fetchReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Reports")),
      body: FutureBuilder<Report>(
        future: _reportFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No data available"));
          }

          final report = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ReportCard(
                  title: "Total Orders",
                  value: report.totalOrders.toString(),
                  icon: Icons.shopping_cart,
                ),
                const SizedBox(height: 16),
                _ReportCard(
                  title: "Total Customers",
                  value: report.totalCustomers.toString(),
                  icon: Icons.people,
                ),
                const SizedBox(height: 16),
                _ReportCard(
                  title: "Top Drink",
                  value: "${report.topDrink} (${report.topDrinkCount})",
                  icon: Icons.local_drink,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _ReportCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, size: 32, color: Colors.teal),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
