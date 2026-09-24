import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ditonton/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Integration Test: Navigate between Movies, TV Series, and Search',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Verify on Movies page initially
    expect(find.text('Ditonton'), findsOneWidget);

    // Open drawer
    final drawerButton = find.byTooltip('Open navigation menu');
    if (drawerButton.evaluate().isNotEmpty) {
      await tester.tap(drawerButton);
    } else {
      final scaffoldFinder = find.byType(Scaffold);
      final scaffoldState = tester.firstState<ScaffoldState>(scaffoldFinder);
      scaffoldState.openDrawer();
    }
    await tester.pumpAndSettle();

    // Verify drawer contents
    expect(find.text('TV Series'), findsOneWidget);
    expect(find.text('Movie Watchlist'), findsOneWidget);
    expect(find.text('TV Series Watchlist'), findsOneWidget);

    // Tap TV Series in drawer
    await tester.tap(find.text('TV Series'));
    await tester.pumpAndSettle();

    // Verify on TV Series page
    expect(find.text('Ditonton - TV Series'), findsOneWidget);
    expect(find.text('Now Playing'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);

    // Tap Search in AppBar
    final searchButton = find.byIcon(Icons.search);
    expect(searchButton, findsOneWidget);
    await tester.tap(searchButton);
    await tester.pumpAndSettle();

    // Verify on Search page
    expect(find.byType(TextField), findsOneWidget);

    // Enter search query
    await tester.enterText(find.byType(TextField), 'Game');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    // Go back to TV Series page
    final backButton = find.byTooltip('Back');
    if (backButton.evaluate().isNotEmpty) {
      await tester.tap(backButton);
    } else {
      final backIcon = find.byIcon(Icons.arrow_back);
      if (backIcon.evaluate().isNotEmpty) {
        await tester.tap(backIcon);
      }
    }
    await tester.pumpAndSettle();
  });
}
