import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieListNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockMovieListNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MovieListNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bars when loading',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loading);
    when(mockNotifier.popularMoviesState).thenReturn(RequestState.Loading);
    when(mockNotifier.topRatedMoviesState).thenReturn(RequestState.Loading);

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('Page should display MovieList when loaded',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loaded);
    when(mockNotifier.nowPlayingMovies).thenReturn(<Movie>[]);
    when(mockNotifier.popularMoviesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.popularMovies).thenReturn(<Movie>[]);
    when(mockNotifier.topRatedMoviesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.topRatedMovies).thenReturn(<Movie>[]);

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

    expect(find.byType(MovieList), findsNWidgets(3));
  });

  testWidgets('Page should display Failed text when error',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.Error);
    when(mockNotifier.popularMoviesState).thenReturn(RequestState.Error);
    when(mockNotifier.topRatedMoviesState).thenReturn(RequestState.Error);

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

    expect(find.text('Failed'), findsNWidgets(3));
  });

  testWidgets('Page should display Movie items and navigate when item clicked',
      (WidgetTester tester) async {
    final tMovie = Movie(
      adult: false,
      backdropPath: '/path.jpg',
      genreIds: [1, 2, 3],
      id: 1,
      originalTitle: 'Spider-Man',
      overview: 'Overview',
      popularity: 1.0,
      posterPath: '/path.jpg',
      releaseDate: '2020-05-05',
      title: 'Spider-Man',
      video: false,
      voteAverage: 1.0,
      voteCount: 1,
    );

    when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loaded);
    when(mockNotifier.nowPlayingMovies).thenReturn(<Movie>[tMovie]);
    when(mockNotifier.popularMoviesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.popularMovies).thenReturn(<Movie>[tMovie]);
    when(mockNotifier.topRatedMoviesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.topRatedMovies).thenReturn(<Movie>[tMovie]);

    await tester.pumpWidget(
      ChangeNotifierProvider<MovieListNotifier>.value(
        value: mockNotifier,
        child: MaterialApp(
          routes: {
            '/': (context) => HomeMoviePage(),
            '/detail': (context) => Scaffold(body: Text('Movie Detail Page')),
            '/search': (context) => Scaffold(body: Text('Search Page')),
            '/popular-movie': (context) => Scaffold(body: Text('Popular Movie Page')),
            '/top-rated-movie': (context) => Scaffold(body: Text('Top Rated Movie Page')),
            '/watchlist-movie': (context) => Scaffold(body: Text('Watchlist Movie Page')),
            '/watchlist-tv': (context) => Scaffold(body: Text('Watchlist Tv Page')),
            '/about': (context) => Scaffold(body: Text('About Page')),
            '/home-tv': (context) => Scaffold(body: Text('Home Tv Page')),
          },
        ),
      ),
    );

    expect(find.byType(MovieList), findsNWidgets(3));

    // Tap first Movie item
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    expect(find.text('Movie Detail Page'), findsOneWidget);
  });

  testWidgets('Page should navigate when Search is clicked',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loaded);
    when(mockNotifier.nowPlayingMovies).thenReturn(<Movie>[]);
    when(mockNotifier.popularMoviesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.popularMovies).thenReturn(<Movie>[]);
    when(mockNotifier.topRatedMoviesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.topRatedMovies).thenReturn(<Movie>[]);

    await tester.pumpWidget(
      ChangeNotifierProvider<MovieListNotifier>.value(
        value: mockNotifier,
        child: MaterialApp(
          routes: {
            '/': (context) => HomeMoviePage(),
            '/search': (context) => Scaffold(body: Text('Search Page')),
          },
        ),
      ),
    );

    // Tap Search
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    expect(find.text('Search Page'), findsOneWidget);
  });

  testWidgets('Drawer items should be clickable in HomeMoviePage',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loaded);
    when(mockNotifier.nowPlayingMovies).thenReturn(<Movie>[]);
    when(mockNotifier.popularMoviesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.popularMovies).thenReturn(<Movie>[]);
    when(mockNotifier.topRatedMoviesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.topRatedMovies).thenReturn(<Movie>[]);

    await tester.pumpWidget(
      ChangeNotifierProvider<MovieListNotifier>.value(
        value: mockNotifier,
        child: MaterialApp(
          routes: {
            '/': (context) => HomeMoviePage(),
            '/home-tv': (context) => Scaffold(body: Text('TV Series Page')),
            '/watchlist-movie': (context) => Scaffold(body: Text('Watchlist Movie Page')),
            '/watchlist-tv': (context) => Scaffold(body: Text('Watchlist Tv Page')),
            '/about': (context) => Scaffold(body: Text('About Page')),
          },
        ),
      ),
    );

    // Open drawer
    final scaffoldState = tester.firstState<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV Series'), findsOneWidget);
    expect(find.text('Movie Watchlist'), findsOneWidget);
    expect(find.text('TV Series Watchlist'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);

    // Tap TV Series
    await tester.tap(find.text('TV Series'));
    await tester.pumpAndSettle();
    expect(find.text('TV Series Page'), findsOneWidget);
  });
}
