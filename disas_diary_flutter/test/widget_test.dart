// Basic Flutter widget test for Disas Diary

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:disas_diary/main.dart';
import 'package:disas_diary/providers/app_state.dart';
import 'package:disas_diary/services/persistence_service.dart';

void main() {
  testWidgets('App loads and displays Tarmogoyf', (WidgetTester tester) async {
    // Initialize SharedPreferences with mock values
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final persistenceService = PersistenceService(prefs);

    // Build our app and trigger a frame
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(persistenceService),
        child: const DisasDiaryApp(),
      ),
    );

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Verify that Tarmogoyf is displayed
    expect(find.text('Tarmogoyf'), findsOneWidget);

    // Verify that the app title is displayed
    expect(find.text('Disas Diary'), findsOneWidget);

    // Verify card type toggles are present
    expect(find.text('Creature'), findsOneWidget);
    expect(find.text('Artifact'), findsOneWidget);
  });
}
