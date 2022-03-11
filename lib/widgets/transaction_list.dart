import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  late final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
          builder: (ctx, constraints) {
            return Column(
                children: [
                  Text('No transactions yet',
                      style: Theme.of(context).textTheme.headline5),
                  const Divider(),
                  SizedBox(
                    height: constraints.maxHeight * 0.6,
                    child:
                        Image.asset('assets/images/waiting.png', fit: BoxFit.cover),
                  ),
                ],
              );
          }
        )
        : ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.grey,
                  ),
                  onLongPress: () => deleteTx(transactions[index].id),
                  onPressed: () {},
                  child: ListTile(
                    title: Text(
                      transactions[index].title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          child: Text(
                            transactions[index]
                                        .amount
                                        .toStringAsFixed(2)
                                        .length >
                                    8
                                ? '\$${NumberFormat.compact().format(transactions[index].amount)}'
                                : '\$${transactions[index].amount.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    leading: SizedBox(
                      width: 80,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${transactions[index].category}'),
                              ],
                            ),
                            Text(
                              DateFormat.MMMd()
                                  .format(transactions[index].date),
                              style: TextStyle(color: Colors.black54,),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}
