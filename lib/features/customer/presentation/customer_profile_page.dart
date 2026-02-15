import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/customer_list_controller.dart';

class CustomerProfilePage extends ConsumerWidget {
  const CustomerProfilePage({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customerListProvider);
    final customer = state.all.firstWhere((c) => c.id == id);

    return Scaffold(
      appBar: AppBar(title: const Text("Customer Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              customer.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("NIC: ${customer.nic}"),
            Text("Phone: ${customer.phone}"),
            Text("Secondary: ${customer.secondaryPhone ?? '-'}"),
            Text("Address: ${customer.address}"),
            Text("Email: ${customer.email ?? '-'}"),
            Text("Route: ${customer.routeCode}"),
            Text(
              "Created: ${customer.createdDate.toIso8601String().split('T').first}",
            ),
            Text("Status: ${customer.status.name}"),
            const SizedBox(height: 10),
            Text(
              "Loans: ${customer.loanNumbers.isEmpty ? '-' : customer.loanNumbers.join(', ')}",
            ),
          ],
        ),
      ),
    );
  }
}
