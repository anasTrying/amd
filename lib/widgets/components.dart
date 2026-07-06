import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/alinma_colors.dart';

// Shared components — mirrors WadhahApp/Components.swift.

/// Soft copper pill with the Wadhah logo — the Wadhah entry point under amounts.
class WadhahPill extends StatelessWidget {
  const WadhahPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(14, 5, 8, 5),
      decoration: const BoxDecoration(
        color: AlinmaColors.copper,
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      // RTL Row: first child renders on the right — text right, bulb left,
      // matching the design.
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'وضح',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 5),
          ClipOval(
            child: Image.asset(
              'assets/images/wad.png',
              width: 22,
              height: 22,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

/// A single transaction row (used on Dashboard + History).
class TransactionRow extends StatelessWidget {
  const TransactionRow({
    super.key,
    required this.transaction,
    this.showsWadhahPill = false,
    this.onTap,
  });

  final Transaction transaction;
  final bool showsWadhahPill;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AlinmaColors.card,
      borderRadius: BorderRadius.circular(AlinmaColors.cornerRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AlinmaColors.cornerRadius),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AlinmaColors.cardElevated,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(transaction.icon,
                        size: 18, color: AlinmaColors.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.merchant,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AlinmaColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${transaction.category} · ${transaction.timestamp}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AlinmaColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    transaction.formattedAmount,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AlinmaColors.textPrimary,
                    ),
                  ),
                  // Fixed left-pointing chevron, matching the RTL design.
                  const Icon(Icons.chevron_left,
                      size: 16, color: AlinmaColors.textSecondary),
                ],
              ),
              if (showsWadhahPill) ...[
                const SizedBox(height: 8),
                // Bottom-left of the card in RTL (trailing edge), like the design.
                const Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: WadhahPill(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom navigation bar (visual prototype only).
class WadhahTabBar extends StatelessWidget {
  const WadhahTabBar({super.key});

  static const _tabs = [
    (label: 'الرئيسية', icon: Icons.home_rounded),
    (label: 'التحويل', icon: Icons.swap_horiz),
    (label: 'المدفوعات', icon: Icons.credit_card),
    (label: 'المتجر', icon: Icons.shopping_bag_outlined),
    (label: 'الخدمات', icon: Icons.grid_view),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AlinmaColors.card,
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Row(
        children: [
          for (final (index, tab) in _tabs.indexed)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tab.icon,
                    size: 20,
                    color: index == 0
                        ? AlinmaColors.accent
                        : AlinmaColors.textSecondary,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tab.label,
                    style: TextStyle(
                      fontSize: 10,
                      color: index == 0
                          ? AlinmaColors.accent
                          : AlinmaColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
