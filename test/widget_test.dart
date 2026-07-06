import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wadhah_app/main.dart';

void main() {
  testWidgets('dashboard renders balance, greeting and transactions',
      (tester) async {
    await tester.pumpWidget(const WadhahApp());

    expect(find.text('الرصيد الحالي'), findsOneWidget);
    expect(find.text('18,240.75'), findsOneWidget);
    expect(find.text('مرحبًا أنس 👋'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('APPLE COM BILL'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('APPLE COM BILL'), findsOneWidget);
  });

  testWidgets('عرض الكل opens the history screen', (tester) async {
    await tester.pumpWidget(const WadhahApp());

    await tester.scrollUntilVisible(
      find.text('عرض الكل'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('عرض الكل'));
    await tester.pumpAndSettle();

    expect(find.text('سجل العمليات'), findsOneWidget);
    expect(find.text('ELIXIR BUN CO'), findsOneWidget);
  });
}
