import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            buildCard('Balance', 'Rp 100.000.000', isBalance: true),
            buildCard(
              'Expense',
              null,
              items: [
                buildExpenseRow('Food', 'Rp 500.000'),
                buildExpenseRow('Transport', 'Rp 300.000'),
                buildExpenseRow('Entertainment', 'Rp 200.000'),
                buildExpenseRow('Bills', 'Rp 1.000.000'),
              ],
            ),
            buildCard(
              'Records',
              null,
              items: [
                buildExpenseRow('Salary', 'Rp 5.000.000'),
                buildExpenseRow('Bonus', 'Rp 1.000.000'),
                buildExpenseRow('Investment', 'Rp 2.000.000'),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDialog();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
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
            if (isBalance) // Untuk Card Balance
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

  Future openDialog() => showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Ini Dialog'),
          content: const Text('Sipsipoke Amanaja'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
  );
}
