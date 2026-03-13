import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bhishi_provider.dart';
import '../../core/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BhishiProvider>();
    
    // Member Payment Status data
    int paidCount = provider.paymentRecords.length;
    int pendingCount = 10; // Mock pending for visualization

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Reports')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Member Payment Status (Pie Chart)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.3,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(value: paidCount.toDouble() + 1, color: Colors.green, title: 'Paid', radius: 60),
                    PieChartSectionData(value: pendingCount.toDouble(), color: Colors.orange, title: 'Pending', radius: 60),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text('Monthly Collection (Bar Chart)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Container(
              height: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: provider.groups.asMap().entries.map((e) => 
                    BarChartGroupData(x: e.key, barRods: [
                      BarChartRodData(toY: e.value.monthlyAmount / 100, color: AppTheme.primaryColor, width: 20)
                    ])
                  ).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Note: Chart heights represent relative monthly amounts across groups.', 
              style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
