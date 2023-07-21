import '../../widgets/expense_list/expense_item.dart';
import 'package:flutter/material.dart';

import '../../models/expense_data.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({
    super.key,
    required this.expense_list,
    required this.onRemovedExpense,
  });

  final List<ExpenseData> expense_list;
  final void Function(ExpenseData expensedata) onRemovedExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) => Dismissible(
        direction: DismissDirection.endToStart,
        background: Container(
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.delete_outline_rounded, size: 28),
            ],
          ),
        ),
        key: ValueKey(expense_list[index]),
        onDismissed: (direction) => onRemovedExpense(expense_list[index]),
        child: ExpenseItem(
          expense_list[index],
        ),
      ),
      itemCount: expense_list.length,
    );
  }
}
