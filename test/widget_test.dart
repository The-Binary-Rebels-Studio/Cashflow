// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:cashflow/core/di/injection.dart';
import 'package:cashflow/core/localization/locale_manager.dart';

import 'package:cashflow/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Setup dependencies
    await configureDependencies();
    
    // Build our app and trigger a frame.
    final localeManager = getIt<LocaleManager>();
    await tester.pumpWidget(CashFlowApp(localeManager: localeManager));

    // Verify that the onboarding screen loads.
    expect(find.text('Welcome to CashFlow'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
