import 'package:flutter/material.dart';

import '../models/expense_data.dart';
import './expense_list/expense_list.dart';
import './new_expense.dart';
import './chart/chart.dart';

class Expense extends StatefulWidget {
  const Expense({super.key});

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  final List<ExpenseData> _registeredExpenses = [
    ExpenseData(
      title: 'Fast X tickets',
      amount: 280.00,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    ExpenseData(
      title: 'clothes',
      amount: 2080.00,
      date: DateTime.now(),
      category: Category.work,
    ),
    ExpenseData(
      title: 'Food',
      amount: 380.00,
      date: DateTime.now(),
      category: Category.food,
    ),
    ExpenseData(
      title: 'Pizza',
      amount: 180.00,
      date: DateTime.now(),
      category: Category.food,
    ),
    ExpenseData(
      title: 'breakfast',
      amount: 80.00,
      date: DateTime.now(),
      category: Category.food,
    ),
    ExpenseData(
      title: 'welcome party',
      amount: 200.00,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    ExpenseData(
      title: 'Books',
      amount: 180.00,
      date: DateTime.now(),
      category: Category.work,
    ),
    ExpenseData(
      title: 'Train tickets',
      amount: 1080.00,
      date: DateTime.now(),
      category: Category.travel,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      //useSafeArea ensures that we dont use the area that is reserved by the device 
      //to show battery or where camera is
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(ExpenseData expensedata) {
    setState(() {
      _registeredExpenses.add(expensedata);
    });
  }

  void _removeExpense(ExpenseData expenseData) {
    final expenseIndex = _registeredExpenses.indexOf(expenseData);
    setState(() {
      _registeredExpenses.remove(expenseData);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense Deleted'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expenseData);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //CODE TO FIND available size of the device
    final width = MediaQuery.of(context).size.width;
    // print(MediaQuery.of(context).size.height);
    // print(MediaQuery.of(context).size.aspectRatio);

    Widget mainContext = const Center(
      child: Text('No expense. Start adding some'),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContext = ExpenseList(
          expense_list: _registeredExpenses, onRemovedExpense: _removeExpense);
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: _openAddExpenseOverlay, icon: Icon(Icons.add))
        ],
        title: const Text('Expense Tracker'),
        //backgroundColor: Color.fromARGB(255, 27, 19, 70),
      ),
      body: width < 600
          ? Column(children: [
              Chart(expenses: _registeredExpenses),
              Expanded(
                child: mainContext,
              ),
            ])
          : Row(
              children: [
                Expanded(
                  child: Chart(
                    expenses: _registeredExpenses,
                  ),
                ),
                Expanded(
                  child: mainContext,
                ),
              ],
            ),
    );
  }
}
