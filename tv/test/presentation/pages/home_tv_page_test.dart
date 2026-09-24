import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:tv/presentation/bloc/now_playing_tv_bloc.dart';
import 'package:tv/presentation/bloc/popular_tv_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:tv/presentation/pages/home_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNowPlayingTvBloc
    extends MockBloc<NowPlayingTvEvent, NowPlayingTvState>
    implements NowPlayingTvBloc {}

class MockPopularTvBloc
    extends MockBloc<PopularTvEvent, PopularTvState>
    implements PopularTvBloc {}

class MockTopRatedTvBloc
    extends MockBloc<TopRatedTvEvent, TopRatedTvState>
    implements TopRatedTvBloc {}

void main() {
  late MockNowPlayingTvBloc mockNowPlayingTvBloc;
  late MockPopularTvBloc mockPopularTvBloc;
  late MockTopRatedTvBloc mockTopRatedTvBloc;

  setUp(() {
    mockNowPlayingTvBloc = MockNowPlayingTvBloc();
    mockPopularTvBloc = MockPopularTvBloc();
    mockTopRatedTvBloc = MockTopRatedTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingTvBloc>.value(value: mockNowPlayingTvBloc),
        BlocProvider<PopularTvBloc>.value(value: mockPopularTvBloc),
        BlocProvider<TopRatedTvBloc>.value(value: mockTopRatedTvBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bars when loading',
      (WidgetTester tester) async {
    whenListen(
      mockNowPlayingTvBloc,
      Stream<NowPlayingTvState>.empty(),
      initialState: NowPlayingTvLoading(),
    );
    whenListen(
      mockPopularTvBloc,
      Stream<PopularTvState>.empty(),
      initialState: PopularTvLoading(),
    );
    whenListen(
      mockTopRatedTvBloc,
      Stream<TopRatedTvState>.empty(),
      initialState: TopRatedTvLoading(),
    );

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('Page should display TvList when loaded',
      (WidgetTester tester) async {
    whenListen(
      mockNowPlayingTvBloc,
      Stream<NowPlayingTvState>.empty(),
      initialState: const NowPlayingTvLoaded(<Tv>[]),
    );
    whenListen(
      mockPopularTvBloc,
      Stream<PopularTvState>.empty(),
      initialState: const PopularTvLoaded(<Tv>[]),
    );
    whenListen(
      mockTopRatedTvBloc,
      Stream<TopRatedTvState>.empty(),
      initialState: const TopRatedTvLoaded(<Tv>[]),
    );

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));

    expect(find.byType(TvList), findsNWidgets(3));
  });

  testWidgets('Page should display Failed text when error',
      (WidgetTester tester) async {
    whenListen(
      mockNowPlayingTvBloc,
      Stream<NowPlayingTvState>.empty(),
      initialState: const NowPlayingTvError('Failed'),
    );
    whenListen(
      mockPopularTvBloc,
      Stream<PopularTvState>.empty(),
      initialState: const PopularTvError('Failed'),
    );
    whenListen(
      mockTopRatedTvBloc,
      Stream<TopRatedTvState>.empty(),
      initialState: const TopRatedTvError('Failed'),
    );

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));

    expect(find.text('Failed'), findsNWidgets(3));
  });

  testWidgets('Page should display Tv items and navigate when item clicked',
      (WidgetTester tester) async {
    final tTv = Tv(
      backdropPath: '/path.jpg',
      genreIds: const [1, 2, 3],
      id: 1,
      name: 'Game of Thrones',
      originCountry: const ['US'],
      originalLanguage: 'en',
      originalName: 'Game of Thrones',
      overview: 'Overview of the show',
      popularity: 1.0,
      posterPath: '/path.jpg',
      firstAirDate: '2021-01-01',
      voteAverage: 1.0,
      voteCount: 1,
    );

    whenListen(
      mockNowPlayingTvBloc,
      Stream<NowPlayingTvState>.empty(),
      initialState: NowPlayingTvLoaded(<Tv>[tTv]),
    );
    whenListen(
      mockPopularTvBloc,
      Stream<PopularTvState>.empty(),
      initialState: PopularTvLoaded(<Tv>[tTv]),
    );
    whenListen(
      mockTopRatedTvBloc,
      Stream<TopRatedTvState>.empty(),
      initialState: TopRatedTvLoaded(<Tv>[tTv]),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<NowPlayingTvBloc>.value(value: mockNowPlayingTvBloc),
          BlocProvider<PopularTvBloc>.value(value: mockPopularTvBloc),
          BlocProvider<TopRatedTvBloc>.value(value: mockTopRatedTvBloc),
        ],
        child: MaterialApp(
          routes: {
            '/': (context) => HomeTvPage(),
            '/detail-tv': (context) =>
                const Scaffold(body: Text('Tv Detail Page')),
            '/search-tv': (context) =>
                const Scaffold(body: Text('Tv Search Page')),
            '/now-playing-tv': (context) =>
                const Scaffold(body: Text('Now Playing Tv Page')),
            '/popular-tv': (context) =>
                const Scaffold(body: Text('Popular Tv Page')),
            '/top-rated-tv': (context) =>
                const Scaffold(body: Text('Top Rated Tv Page')),
            '/watchlist-movie': (context) =>
                const Scaffold(body: Text('Watchlist Movie Page')),
            '/watchlist-tv': (context) =>
                const Scaffold(body: Text('Watchlist Tv Page')),
            '/about': (context) => const Scaffold(body: Text('About Page')),
            '/home': (context) => const Scaffold(body: Text('Movies Home Page')),
          },
        ),
      ),
    );
    await tester.pump();

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
    whenListen(
      mockNowPlayingTvBloc,
      Stream<NowPlayingTvState>.empty(),
      initialState: const NowPlayingTvLoaded(<Tv>[]),
    );
    whenListen(
      mockPopularTvBloc,
      Stream<PopularTvState>.empty(),
      initialState: const PopularTvLoaded(<Tv>[]),
    );
    whenListen(
      mockTopRatedTvBloc,
      Stream<TopRatedTvState>.empty(),
      initialState: const TopRatedTvLoaded(<Tv>[]),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<NowPlayingTvBloc>.value(value: mockNowPlayingTvBloc),
          BlocProvider<PopularTvBloc>.value(value: mockPopularTvBloc),
          BlocProvider<TopRatedTvBloc>.value(value: mockTopRatedTvBloc),
        ],
        child: MaterialApp(
          routes: {
            '/': (context) => HomeTvPage(),
            '/now-playing-tv': (context) =>
                const Scaffold(body: Text('Now Playing Tv Page')),
            '/popular-tv': (context) =>
                const Scaffold(body: Text('Popular Tv Page')),
            '/top-rated-tv': (context) =>
                const Scaffold(body: Text('Top Rated Tv Page')),
            '/search-tv': (context) =>
                const Scaffold(body: Text('Tv Search Page')),
          },
        ),
      ),
    );
    await tester.pump();

    // Tap Search
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    expect(find.text('Tv Search Page'), findsOneWidget);

    // Pop search
    Navigator.pop(tester.element(find.text('Tv Search Page')));
    await tester.pumpAndSettle();

    // Tap Now Playing See More
    final seeMores = find.text('See More');
    expect(seeMores, findsNWidgets(3));
    await tester.tap(seeMores.at(0));
    await tester.pumpAndSettle();
    expect(find.text('Now Playing Tv Page'), findsOneWidget);

    Navigator.pop(tester.element(find.text('Now Playing Tv Page')));
    await tester.pumpAndSettle();

    // Tap Popular See More
    await tester.tap(find.text('See More').at(1));
    await tester.pumpAndSettle();
    expect(find.text('Popular Tv Page'), findsOneWidget);

    Navigator.pop(tester.element(find.text('Popular Tv Page')));
    await tester.pumpAndSettle();

    // Tap Top Rated See More
    await tester.tap(find.text('See More').at(2));
    await tester.pumpAndSettle();
    expect(find.text('Top Rated Tv Page'), findsOneWidget);
  });

  testWidgets('Drawer items should be clickable', (WidgetTester tester) async {
    whenListen(
      mockNowPlayingTvBloc,
      Stream<NowPlayingTvState>.empty(),
      initialState: const NowPlayingTvLoaded(<Tv>[]),
    );
    whenListen(
      mockPopularTvBloc,
      Stream<PopularTvState>.empty(),
      initialState: const PopularTvLoaded(<Tv>[]),
    );
    whenListen(
      mockTopRatedTvBloc,
      Stream<TopRatedTvState>.empty(),
      initialState: const TopRatedTvLoaded(<Tv>[]),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<NowPlayingTvBloc>.value(value: mockNowPlayingTvBloc),
          BlocProvider<PopularTvBloc>.value(value: mockPopularTvBloc),
          BlocProvider<TopRatedTvBloc>.value(value: mockTopRatedTvBloc),
        ],
        child: MaterialApp(
          routes: {
            '/': (context) => HomeTvPage(),
            '/home': (context) => const Scaffold(body: Text('Movies Home Page')),
            '/watchlist-movie': (context) =>
                const Scaffold(body: Text('Watchlist Movie Page')),
            '/watchlist-tv': (context) =>
                const Scaffold(body: Text('Watchlist Tv Page')),
            '/about': (context) => const Scaffold(body: Text('About Page')),
          },
        ),
      ),
    );
    await tester.pump();

    // Open drawer
    var scaffoldState =
        tester.firstState<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV Series'), findsOneWidget);
    expect(find.text('Movie Watchlist'), findsOneWidget);
    expect(find.text('TV Series Watchlist'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);

    // Tap Movie Watchlist
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

    // Open drawer & tap TV Series (pop drawer)
    scaffoldState = tester.firstState<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.text('TV Series'));
    await tester.pumpAndSettle();

    // Open drawer & tap Movies
    scaffoldState = tester.firstState<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Movies'));
    await tester.pumpAndSettle();
    expect(find.text('Movies Home Page'), findsOneWidget);
  });
}
