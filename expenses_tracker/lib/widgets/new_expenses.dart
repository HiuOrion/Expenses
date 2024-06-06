import 'package:flutter/material.dart';
import 'package:expenses_tracker/model/expense.dart';

class NewExpenses extends StatefulWidget {
  const NewExpenses({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpenses> createState() => _NewExpensesState();
}

class _NewExpensesState extends State<NewExpenses> {
  // cách in ra text trong textfield
  // String _enteredTitle = '';
  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount =
        double.tryParse(_amountController.text); // tryParse ('hello') = null
    final amountIsValid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsValid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              "Please make sure category, title, amount were entered"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx); //đóng lại ctx(ngữ cảnh) của builder
                },
                child: const Text('OK')),
          ],
        ),
      );
      return;
    }
    //Thêm widget Expense trên màn hình
    widget.onAddExpense(Expense(
        amount: enteredAmount,
        date: _selectedDate!,
        title: _titleController.text,
        category: _selectedCategory));

    Navigator.pop(context); // đóng biểu mẫu sau khi ấn submit
  }

  // Xoá đi bộ nhớ tạm của biến nếu không sẽ bị crack
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final keyboardSpace = MediaQuery.of(context).viewInsets.bottom; // Lấy ra phần chiều dài bị bàn phím che mất
    return SafeArea( //Giúp cho widget và camera khng bị conflict
      child: SizedBox(  //Bọc sizebox để chiếm nhiều chiều cao nhất có thể
        height: double.infinity,
        child: SingleChildScrollView(   //Cho phép cuộn để xem các widget
          child: Padding(
            padding:  EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  maxLength: 50,
                  decoration: const InputDecoration(label: Text('Title')),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: '\$', // Thêm kí hiệu $ vào trước chỗ nhập
                          label: Text('Amount'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(_selectedDate == null
                              ? 'No date selected'
                              : formatter.format(_selectedDate!)),
                          // thêm dấu chám than để Dart hiểu giá trị không bao giờ null
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: Icon(Icons.calendar_month),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(children: [
                  DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map(
                            //thuộc tính values là do Dart cung cấp
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category.name.toUpperCase()),
                            ),
                          )
                          .toList(), //chuyển các giá trị thành danh sách
                      onChanged: (value) {
                        if (value == null) {
                          // nếu giá trị là nul thì sẽ không cập nhập setState nữa
                          return;
                        }
                        setState(() {
                          _selectedCategory = value;
                        });
                      }),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      _submitExpenseData();
                    },
                    child: Text('Save Title'),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context); // đóng lại modal
                      },
                      child: Text('Cancel')),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
