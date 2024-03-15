import 'package:flutter/material.dart';

class ManageExpensesPage extends StatefulWidget {
  @override
  _ManageExpensesPageState createState() => _ManageExpensesPageState();
}

class _ManageExpensesPageState extends State<ManageExpensesPage> {
  double monthlyIncome = 0.0;
  double expenseLimit = 0.0;
  String frequency = 'Monthly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Expenses'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.0),
            Text(
              'Monthly Income',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter your monthly income',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  monthlyIncome = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Expense Limit',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter your expense limit',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  expenseLimit = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Frequency',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            DropdownButton<String>(
              value: frequency,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black),
              onChanged: (String? newValue) {
                setState(() {
                  frequency = newValue!;
                });
              },
              items: <String>['Daily', 'Weekly', 'Monthly']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Calculate savings based on income, limit, and frequency
                double savings = _calculateSavings();
                // Show dialog with calculated savings
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Estimated Savings'),
                      content: Text(
                        'You could save approximately \$${savings.toStringAsFixed(2)} in a year.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Calculate Savings'),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateSavings() {
    double savings = 0.0;
    switch (frequency) {
      case 'Daily':
        savings = (monthlyIncome - expenseLimit) * 365 / 12;
        break;
      case 'Weekly':
        savings = (monthlyIncome - expenseLimit) * 52 / 12;
        break;
      case 'Monthly':
        savings = monthlyIncome - expenseLimit;
        break;
    }
    return savings;
  }
}

void main() {
  runApp(MaterialApp(
    home: ManageExpensesPage(),
  ));
}
