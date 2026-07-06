import 'package:flutter/material.dart';

// Domain models (dummy data for the prototype).
// Mirrors WadhahApp/Models.swift and shared/…/MockBankRepository.kt.

/// The two scripted Wadhah conversations shown in the demo.
enum ChatScenario { appleSubscription, ambiguousMerchant }

extension ChatScenarioScript on ChatScenario {
  String get userMessage => switch (this) {
        ChatScenario.appleSubscription => 'وشو تاجر (أبل كوم بيل) اللي خصم مني؟',
        ChatScenario.ambiguousMerchant =>
          'مكتوب بالعملية (شركة ثمار التنمية للتجارة) ومخصوم 84 ريال، أنا ما رحت هالشركة!',
      };

  String get assistantMessage => switch (this) {
        ChatScenario.appleSubscription =>
          'هذه عملية شراء أو تجديد اشتراك من شركة آبل، ومصنفة عندنا كخدمات وتطبيقات إلكترونية (مثل زيادة مساحة تخزين الهاتف أو اشتراك تطبيق). انخصم مبلغ 3.69 ريال اليوم الساعة 9:15 صباحاً.\nحاب تصعد الموضوع لخدمة العملاء أو تبغى ترفع اعتراض؟',
        ChatScenario.ambiguousMerchant =>
          'تم التأكد من العملية؛ هذا الاسم التجاري مسجل لجهاز نقاط البيع الخاص بـ سوبرماركت أسواق النخبة (فرع حي الياسمين).\nتم دفع مبلغ 84 ريال عبر بطاقتك (مدى) بمسح الجهاز مباشرة، بتاريخ أمس الساعة 8:30 مساءً.\nحاب نفتح لك خريطة موقع المحل للتأكد؟',
      };

  /// [primary (filled), secondary (outlined)]
  List<String> get actions => switch (this) {
        ChatScenario.appleSubscription => const ['تصعيد لخدمة العملاء', 'اعتراض على العملية'],
        ChatScenario.ambiguousMerchant => const ['موقع المحل على الخريطة', 'تقديم اعتراض'],
      };
}

class Transaction {
  const Transaction({
    required this.merchant,
    required this.category,
    required this.timestamp,
    required this.amountSAR,
    required this.icon,
    this.scenario,
  });

  final String merchant;
  final String category;
  final String timestamp;
  final double amountSAR;
  final IconData icon;
  final ChatScenario? scenario;

  String get formattedAmount => '${amountSAR.toStringAsFixed(2)} SAR';
}

abstract final class DummyData {
  static const recentTransactions = <Transaction>[
    Transaction(
      merchant: 'APPLE COM BILL',
      category: 'خدمات وتطبيقات إلكترونية',
      timestamp: 'اليوم · 9:15 ص',
      amountSAR: -3.69,
      icon: Icons.smartphone,
      scenario: ChatScenario.appleSubscription,
    ),
    Transaction(
      merchant: 'THAMAR AL-TANMIYA TRADING CO',
      category: 'نقاط بيع - مدى',
      timestamp: 'أمس · 8:30 م',
      amountSAR: -84.00,
      icon: Icons.shopping_basket_outlined,
      scenario: ChatScenario.ambiguousMerchant,
    ),
    Transaction(
      merchant: 'HUNGERSTATION LLC',
      category: 'توصيل طعام',
      timestamp: 'قبل يومين',
      amountSAR: -50.84,
      icon: Icons.restaurant,
    ),
    Transaction(
      merchant: 'NAFT SERVICES CO',
      category: 'محطة وقود',
      timestamp: 'قبل 3 أيام',
      amountSAR: -120.00,
      icon: Icons.local_gas_station_outlined,
    ),
    Transaction(
      merchant: 'ELIXIR BUN CO',
      category: 'قهوة مختصة',
      timestamp: 'قبل 4 أيام',
      amountSAR: -26.00,
      icon: Icons.coffee_outlined,
    ),
  ];
}
