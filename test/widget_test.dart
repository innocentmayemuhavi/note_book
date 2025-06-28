// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:note_book/main.dart';
import 'package:note_book/controllers/note_controller.dart';
import 'package:note_book/controllers/theme_controller.dart';

void main() {
  group('Note Book App Tests', () {
    setUp(() {
      // Reset GetX before each test
      Get.reset();
    });

    testWidgets('App should have AppBar and BottomNavigationBar', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Wait for any async operations to complete
      await tester.pumpAndSettle();

      // Verify that AppBar is present
      expect(find.byType(AppBar), findsOneWidget);

      // Verify that bottom navigation bar is present
      expect(find.byType(NavigationBar), findsOneWidget);

      // Verify greeting text is present in AppBar
      expect(find.textContaining('Good'), findsOneWidget);

      // Verify navigation destinations are present
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Archived'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('Bottom navigation should work', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify we start on Home tab
      expect(find.text('Home'), findsOneWidget);

      // Tap on Archived tab
      await tester.tap(find.text('Archived'));
      await tester.pumpAndSettle();

      // Verify navigation worked (archived tab should be selected)
      final NavigationBar navBar = tester.widget(find.byType(NavigationBar));
      expect(navBar.selectedIndex, equals(1));

      // Tap on Settings tab
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Verify settings tab is selected
      final NavigationBar navBarAfterSettings = tester.widget(
        find.byType(NavigationBar),
      );
      expect(navBarAfterSettings.selectedIndex, equals(2));
    });

    testWidgets('AppBar should have theme toggle and filter buttons', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify theme toggle button exists
      expect(find.byIcon(Icons.light_mode), findsAny);
      expect(find.byIcon(Icons.dark_mode), findsAny);

      // Verify filter clear button exists
      expect(find.byIcon(Icons.filter_list_off), findsOneWidget);
    });

    testWidgets('App should show notes count in AppBar', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify notes count is displayed
      expect(find.textContaining('notes'), findsOneWidget);
    });

    testWidgets('FloatingActionButton should be present', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify floating action button is present
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('App should handle empty notes state', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // If no notes are loaded, should show empty state or loading
      // This will depend on your actual implementation
      expect(find.byType(CircularProgressIndicator), findsAny);
    });
  });
}
