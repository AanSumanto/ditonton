import 'package:core/domain/entities/tv.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTv = Tv(
    backdropPath: '/path.jpg',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'Game of Thrones',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Game of Thrones',
    overview: 'Overview of the show',
    popularity: 1.0,
    posterPath: '/path.jpg',
    firstAirDate: '2021-01-01',
    voteAverage: 1.0,
    voteCount: 1,
  );

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(
        body: body,
      ),
    );
  }

  testWidgets('TvCard should display title and overview',
      (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(TvCard(tTv)));

    expect(find.text('Game of Thrones'), findsOneWidget);
    expect(find.text('Overview of the show'), findsOneWidget);
  });

  testWidgets('TvCard onTap should navigate to detail page',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/': (context) => Scaffold(body: TvCard(tTv)),
          '/detail-tv': (context) => Scaffold(body: Text('Detail Page')),
        },
      ),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('Detail Page'), findsOneWidget);
  });
}
