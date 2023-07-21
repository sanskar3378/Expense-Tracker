import 'package:flutter/material.dart';

import '../../models/expense_data.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final ExpenseData expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      //color: Color.fromARGB(255, 246, 232, 255),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            //to show amount and other data beside amount
            Row(
              children: [
                Text('₹${expense.amount.toStringAsFixed(2)}'),
                const Spacer(),
                //other two items that should be the opposite side of the amount
                Row(
                  children: [
                    Icon(categoryIcons[expense.category]),
                    const SizedBox(width: 8),
                    Text(expense.formattedDate),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
