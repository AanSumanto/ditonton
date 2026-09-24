import 'package:core/domain/entities/movie.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovie = Movie(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'Spider-Man',
    overview: 'Overview of the movie',
    popularity: 1.0,
    posterPath: '/path.jpg',
    releaseDate: '2020-05-05',
    title: 'Spider-Man',
    video: false,
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

  testWidgets('MovieCard should display title and overview',
      (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(MovieCard(tMovie)));

    expect(find.text('Spider-Man'), findsOneWidget);
    expect(find.text('Overview of the movie'), findsOneWidget);
  });

  testWidgets('MovieCard onTap should navigate to detail page',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/': (context) => Scaffold(body: MovieCard(tMovie)),
          '/detail': (context) => Scaffold(body: Text('Movie Detail Page')),
        },
      ),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('Movie Detail Page'), findsOneWidget);
  });
}
