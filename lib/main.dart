import 'package:flutter/material.dart';

import 'screens/dashboard_view.dart';
import 'theme/alinma_colors.dart';

void main() => runApp(const WadhahApp());

class WadhahApp extends StatelessWidget {
  const WadhahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'وضّح',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AlinmaColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AlinmaColors.accent,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AlinmaColors.accent,
          surface: AlinmaColors.background,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AlinmaColors.background,
          foregroundColor: AlinmaColors.textPrimary,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      // RTL-first Arabic interface, mirroring the SwiftUI app's forced layout direction.
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: const DashboardView(),
    );
  }
}
