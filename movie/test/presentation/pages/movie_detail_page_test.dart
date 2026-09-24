import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc
    extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

void main() {
  late MockMovieDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    final state = MovieDetailState.initial().copyWith(
      movieDetailState: RequestState.Loaded,
      movieDetail: testMovieDetail,
      movieRecommendationsState: RequestState.Loaded,
      movieRecommendations: <Movie>[],
      isAddedToWatchlist: false,
    );

    whenListen(
      mockBloc,
      Stream<MovieDetailState>.empty(),
      initialState: state,
    );

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    final state = MovieDetailState.initial().copyWith(
      movieDetailState: RequestState.Loaded,
      movieDetail: testMovieDetail,
      movieRecommendationsState: RequestState.Loaded,
      movieRecommendations: <Movie>[],
      isAddedToWatchlist: true,
    );

    whenListen(
      mockBloc,
      Stream<MovieDetailState>.empty(),
      initialState: state,
    );

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    final state = MovieDetailState.initial().copyWith(
      movieDetailState: RequestState.Loaded,
      movieDetail: testMovieDetail,
      movieRecommendationsState: RequestState.Loaded,
      movieRecommendations: <Movie>[],
      isAddedToWatchlist: false,
    );

    whenListen(
      mockBloc,
      Stream<MovieDetailState>.fromIterable([
        state.copyWith(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ]),
      initialState: state,
    );

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    final state = MovieDetailState.initial().copyWith(
      movieDetailState: RequestState.Loaded,
      movieDetail: testMovieDetail,
      movieRecommendationsState: RequestState.Loaded,
      movieRecommendations: <Movie>[],
      isAddedToWatchlist: false,
    );

    whenListen(
      mockBloc,
      Stream<MovieDetailState>.fromIterable([
        state.copyWith(
          watchlistMessage: 'Failed',
          isAddedToWatchlist: false,
        ),
      ]),
      initialState: state,
    );

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton, warnIfMissed: false);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('Page should display recommendation loading and error',
      (WidgetTester tester) async {
    final stateLoading = MovieDetailState.initial().copyWith(
      movieDetailState: RequestState.Loaded,
      movieDetail: testMovieDetail,
      movieRecommendationsState: RequestState.Loading,
      movieRecommendations: <Movie>[],
      isAddedToWatchlist: false,
    );
    final stateError = MovieDetailState.initial().copyWith(
      movieDetailState: RequestState.Loaded,
      movieDetail: testMovieDetail,
      movieRecommendationsState: RequestState.Error,
      message: 'Error Rec',
      isAddedToWatchlist: false,
    );

    whenListen(
      mockBloc,
      Stream<MovieDetailState>.fromIterable([stateError]),
      initialState: stateLoading,
    );

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    await tester.pump();
    expect(find.text('Error Rec'), findsOneWidget);
  });

  testWidgets('Page should display recommendations and back button tap',
      (WidgetTester tester) async {
    final state = MovieDetailState.initial().copyWith(
      movieDetailState: RequestState.Loaded,
      movieDetail: testMovieDetail,
      movieRecommendationsState: RequestState.Loaded,
      movieRecommendations: <Movie>[testMovie],
      isAddedToWatchlist: false,
    );

    whenListen(
      mockBloc,
      Stream<MovieDetailState>.empty(),
      initialState: state,
    );

    await tester.pumpWidget(
      BlocProvider<MovieDetailBloc>.value(
        value: mockBloc,
        child: MaterialApp(
          routes: {
            '/': (context) => const MovieDetailPage(id: 1),
          },
        ),
      ),
    );

    expect(find.byType(ListView), findsWidgets);

    // Tap back button
    final backButton = find.byIcon(Icons.arrow_back);
    expect(backButton, findsOneWidget);
    await tester.tap(backButton);
  });
}
