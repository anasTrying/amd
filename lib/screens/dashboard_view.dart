import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state/bank_store.dart';
import '../theme/alinma_colors.dart';
import '../widgets/components.dart';
import 'history_view.dart';
import 'chat_view.dart';

// Screen 1: Home Dashboard (الرئيسية) — mirrors WadhahApp/DashboardView.swift.
// Tapping a transaction opens the Wadhah chat as a bottom sheet.

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  static const _quickActions = [
    (label: 'دفع الفواتير', icon: Icons.receipt_long_outlined),
    (label: 'الحوالات السريعة', icon: Icons.swap_horizontal_circle_outlined),
    (label: 'شحن الجوال', icon: Icons.smartphone),
    (label: 'المخالفات المرورية', icon: Icons.directions_car_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final store = BankStore.instance;

    return Scaffold(
      backgroundColor: AlinmaColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  _header(store),
                  const SizedBox(height: 14),
                  _pointsBadge(store),
                  const SizedBox(height: 20),
                  _balanceCard(store),
                  const SizedBox(height: 20),
                  _quickActionsRow(),
                  const SizedBox(height: 20),
                  _banner('assets/images/car-banner.png'),
                  const SizedBox(height: 12),
                  _banner('assets/images/airalo-banner.png'),
                  const SizedBox(height: 20),
                  _latestTransactions(context, store),
                ],
              ),
            ),
            const WadhahTabBar(),
          ],
        ),
      ),
    );
  }

  // Header (اللوقو + الترحيب + الجرس)

  Widget _header(BankStore store) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Image.asset('assets/images/banklogo.png', fit: BoxFit.contain),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'مساء الخير',
              style: TextStyle(fontSize: 13, color: AlinmaColors.textSecondary),
            ),
            const SizedBox(height: 2),
            Text(
              'مرحبًا ${store.account.holderFirstName} 👋',
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AlinmaColors.textPrimary,
              ),
            ),
          ],
        ),
        const Spacer(),
        _notificationBell(),
      ],
    );
  }

  Widget _notificationBell() {
    return Stack(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AlinmaColors.card,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.notifications_none,
              size: 20, color: AlinmaColors.textPrimary),
        ),
        const PositionedDirectional(
          top: 5,
          start: 5,
          child: CircleAvatar(radius: 4.5, backgroundColor: AlinmaColors.accent),
        ),
      ],
    );
  }

  Widget _pointsBadge(BankStore store) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: const BoxDecoration(
          color: AlinmaColors.pointsLavender45,
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, size: 12, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              '${store.account.formattedPoints} نقطة',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Balance card (الرصيد الحالي)

  Widget _balanceCard(BankStore store) {
    final account = store.account;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AlinmaColors.card,
        borderRadius: BorderRadius.circular(AlinmaColors.cornerRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الرصيد الحالي',
            style: TextStyle(fontSize: 14, color: AlinmaColors.textSecondary),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                account.formattedBalance,
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: AlinmaColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'SAR',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AlinmaColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                '•••• ${account.cardSuffix}',
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                    fontSize: 12, color: AlinmaColors.textSecondary),
              ),
              const Spacer(),
              Text(
                'صالحة حتى ${account.cardExpiry}',
                style: const TextStyle(
                    fontSize: 12, color: AlinmaColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Quick actions

  Widget _quickActionsRow() {
    return Row(
      children: [
        for (final (index, action) in _quickActions.indexed) ...[
          if (index > 0) const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 96,
              decoration: BoxDecoration(
                color: AlinmaColors.card,
                borderRadius: BorderRadius.circular(AlinmaColors.cornerRadius),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AlinmaColors.background.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child:
                        Icon(action.icon, size: 22, color: AlinmaColors.accent),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      action.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AlinmaColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _banner(String asset) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AlinmaColors.cornerRadius),
      child: Image.asset(asset, width: double.infinity, fit: BoxFit.fitWidth),
    );
  }

  // Latest transactions

  Widget _latestTransactions(BuildContext context, BankStore store) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text(
              'آخر العمليات',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AlinmaColors.textPrimary,
              ),
            ),
            const Spacer(),
            Text(
              'آخر ${store.latestTransactions.length} عمليات',
              style: const TextStyle(
                  fontSize: 11, color: AlinmaColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final transaction in store.latestTransactions) ...[
          TransactionRow(
            transaction: transaction,
            onTap: () => showWadhahChatSheet(context, transaction.scenario),
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          height: 48,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AlinmaColors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HistoryView()),
            ),
            child: const Text(
              'عرض الكل',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
