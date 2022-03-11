import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/transaction.dart';
import 'widgets/chart.dart';
import 'widgets/new_transaction.dart';
import 'widgets/transaction_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        fontFamily: 'Lato',
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(secondary: Colors.red),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction = [];

  List<Transaction> get _previousTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addTransaction(
    String txTitle,
    double txAmount,
    String txCategory,
    DateTime txChosenDate,
  ) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      category: txCategory,
      date: txChosenDate,
    );

    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAddNewTransaction() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return NewTransaction(_addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final _appBar = AppBar(
      title: Text(
        'Personal Expenses',
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: _startAddNewTransaction,
        ),
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: (mediaQuery.size.height -
                          _appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.3,
                  child: Chart(_previousTransactions)),
              SizedBox(
                  height: (mediaQuery.size.height -
                          _appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.7,
                  child: TransactionList(_userTransaction, _deleteTransaction)),
            ],
          ),
        ),
      ),
    );
  }
}
