import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpendHistoryPage extends StatefulWidget {
  @override
  _SpendHistoryPageState createState() => _SpendHistoryPageState();
}

class _SpendHistoryPageState extends State<SpendHistoryPage> {
  List<Transaction> _transactions = [];
  List<Transaction> _filteredTransactions = [];
  bool _sortByDateAscending = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialTransactions(); // Fetch initial transactions when the page loads
  }

  Future<void> _fetchInitialTransactions() async {
    // Perform API call to fetch initial transactions
    try {
      final response = await http
          .get(Uri.parse('https://bank-sms-api.onrender.com/extract_amount'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _transactions =
              data.map((item) => Transaction.fromJson(item)).toList();
          _filteredTransactions.addAll(_transactions);
        });
      } else {
        throw Exception('Failed to load initial transactions');
      }
    } catch (e) {
      print('Error fetching initial transactions: $e');
      // Handle error
    }
  }

  Future<void> _fetchTransactionData(String sms) async {
    // Perform API call to fetch transaction data from SMS
    try {
      final response = await http.post(
        Uri.parse('https://bank-sms-api.onrender.com/extract_amount'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'sms': sms}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        final double amount = double.parse(data['amount']);
        final TransactionType type = data['transaction_type'] == 'credit'
            ? TransactionType.credit
            : TransactionType.debit;

        setState(() {
          _transactions.add(Transaction(
            amount: amount,
            type: type,
            date: DateTime.now(),
            category:
                TransactionCategory(icon: Icons.attach_money, name: "SMS"),
          ));
        });
      } else {
        throw Exception('Failed to fetch transaction data');
      }
    } catch (e) {
      print('Error fetching transaction data: $e');
      // Handle error
    }
  }

  void _filterTransactions(TransactionType type) {
    setState(() {
      _filteredTransactions.clear();
      _filteredTransactions.addAll(
          _transactions.where((transaction) => transaction.type == type));
    });
  }

  void _sortTransactionsByDate() {
    setState(() {
      if (_sortByDateAscending) {
        _filteredTransactions.sort((a, b) => a.date.compareTo(b.date));
      } else {
        _filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
      }
      _sortByDateAscending = !_sortByDateAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spend History'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: _sortTransactionsByDate,
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _filterTransactions(TransactionType.credit),
                child: Text('Credited'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightGreen,
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _filterTransactions(TransactionType.debit),
                child: Text('Debited'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaction = _filteredTransactions[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Card(
                    elevation: 4,
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        transaction.type == TransactionType.credit
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: transaction.type == TransactionType.credit
                            ? Colors.lightGreen
                            : Colors.red,
                      ),
                      title: Text(
                        '${transaction.type == TransactionType.credit ? 'Credited' : 'Debited'}: \$${transaction.amount}',
                        style: TextStyle(
                          color: transaction.type == TransactionType.credit
                              ? Colors.lightGreen
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${transaction.date}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      trailing: Icon(
                        transaction.category.icon,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum TransactionType { credit, debit }

class Transaction {
  final double amount;
  final TransactionType type;
  final DateTime date;
  final TransactionCategory category;

  Transaction({
    required this.amount,
    required this.type,
    required this.date,
    required this.category,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['amount'],
      type: json['type'] == 'credit'
          ? TransactionType.credit
          : TransactionType.debit,
      date: DateTime.parse(json['date']),
      category: TransactionCategory(
        icon:
            Icons.shopping_cart, // Change to appropriate icon based on category
        name: json['category'],
      ),
    );
  }
}

class TransactionCategory {
  final IconData icon;
  final String name;

  TransactionCategory({required this.icon, required this.name});
}

void main() {
  runApp(MaterialApp(
    home: SpendHistoryPage(),
  ));
}
