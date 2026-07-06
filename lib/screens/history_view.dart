import 'package:flutter/material.dart';

import '../state/bank_store.dart';
import '../theme/alinma_colors.dart';
import '../widgets/components.dart';
import 'chat_view.dart';

// Screen 2: Transaction History (سجل العمليات) — mirrors
// WadhahApp/TransactionHistoryView.swift.

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final store = BankStore.instance;

    return Scaffold(
      backgroundColor: AlinmaColors.background,
      appBar: AppBar(
        title: const Text(
          'سجل العمليات',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: store.recentTransactions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final transaction = store.recentTransactions[index];
          // Every row opens Wadhah; unscripted ones get the generic greeting.
          return TransactionRow(
            transaction: transaction,
            showsWadhahPill: true,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => WadhahChatView(scenario: transaction.scenario),
              ),
            ),
          );
        },
      ),
    );
  }
}
