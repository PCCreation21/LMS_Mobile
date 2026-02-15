import 'package:flutter/material.dart';

class RecentPaymentTile extends StatelessWidget {
  const RecentPaymentTile({
    super.key,
    required this.name,
    required this.date,
    required this.amount,
    required this.method,
  });

  final String name;
  final String date;
  final String amount;
  final String method;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green.shade100,
        child: const Icon(Icons.person, color: Colors.green),
      ),
      title: Text(name),
      subtitle: Text(date),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(method),
        ],
      ),
    );
  }
}
