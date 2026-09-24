import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: body,
    );
  }

  testWidgets('AboutPage should display text and back button',
      (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(AboutPage()));

    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
    expect(
        find.text(
            'Ditonton merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert.'),
        findsOneWidget);

    await tester.tap(find.byType(IconButton));
  });
}
