import 'package:flutter/material.dart';

class PaymentSummaryScreen extends StatelessWidget {
  final double totalBefore;
  final double totalAfter;

  const PaymentSummaryScreen({
    super.key,
    required this.totalBefore,
    required this.totalAfter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Total Before Discount: \$${totalBefore.toStringAsFixed(2)}'),
            const SizedBox(height: 10),
            Text('Total After Discount: \$${totalAfter.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
