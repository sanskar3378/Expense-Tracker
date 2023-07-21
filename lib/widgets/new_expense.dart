import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/expense_data.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(ExpenseData expenseData) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      //show error message
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'make sure to enter valid amount, date and category are entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(
      ExpenseData(
          title: _titleController.text,
          amount: enteredAmount,
          date: _selectedDate!,
          category: selectedCategory),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //this code shows the space that will be taken by the external thing overlapping the app screen
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {
      // final width = constraints.maxWidth;
      print(constraints.maxWidth);
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),
                const SizedBox(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _amountController,
                        decoration: const InputDecoration(
                          prefixText: '₹ ',
                          label: Text('Amount'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _selectedDate == null
                                ? 'select a date'
                                : formatter.format(_selectedDate!),
                            //Exclaimation mark forces Dart to assume that the value won't be a null value
                          ),
                          IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    DropdownButton(
                        value: selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (values) {
                          if (values == null) {
                            return;
                          }
                          setState(() {
                            selectedCategory = values;
                          });
                        }),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text(
                          'Save',
                          style: TextStyle(fontSize: 18),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
