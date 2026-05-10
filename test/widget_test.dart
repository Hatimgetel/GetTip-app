import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gettip/main.dart';
import 'package:gettip/screens/onboarding_screen.dart';

void main() {
  testWidgets('App shows home title', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      kOnboardingCompleteKey: true,
    });
    await tester.pumpWidget(const TipTrackerApp(onboardingComplete: true));
    await tester.pumpAndSettle();
    expect(find.text('Daily Summary'), findsOneWidget);
  });
}
