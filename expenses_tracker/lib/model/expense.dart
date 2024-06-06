import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum Category { work, food, travel, leisure }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.work: Icons.work,
  Category.leisure: Icons.movie
};

class Expense {
  Expense(
      {required this.amount,
      required this.date,
      required this.title,
      required this.category})
      : id = uuid
            .v4(); // viết như vậy thì chỉ cần nhớ tên và thêm required là được

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  // Expenses(this.title, this.amount, this.sate);   // viết như vậy thì phải truyền  giá trị theo đúng vị trí

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  final Category category;
  final List<Expense> expenses;

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      //Đặt final để được tạo lại sau mỗi lần lặp
      sum += expense.amount;
    }
    return sum;
  }
}
