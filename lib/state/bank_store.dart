import 'package:flutter/foundation.dart';

import '../models/models.dart';

// State layer mirroring WadhahApp/BankStore.swift (and the KMP
// MockBankRepository / WadhahAssistant in shared/).

class Account {
  const Account({
    required this.holderFirstName,
    required this.balanceSAR,
    required this.cardSuffix,
    required this.cardExpiry,
    required this.loyaltyPoints,
  });

  final String holderFirstName;
  final double balanceSAR;
  final String cardSuffix;
  final String cardExpiry;
  final int loyaltyPoints;

  /// Western digits with grouping, matching the design (e.g. "18,240.75").
  String get formattedBalance {
    final parts = balanceSAR.toStringAsFixed(2).split('.');
    return '${_grouped(parts[0])}.${parts[1]}';
  }

  /// e.g. "1,330"
  String get formattedPoints => _grouped(loyaltyPoints.toString());

  static String _grouped(String digits) {
    final sign = digits.startsWith('-') ? '-' : '';
    final body = sign.isEmpty ? digits : digits.substring(1);
    final buffer = StringBuffer(sign);
    for (var i = 0; i < body.length; i++) {
      if (i > 0 && (body.length - i) % 3 == 0) buffer.write(',');
      buffer.write(body[i]);
    }
    return buffer.toString();
  }
}

class BankStore {
  const BankStore._();

  static const instance = BankStore._();

  Account get account => const Account(
        holderFirstName: 'أنس',
        balanceSAR: 18240.75,
        cardSuffix: '4821',
        cardExpiry: '08/28',
        loyaltyPoints: 1330,
      );

  List<Transaction> get recentTransactions => DummyData.recentTransactions;

  /// Home shows only the first 3.
  List<Transaction> get latestTransactions => recentTransactions.take(3).toList();
}

// ---------------------------------------------------------------------------
// Chat

enum ChatRole { user, assistant }

class WadhahChatMessage {
  WadhahChatMessage({
    required this.id,
    required this.role,
    required this.text,
    this.actions = const [],
    this.isTyping = false,
  });

  final int id;
  final ChatRole role;
  String text;
  List<String> actions;
  bool isTyping;
}

/// Scripted assistant orchestration for the demo — the same surface a real
/// generative backend will implement later.
class WadhahChatEngine extends ChangeNotifier {
  WadhahChatEngine(ChatScenario? scenario) {
    if (scenario != null) {
      _messages
        ..add(_message(ChatRole.user, scenario.userMessage))
        ..add(_message(ChatRole.assistant, scenario.assistantMessage,
            actions: scenario.actions));
    } else {
      _messages.add(_message(
        ChatRole.assistant,
        'هلا! أنا وضّح 👋 اسألني عن أي عملية أو رسوم أو اشتراك في حسابك.',
      ));
    }
  }

  final List<WadhahChatMessage> _messages = [];
  int _nextId = 0;
  bool _disposed = false;

  List<WadhahChatMessage> get messages => List.unmodifiable(_messages);

  WadhahChatMessage _message(ChatRole role, String text,
          {List<String> actions = const []}) =>
      WadhahChatMessage(id: _nextId++, role: role, text: text, actions: actions);

  void send(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    _messages.add(_message(ChatRole.user, trimmed));
    final typing = _message(ChatRole.assistant, '')..isTyping = true;
    _messages.add(typing);
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 1100), () {
      if (_disposed) return;
      typing
        ..isTyping = false
        ..text =
            'استلمت سؤالك 👌 هذي نسخة تجريبية من وضّح — في التطبيق الفعلي بجاوبك من بيانات حسابك وسجل عملياتك مباشرة.';
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
