import 'manage_expense.dart';
import 'spend_history.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  final List<double> incomeData = [2000, 2500, 1500, 3000, 2000, 3500];
  final List<double> expenseData = [1500, 2000, 1800, 2500, 2200, 2800];

  final List<BudgetItem> budgetItems = [
    BudgetItem(category: 'Food', amount: 500),
    BudgetItem(category: 'Transportation', amount: 300),
    BudgetItem(category: 'Entertainment', amount: 200),
    BudgetItem(category: 'Shopping', amount: 400),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FISC',
          style: TextStyle(color: Colors.black),
        ), // Updated heading with custom color
        backgroundColor: Colors.white, // Set app bar background color
        elevation: 0, // Remove app bar elevation
        centerTitle: true, // Center app bar title
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DashboardButton(
                  label: 'This Month Spends',
                  value: '₹5000', // Updated to Indian rupee currency
                  icon: Icons.attach_money,
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SpendHistoryPage()));

                    // Implement action for This Month Spends button
                  },
                ),
                DashboardButton(
                  label: 'Manage Expenses',
                  value: 'Limit',
                  icon: Icons.score,
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManageExpensesPage()));
                    // Implement action for Manage Expenses button
                  },
                ),
              ],
            ),
            SizedBox(height: 40.0),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Income',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Expanded(
                      child: BarChart(
                        _generateBarChartData(
                            context, Colors.green, incomeData),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    const Text(
                      'Expenses',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Expanded(
                      child: BarChart(
                        _generateBarChartData(
                            context, Colors.orange, expenseData),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartData _generateBarChartData(
      BuildContext context, Color barColor, List<double> data) {
    return BarChartData(
      barGroups: List.generate(data.length, (index) {
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              fromY: data[index], // Use data[index] directly
              color: barColor,
              width: 16, toY: 65,
            ),
          ],
        );
      }),
      borderData: FlBorderData(show: false),
      barTouchData: BarTouchData(enabled: false),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Function()? onPressed;

  const DashboardButton({
    required this.label,
    required this.value,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          height: 120.0,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(height: 10.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BudgetItem {
  final String category;
  final double amount;

  BudgetItem({required this.category, required this.amount});
}

void main() {
  runApp(MaterialApp(
    home: DashboardScreen(),
  ));
}
