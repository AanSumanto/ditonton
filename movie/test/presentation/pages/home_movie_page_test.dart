import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:movie/presentation/bloc/now_playing_movies_bloc.dart';
import 'package:movie/presentation/bloc/popular_movies_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNowPlayingMoviesBloc
    extends MockBloc<NowPlayingMoviesEvent, NowPlayingMoviesState>
    implements NowPlayingMoviesBloc {}

class MockPopularMoviesBloc
    extends MockBloc<PopularMoviesEvent, PopularMoviesState>
    implements PopularMoviesBloc {}

class MockTopRatedMoviesBloc
    extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState>
    implements TopRatedMoviesBloc {}

void main() {
  late MockNowPlayingMoviesBloc mockNowPlayingMoviesBloc;
  late MockPopularMoviesBloc mockPopularMoviesBloc;
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;

  setUp(() {
    mockNowPlayingMoviesBloc = MockNowPlayingMoviesBloc();
    mockPopularMoviesBloc = MockPopularMoviesBloc();
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingMoviesBloc>.value(
            value: mockNowPlayingMoviesBloc),
        BlocProvider<PopularMoviesBloc>.value(value: mockPopularMoviesBloc),
        BlocProvider<TopRatedMoviesBloc>.value(value: mockTopRatedMoviesBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bars when loading',
      (WidgetTester tester) async {
    whenListen(
      mockNowPlayingMoviesBloc,
      Stream.fromIterable([NowPlayingMoviesLoading()]),
      initialState: NowPlayingMoviesLoading(),
    );
    whenListen(
      mockPopularMoviesBloc,
      Stream.fromIterable([PopularMoviesLoading()]),
      initialState: PopularMoviesLoading(),
    );
    whenListen(
      mockTopRatedMoviesBloc,
      Stream.fromIterable([TopRatedMoviesLoading()]),
      initialState: TopRatedMoviesLoading(),
    );

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('Page should display MovieList when loaded',
      (WidgetTester tester) async {
    whenListen(
      mockNowPlayingMoviesBloc,
      Stream.fromIterable([const NowPlayingMoviesLoaded(<Movie>[])]),
      initialState: const NowPlayingMoviesLoaded(<Movie>[]),
    );
    whenListen(
      mockPopularMoviesBloc,
      Stream.fromIterable([const PopularMoviesLoaded(<Movie>[])]),
      initialState: const PopularMoviesLoaded(<Movie>[]),
    );
    whenListen(
      mockTopRatedMoviesBloc,
      Stream.fromIterable([const TopRatedMoviesLoaded(<Movie>[])]),
      initialState: const TopRatedMoviesLoaded(<Movie>[]),
    );

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

    expect(find.byType(MovieList), findsNWidgets(3));
  });

  testWidgets('Page should display Failed text when error',
      (WidgetTester tester) async {
    whenListen(
      mockNowPlayingMoviesBloc,
      Stream.fromIterable([const NowPlayingMoviesError('Failed')]),
      initialState: const NowPlayingMoviesError('Failed'),
    );
    whenListen(
      mockPopularMoviesBloc,
      Stream.fromIterable([const PopularMoviesError('Failed')]),
      initialState: const PopularMoviesError('Failed'),
    );
    whenListen(
      mockTopRatedMoviesBloc,
      Stream.fromIterable([const TopRatedMoviesError('Failed')]),
      initialState: const TopRatedMoviesError('Failed'),
    );

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

    expect(find.text('Failed'), findsNWidgets(3));
  });

  testWidgets('Page should display Movie items and navigate when item clicked',
      (WidgetTester tester) async {
    final tMovie = Movie(
      adult: false,
      backdropPath: '/path.jpg',
      genreIds: const [1, 2, 3],
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

    whenListen(
      mockNowPlayingMoviesBloc,
      Stream<NowPlayingMoviesState>.empty(),
      initialState: NowPlayingMoviesLoaded(<Movie>[tMovie]),
    );
    whenListen(
      mockPopularMoviesBloc,
      Stream<PopularMoviesState>.empty(),
      initialState: PopularMoviesLoaded(<Movie>[tMovie]),
    );
    whenListen(
      mockTopRatedMoviesBloc,
      Stream<TopRatedMoviesState>.empty(),
      initialState: TopRatedMoviesLoaded(<Movie>[tMovie]),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<NowPlayingMoviesBloc>.value(
              value: mockNowPlayingMoviesBloc),
          BlocProvider<PopularMoviesBloc>.value(value: mockPopularMoviesBloc),
          BlocProvider<TopRatedMoviesBloc>.value(
              value: mockTopRatedMoviesBloc),
        ],
        child: MaterialApp(
          routes: {
            '/': (context) => HomeMoviePage(),
            '/detail': (context) =>
                const Scaffold(body: Text('Movie Detail Page')),
            '/search': (context) => const Scaffold(body: Text('Search Page')),
            '/popular-movie': (context) =>
                const Scaffold(body: Text('Popular Movie Page')),
            '/top-rated-movie': (context) =>
                const Scaffold(body: Text('Top Rated Movie Page')),
            '/watchlist-movie': (context) =>
                const Scaffold(body: Text('Watchlist Movie Page')),
            '/watchlist-tv': (context) =>
                const Scaffold(body: Text('Watchlist Tv Page')),
            '/about': (context) => const Scaffold(body: Text('About Page')),
            '/home-tv': (context) =>
                const Scaffold(body: Text('Home Tv Page')),
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
    whenListen(
      mockNowPlayingMoviesBloc,
      Stream<NowPlayingMoviesState>.empty(),
      initialState: const NowPlayingMoviesLoaded(<Movie>[]),
    );
    whenListen(
      mockPopularMoviesBloc,
      Stream<PopularMoviesState>.empty(),
      initialState: const PopularMoviesLoaded(<Movie>[]),
    );
    whenListen(
      mockTopRatedMoviesBloc,
      Stream<TopRatedMoviesState>.empty(),
      initialState: const TopRatedMoviesLoaded(<Movie>[]),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<NowPlayingMoviesBloc>.value(
              value: mockNowPlayingMoviesBloc),
          BlocProvider<PopularMoviesBloc>.value(value: mockPopularMoviesBloc),
          BlocProvider<TopRatedMoviesBloc>.value(
              value: mockTopRatedMoviesBloc),
        ],
        child: MaterialApp(
          routes: {
            '/': (context) => HomeMoviePage(),
            '/search': (context) => const Scaffold(body: Text('Search Page')),
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
    whenListen(
      mockNowPlayingMoviesBloc,
      Stream<NowPlayingMoviesState>.empty(),
      initialState: const NowPlayingMoviesLoaded(<Movie>[]),
    );
    whenListen(
      mockPopularMoviesBloc,
      Stream<PopularMoviesState>.empty(),
      initialState: const PopularMoviesLoaded(<Movie>[]),
    );
    whenListen(
      mockTopRatedMoviesBloc,
      Stream<TopRatedMoviesState>.empty(),
      initialState: const TopRatedMoviesLoaded(<Movie>[]),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<NowPlayingMoviesBloc>.value(
              value: mockNowPlayingMoviesBloc),
          BlocProvider<PopularMoviesBloc>.value(value: mockPopularMoviesBloc),
          BlocProvider<TopRatedMoviesBloc>.value(
              value: mockTopRatedMoviesBloc),
        ],
        child: MaterialApp(
          routes: {
            '/': (context) => HomeMoviePage(),
            '/home-tv': (context) =>
                const Scaffold(body: Text('TV Series Page')),
            '/watchlist-movie': (context) =>
                const Scaffold(body: Text('Watchlist Movie Page')),
            '/watchlist-tv': (context) =>
                const Scaffold(body: Text('Watchlist Tv Page')),
            '/about': (context) => const Scaffold(body: Text('About Page')),
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

    // Tap TV Series
    await tester.tap(find.text('TV Series'));
    await tester.pumpAndSettle();
    expect(find.text('TV Series Page'), findsOneWidget);
  });

  testWidgets('Drawer items Watchlist, About and Movies should navigate or pop',
      (WidgetTester tester) async {
    whenListen(
      mockNowPlayingMoviesBloc,
      Stream<NowPlayingMoviesState>.empty(),
      initialState: const NowPlayingMoviesLoaded(<Movie>[]),
    );
    whenListen(
      mockPopularMoviesBloc,
      Stream<PopularMoviesState>.empty(),
      initialState: const PopularMoviesLoaded(<Movie>[]),
    );
    whenListen(
      mockTopRatedMoviesBloc,
      Stream<TopRatedMoviesState>.empty(),
      initialState: const TopRatedMoviesLoaded(<Movie>[]),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<NowPlayingMoviesBloc>.value(
              value: mockNowPlayingMoviesBloc),
          BlocProvider<PopularMoviesBloc>.value(value: mockPopularMoviesBloc),
          BlocProvider<TopRatedMoviesBloc>.value(
              value: mockTopRatedMoviesBloc),
        ],
        child: MaterialApp(
          routes: {
            '/': (context) => HomeMoviePage(),
            '/watchlist-movie': (context) =>
                const Scaffold(body: Text('Watchlist Movie Page')),
            '/watchlist-tv': (context) =>
                const Scaffold(body: Text('Watchlist Tv Page')),
            '/about': (context) => const Scaffold(body: Text('About Page')),
            '/search': (context) => const Scaffold(body: Text('Search Page')),
            '/popular-movie': (context) =>
                const Scaffold(body: Text('Popular Page')),
            '/top-rated-movie': (context) =>
                const Scaffold(body: Text('Top Rated Page')),
            '/detail': (context) =>
                const Scaffold(body: Text('Movie Detail Page')),
          },
        ),
      ),
    );

    // Open drawer & tap Movie Watchlist
    var scaffoldState =
        tester.firstState<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Movie Watchlist'));
    await tester.pumpAndSettle();
    expect(find.text('Watchlist Movie Page'), findsOneWidget);

    // Navigate back
    Navigator.pop(tester.element(find.text('Watchlist Movie Page')));
    await tester.pumpAndSettle();

    // Open drawer & tap TV Series Watchlist
    scaffoldState = tester.firstState<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.text('TV Series Watchlist'));
    await tester.pumpAndSettle();
    expect(find.text('Watchlist Tv Page'), findsOneWidget);

    // Navigate back
    Navigator.pop(tester.element(find.text('Watchlist Tv Page')));
    await tester.pumpAndSettle();

    // Open drawer & tap About
    scaffoldState = tester.firstState<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();
    expect(find.text('About Page'), findsOneWidget);

    // Navigate back
    Navigator.pop(tester.element(find.text('About Page')));
    await tester.pumpAndSettle();

    // Open drawer & tap Movies (pop drawer)
    scaffoldState = tester.firstState<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Movies'));
    await tester.pumpAndSettle();

    // Tap Search in AppBar
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    expect(find.text('Search Page'), findsOneWidget);

    // Navigate back
    Navigator.pop(tester.element(find.text('Search Page')));
    await tester.pumpAndSettle();

    // Tap Popular See More
    final seeMores = find.text('See More');
    await tester.tap(seeMores.first);
    await tester.pumpAndSettle();
    expect(find.text('Popular Page'), findsOneWidget);

    // Navigate back
    Navigator.pop(tester.element(find.text('Popular Page')));
    await tester.pumpAndSettle();

    // Tap Top Rated See More
    await tester.tap(find.text('See More').last);
    await tester.pumpAndSettle();
    expect(find.text('Top Rated Page'), findsOneWidget);
  });

  testWidgets('MovieList item tap should navigate to MovieDetailPage',
      (WidgetTester tester) async {
    final tMovie = Movie(
      adult: false,
      backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
      genreIds: const [14, 28],
      id: 557,
      originalTitle: 'Spider-Man',
      overview: 'Overview',
      popularity: 60.441,
      posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
      releaseDate: '2002-05-01',
      title: 'Spider-Man',
      video: false,
      voteAverage: 7.2,
      voteCount: 13507,
    );

    whenListen(
      mockNowPlayingMoviesBloc,
      Stream<NowPlayingMoviesState>.empty(),
      initialState: NowPlayingMoviesLoaded([tMovie]),
    );
    whenListen(
      mockPopularMoviesBloc,
      Stream<PopularMoviesState>.empty(),
      initialState: const PopularMoviesLoaded(<Movie>[]),
    );
    whenListen(
      mockTopRatedMoviesBloc,
      Stream<TopRatedMoviesState>.empty(),
      initialState: const TopRatedMoviesLoaded(<Movie>[]),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<NowPlayingMoviesBloc>.value(
              value: mockNowPlayingMoviesBloc),
          BlocProvider<PopularMoviesBloc>.value(value: mockPopularMoviesBloc),
          BlocProvider<TopRatedMoviesBloc>.value(
              value: mockTopRatedMoviesBloc),
        ],
        child: MaterialApp(
          routes: {
            '/': (context) => HomeMoviePage(),
            '/detail': (context) =>
                const Scaffold(body: Text('Movie Detail Page')),
          },
        ),
      ),
    );

    await tester.pump();
    expect(find.byType(InkWell), findsWidgets);
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
  });
}
