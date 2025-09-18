import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/report_cubit.dart';
import '../logic/report_state.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6D4C41), // بني غامق
        title: const Text("📊 تقارير الأهوة"),
        centerTitle: true,
      ),
      body: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, state) {
          if (state is ReportLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReportError) {
            return Center(child: Text("❌ حصل خطأ: ${state.message}"));
          } else if (state is ReportLoaded) {
            final report = state.report;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: [
                        _buildReportCard(
                          color: Colors.brown.shade300,
                          icon: Icons.local_cafe,
                          title: "إجمالي الطلبات",
                          value: "${report.totalOrders}",
                        ),
                        _buildReportCard(
                          color: Colors.orange.shade300,
                          icon: Icons.people,
                          title: "إجمالي العملاء",
                          value: "${report.totalCustomers}",
                        ),
                        _buildReportCard(
                          color: Colors.teal.shade300,
                          icon: Icons.star,
                          title: "أكتر مشروب مطلوب",
                          value:
                              "${report.topDrink}\n(${report.topDrinkCount})",
                        ),
                        _buildReportCard(
                          color: Colors.blueGrey.shade300,
                          icon: Icons.attach_money,
                          title: "إجمالي الإيرادات",
                          value: "${report.totalRevenue ?? 0} ج.م",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D4C41),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      context.read<ReportCubit>().loadReport();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("تحديث التقارير"),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Text("☕ اضغط على زر التحديث لعرض التقارير"),
          );
        },
      ),
    );
  }

  Widget _buildReportCard({
    required Color color,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
