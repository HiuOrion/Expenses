import 'package:expenses_tracker/model/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          // thêm các đệm cho card
          vertical: 5, // Đệm dọc
          horizontal: 10, // Đệm ngang
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                // \$ in ra kí tự đặc biệt $
                // thêm ${} vào trước để trỏ đến giá trị của biến
                // 12.3433 => 12.34
                Text('\$${expense.amount.toStringAsFixed(2)}'),
                const Spacer(),
                //chiếm toàn bộ không gian còn lại ở giữa của 1 row, column
                Row(
                  children: [
                    Icon(categoryIcons[expense.category]),
                    // sử dụng dấu ngoặc vuông để truy cập vào một mục cụ thể
                    // vì sử dụng category làm key trong map categoryIcons nên phải truy cập vào key

                    const SizedBox(
                      width: 5,
                    ),
                    Text(expense.formattedDate)
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
