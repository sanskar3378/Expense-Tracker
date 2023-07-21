import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final uuid = Uuid();

final formatter = DateFormat.yMd();

enum Category { food, travel, work, leisure }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.leisure: Icons.movie,
  Category.travel: Icons.flight_takeoff,
  Category.work: Icons.work,
};

class ExpenseData {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }

  ExpenseData({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expensedata,
  });

  //Utility constructor functionthat takes care of filtering out the expenses that belong to a specific
  //category
  ExpenseBucket.forCateogry(List<ExpenseData> allExpenses, this.category)
      : expensedata = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<ExpenseData> expensedata;

  double get totalExpenses {
    double sum = 0;

    //alternative for "for" loop
    //for(x in y) can be used to access and loop through all the expensedata
    for (final expense in expensedata) {
      sum += expense.amount;
    }

    return sum;
  }
}
