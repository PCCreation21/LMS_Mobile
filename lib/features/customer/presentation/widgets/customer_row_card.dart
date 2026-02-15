import 'package:flutter/material.dart';
import '../../domain/customer_models.dart';

class CustomerRowCard extends StatelessWidget {
  const CustomerRowCard({
    super.key,
    required this.customer,
    required this.onTapNic,
    required this.onEdit,
    required this.onDelete,
  });

  final Customer customer;
  final VoidCallback onTapNic;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isInactive = customer.status == CustomerStatus.inactive;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NIC clickable
                InkWell(
                  onTap: onTapNic,
                  child: Text(
                    customer.nic,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2F4A3D),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  customer.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(customer.phone),
                const SizedBox(height: 4),
                Text(
                  customer.address,
                  style: const TextStyle(color: Color(0xFF4B5563)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _Badge(text: customer.routeCode, tint: const Color(0xFF2F4A3D)),
              const SizedBox(height: 8),
              _Badge(
                text: isInactive ? "Inactive" : "Active",
                tint: isInactive
                    ? const Color(0xFF6B7280)
                    : const Color(0xFF2F4A3D),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Color(0xFFDC2626),
                    ),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.tint});
  final String text;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: tint.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: tint,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
