import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/home_tv_page.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvListNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvListNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvListNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bars when loading',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loading);
    when(mockNotifier.popularTvState).thenReturn(RequestState.Loading);
    when(mockNotifier.topRatedTvState).thenReturn(RequestState.Loading);

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('Page should display TvList when loaded',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loaded);
    when(mockNotifier.nowPlayingTv).thenReturn(<Tv>[]);
    when(mockNotifier.popularTvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.popularTv).thenReturn(<Tv>[]);
    when(mockNotifier.topRatedTvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.topRatedTv).thenReturn(<Tv>[]);

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));

    expect(find.byType(TvList), findsNWidgets(3));
  });

  testWidgets('Page should display Failed text when error',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.Error);
    when(mockNotifier.popularTvState).thenReturn(RequestState.Error);
    when(mockNotifier.topRatedTvState).thenReturn(RequestState.Error);

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));

    expect(find.text('Failed'), findsNWidgets(3));
  });

  testWidgets('Page should display Tv items and navigate when item clicked',
      (WidgetTester tester) async {
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

    when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loaded);
    when(mockNotifier.nowPlayingTv).thenReturn(<Tv>[tTv]);
    when(mockNotifier.popularTvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.popularTv).thenReturn(<Tv>[tTv]);
    when(mockNotifier.topRatedTvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.topRatedTv).thenReturn(<Tv>[tTv]);

    await tester.pumpWidget(
      ChangeNotifierProvider<TvListNotifier>.value(
        value: mockNotifier,
        child: MaterialApp(
          routes: {
            '/': (context) => HomeTvPage(),
            '/detail-tv': (context) => Scaffold(body: Text('Tv Detail Page')),
            '/search-tv': (context) => Scaffold(body: Text('Tv Search Page')),
            '/now-playing-tv': (context) =>
                Scaffold(body: Text('Now Playing Tv Page')),
            '/popular-tv': (context) => Scaffold(body: Text('Popular Tv Page')),
            '/top-rated-tv': (context) =>
                Scaffold(body: Text('Top Rated Tv Page')),
            '/watchlist-movie': (context) =>
                Scaffold(body: Text('Watchlist Movie Page')),
            '/watchlist-tv': (context) =>
                Scaffold(body: Text('Watchlist Tv Page')),
            '/about': (context) => Scaffold(body: Text('About Page')),
            '/home': (context) => Scaffold(body: Text('Movies Home Page')),
          },
        ),
      ),
    );

    expect(find.byType(TvList), findsNWidgets(3));

    // Tap first Tv item in TvList
    final tvItemFinder = find
        .descendant(
          of: find.byType(TvList),
          matching: find.byType(InkWell),
        )
        .first;
    await tester.tap(tvItemFinder);
    await tester.pumpAndSettle();
    expect(find.text('Tv Detail Page'), findsOneWidget);
  });

  testWidgets('Page should navigate when See More is clicked',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loaded);
    when(mockNotifier.nowPlayingTv).thenReturn(<Tv>[]);
    when(mockNotifier.popularTvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.popularTv).thenReturn(<Tv>[]);
    when(mockNotifier.topRatedTvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.topRatedTv).thenReturn(<Tv>[]);

    await tester.pumpWidget(
      ChangeNotifierProvider<TvListNotifier>.value(
        value: mockNotifier,
        child: MaterialApp(
          routes: {
            '/': (context) => HomeTvPage(),
            '/now-playing-tv': (context) =>
                Scaffold(body: Text('Now Playing Tv Page')),
            '/popular-tv': (context) => Scaffold(body: Text('Popular Tv Page')),
            '/top-rated-tv': (context) =>
                Scaffold(body: Text('Top Rated Tv Page')),
            '/search-tv': (context) => Scaffold(body: Text('Tv Search Page')),
          },
        ),
      ),
    );

    // Tap Search
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    expect(find.text('Tv Search Page'), findsOneWidget);
  });

  testWidgets('Drawer items should be clickable', (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loaded);
    when(mockNotifier.nowPlayingTv).thenReturn(<Tv>[]);
    when(mockNotifier.popularTvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.popularTv).thenReturn(<Tv>[]);
    when(mockNotifier.topRatedTvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.topRatedTv).thenReturn(<Tv>[]);

    await tester.pumpWidget(
      ChangeNotifierProvider<TvListNotifier>.value(
        value: mockNotifier,
        child: MaterialApp(
          routes: {
            '/': (context) => HomeTvPage(),
            '/home': (context) => Scaffold(body: Text('Movies Home Page')),
            '/watchlist-movie': (context) =>
                Scaffold(body: Text('Watchlist Movie Page')),
            '/watchlist-tv': (context) =>
                Scaffold(body: Text('Watchlist Tv Page')),
            '/about': (context) => Scaffold(body: Text('About Page')),
          },
        ),
      ),
    );

    // Open drawer
    final scaffoldState =
        tester.firstState<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV Series'), findsOneWidget);
    expect(find.text('Movie Watchlist'), findsOneWidget);
    expect(find.text('TV Series Watchlist'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);

    // Tap Movies
    await tester.tap(find.text('Movies'));
    await tester.pumpAndSettle();
    expect(find.text('Movies Home Page'), findsOneWidget);
  });
}
