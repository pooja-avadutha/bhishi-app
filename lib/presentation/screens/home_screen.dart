import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bhishi_provider.dart';
import '../../data/models/app_models.dart';
import '../../core/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BhishiProvider>();
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    int totalMembers = 0;
    for (GroupModel g in provider.groups) {
      totalMembers += g.members.length;
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// TITLE
              Text(
                "Agent Dashboard",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              /// SUMMARY CARDS
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.25,
                ),
                children: [

                  _buildSummaryCard(
                    "Total Groups",
                    provider.groups.length.toString(),
                    Icons.groups,
                    Colors.blue,
                  ),

                  _buildSummaryCard(
                    "Total Members",
                    totalMembers.toString(),
                    Icons.people,
                    Colors.green,
                  ),

                  _buildSummaryCard(
                    "Monthly Collection",
                    currencyFormat.format(
                        provider.getTotalMonthlyCollection()),
                    Icons.account_balance_wallet,
                    Colors.orange,
                  ),

                  _buildSummaryCard(
                    "Agent Profit",
                    currencyFormat.format(provider.getAgentTotalProfit()),
                    Icons.trending_up,
                    Colors.teal,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// BAR CHART
              Text(
                "Overall Analytics",
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 16),

              Container(
                height: 240,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.grey.shade200,
                    )
                  ],
                ),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return const Text("Groups");
                              case 1:
                                return const Text("Members");
                              case 2:
                                return const Text("Profit");
                            }
                            return const Text("");
                          },
                        ),
                      ),
                    ),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [
                        BarChartRodData(
                          toY: provider.groups.length.toDouble(),
                          color: Colors.blue,
                          width: 20,
                        )
                      ]),
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(
                          toY: totalMembers.toDouble(),
                          color: Colors.green,
                          width: 20,
                        )
                      ]),
                      BarChartGroupData(x: 2, barRods: [
                        BarChartRodData(
                          toY: provider.getAgentTotalProfit(),
                          color: AppTheme.primaryColor,
                          width: 20,
                        )
                      ]),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// RECENT GROUPS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Groups",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("View All Data"),
                  )
                ],
              ),

              const SizedBox(height: 10),

              provider.groups.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: Text("No groups created yet")),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          provider.groups.length > 3 ? 3 : provider.groups.length,
                      itemBuilder: (context, index) {
                        final group = provider.groups[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            title: Text(group.groupName),
                            subtitle:
                                Text("Members: ${group.members.length}"),
                            trailing: const Icon(Icons.chevron_right),
                          ),
                        );
                      },
                    ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// SUMMARY CARD
  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ), 
    );
  }
}