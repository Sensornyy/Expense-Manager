import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function function;

  NewTransaction(this.function);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  final FocusNode titleFocus = FocusNode();
  final FocusNode amountFocus = FocusNode();


  DateTime? _selectedDate;

  List categories = [
    'Fitness💪',
    'Education‍🎓',
    'Transport🚗',
    'IT🖥️',
    'House🏠',
    'Gifts🎁',
    'Food🍎',
    'Clothes👚'
  ];
  String? selectedCategory;

  void _focusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _chooseDate() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate == null ? DateTime.now() : _selectedDate!,
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void submitData() {
    if (_formKey.currentState!.validate()) {
      widget.function(
        titleController.text,
        double.parse(amountController.text),
        selectedCategory,
        _selectedDate ?? DateTime.now(),
      );
      Navigator.pop(context);
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 8, right: 8, top: 12, bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleController,
                focusNode: titleFocus,
                validator: (value) => _nameValidate(value!),
                onFieldSubmitted: (_) {
                  _focusChange(context, titleFocus, amountFocus);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                focusNode: amountFocus,
                keyboardType: TextInputType.number,
                validator: (value) => _amountValidate((value!)),
              ),
              DropdownButtonFormField(
                items: categories.map((category) {
                  return DropdownMenuItem(
                    child: Text(category),
                    value: category,
                  );
                }).toList(),
                onChanged: (category) {
                  setState(() {
                    selectedCategory = category as String?;
                  });
                },
                value: selectedCategory,
                validator: (value) =>
                    value == null ? 'Please choose a category' : null,
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Today'
                          : 'Date:    ${DateFormat.MMMd().format(_selectedDate!)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _chooseDate,
                    child: Text(
                      'Choose date',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: Text(
                      'Add Expense',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: submitData,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? _nameValidate(String value) {
  if (value.isEmpty) {
    return 'Title is required';
  } else if (value.length > 17) {
    return 'Title should be short';
  }
  return null;
}

String? _amountValidate(String value) {
  if (value == '') {
    return 'Please enter an amount';
  } else if (double.parse(value) < 0) {
    return 'Invalid amount';
  }
}
