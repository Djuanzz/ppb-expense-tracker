import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic balance = 100000000;

  List<Map<String, dynamic>> expenses = [
    {'category': 'Food', 'amount': 0},
    {'category': 'Transport', 'amount': 0},
    {'category': 'Entertainment', 'amount': 0},
    {'category': 'Investment', 'amount': 0},
  ];

  List<Map<String, dynamic>> records = [];

  String rupiahFormat(int amount) {
    String number = amount.toString();
    String result = '';
    int count = 0;

    for (int i = number.length - 1; i >= 0; i--) {
      result = number[i] + result;
      count++;
      if (count % 3 == 0 && i != 0) {
        result = '.$result';
      }
    }
    return result;
  }

  void addRecord(String category, int amount) {
    setState(() {
      records.add({'category': category, 'amount': amount});
      balance -= amount;
      for (var expense in expenses) {
        if (expense['category'] == category) {
          expense['amount'] += amount;
          return;
        }
      }
      expenses.add({'category': category, 'amount': amount});
    });
  }

  void editRecord(int index, String category, int newAmount) {
    setState(() {
      balance += records[index]['amount'];
      balance -= newAmount;
      for (var expense in expenses) {
        if (expense['category'] == records[index]['category']) {
          expense['amount'] -= records[index]['amount'];
        }
        if (expense['category'] == category) {
          expense['amount'] += newAmount;
        }
      }
      records[index] = {'category': category, 'amount': newAmount};
    });
  }

  void deleteRecord(int index) {
    balance += records[index]['amount'];
    for (var expense in expenses) {
      if (expense['category'] == records[index]['category']) {
        expense['amount'] -= records[index]['amount'];
        break;
      }
    }
    setState(() {
      records.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            buildCard(
              'Balance',
              'Rp ${rupiahFormat(balance)}',
              isBalance: true,
            ),
            buildCard(
              'Expenses',
              null,
              items:
                  expenses
                      .map(
                        (expense) => buildExpenseRow(
                          expense['category'],
                          'Rp ${rupiahFormat(expense['amount'])}',
                        ),
                      )
                      .toList(),
            ),
            buildCard(
              'Records',
              null,
              items: List.generate(
                records.length,
                (index) => buildRecordRow(
                  records[index]['category'],
                  'Rp ${rupiahFormat(records[index]['amount'])}',
                  index,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDialog();
        },
        tooltip: 'Add Record',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future openDialog({int? index}) {
    String selectedCategory =
        index != null ? records[index]['category'] : expenses.first['category'];
    TextEditingController amountController = TextEditingController(
      text: index != null ? records[index]['amount'].toString() : '',
    );

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? 'Tambah Data' : 'Edit Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items:
                    expenses.map<DropdownMenuItem<String>>((expense) {
                      return DropdownMenuItem<String>(
                        value: expense['category'],
                        child: Text(expense['category']),
                      );
                    }).toList(),
                onChanged: (value) {
                  selectedCategory = value!;
                },
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                int amount = int.tryParse(amountController.text) ?? 0;
                if (amount > 0) {
                  if (index == null) {
                    addRecord(selectedCategory, amount);
                  } else {
                    editRecord(index, selectedCategory, amount);
                  }
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget buildRecordRow(String category, String amount, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () => openDialog(index: index),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () => deleteRecord(index),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCard(
    String title,
    String? balance, {
    List<Widget>? items,
    bool isBalance = false,
  }) {
    return Card(
      color: Colors.amber[400],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            if (isBalance)
              Text(
                balance!,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            if (items != null) Column(children: items),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget buildExpenseRow(String category, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
