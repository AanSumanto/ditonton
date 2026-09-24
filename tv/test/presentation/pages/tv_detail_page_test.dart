import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../dummy_data/dummy_objects.dart';

class MockTvDetailBloc
    extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

void main() {
  late MockTvDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockTvDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
      (WidgetTester tester) async {
    final state = TvDetailState.initial().copyWith(
      tvDetailState: RequestState.Loaded,
      tvDetail: testTvDetail,
      tvRecommendationsState: RequestState.Loaded,
      tvRecommendations: <Tv>[],
      isAddedToWatchlist: false,
      seasonState: RequestState.Loaded,
      seasonDetail: testSeasonDetail,
    );

    whenListen(
      mockBloc,
      Stream<TvDetailState>.empty(),
      initialState: state,
    );

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv is added to watchlist',
      (WidgetTester tester) async {
    final state = TvDetailState.initial().copyWith(
      tvDetailState: RequestState.Loaded,
      tvDetail: testTvDetail,
      tvRecommendationsState: RequestState.Loaded,
      tvRecommendations: <Tv>[],
      isAddedToWatchlist: true,
      seasonState: RequestState.Loaded,
      seasonDetail: testSeasonDetail,
    );

    whenListen(
      mockBloc,
      Stream<TvDetailState>.empty(),
      initialState: state,
    );

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    final state = TvDetailState.initial().copyWith(
      tvDetailState: RequestState.Loaded,
      tvDetail: testTvDetail,
      tvRecommendationsState: RequestState.Loaded,
      tvRecommendations: <Tv>[],
      isAddedToWatchlist: false,
      seasonState: RequestState.Loaded,
      seasonDetail: testSeasonDetail,
    );

    whenListen(
      mockBloc,
      Stream<TvDetailState>.fromIterable([
        state.copyWith(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ]),
      initialState: state,
    );

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton, warnIfMissed: false);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    final state = TvDetailState.initial().copyWith(
      tvDetailState: RequestState.Loaded,
      tvDetail: testTvDetail,
      tvRecommendationsState: RequestState.Loaded,
      tvRecommendations: <Tv>[],
      isAddedToWatchlist: false,
      seasonState: RequestState.Loaded,
      seasonDetail: testSeasonDetail,
    );

    whenListen(
      mockBloc,
      Stream<TvDetailState>.fromIterable([
        state.copyWith(
          watchlistMessage: 'Failed',
          isAddedToWatchlist: false,
        ),
      ]),
      initialState: state,
    );

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton, warnIfMissed: false);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    final state = TvDetailState.initial().copyWith(
      tvDetailState: RequestState.Loading,
    );

    whenListen(
      mockBloc,
      Stream<TvDetailState>.empty(),
      initialState: state,
    );

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display error message when error',
      (WidgetTester tester) async {
    final state = TvDetailState.initial().copyWith(
      tvDetailState: RequestState.Error,
      message: 'Error message',
    );

    whenListen(
      mockBloc,
      Stream<TvDetailState>.empty(),
      initialState: state,
    );

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Page should display recommendation loading and error',
      (WidgetTester tester) async {
    final stateLoading = TvDetailState.initial().copyWith(
      tvDetailState: RequestState.Loaded,
      tvDetail: testTvDetail,
      tvRecommendationsState: RequestState.Loading,
      tvRecommendations: <Tv>[],
      isAddedToWatchlist: false,
      seasonState: RequestState.Loaded,
      seasonDetail: testSeasonDetail,
    );
    final stateError = TvDetailState.initial().copyWith(
      tvDetailState: RequestState.Loaded,
      tvDetail: testTvDetail,
      tvRecommendationsState: RequestState.Error,
      message: 'Error Rec',
      isAddedToWatchlist: false,
      seasonState: RequestState.Loaded,
      seasonDetail: testSeasonDetail,
    );

    whenListen(
      mockBloc,
      Stream<TvDetailState>.fromIterable([stateError]),
      initialState: stateLoading,
    );

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    await tester.pump();
    expect(find.text('Error Rec'), findsOneWidget);
  });

  testWidgets('Page should display recommendations and navigate on tap',
      (WidgetTester tester) async {
    final state = TvDetailState.initial().copyWith(
      tvDetailState: RequestState.Loaded,
      tvDetail: testTvDetail,
      tvRecommendationsState: RequestState.Loaded,
      tvRecommendations: <Tv>[testTv],
      isAddedToWatchlist: false,
      seasonState: RequestState.Loaded,
      seasonDetail: testSeasonDetail,
    );

    whenListen(
      mockBloc,
      Stream<TvDetailState>.empty(),
      initialState: state,
    );

    await tester.pumpWidget(
      BlocProvider<TvDetailBloc>.value(
        value: mockBloc,
        child: MaterialApp(
          routes: {
            '/': (context) => const TvDetailPage(id: 1),
            '/tv-detail': (context) =>
                const Scaffold(body: Text('New Tv Detail')),
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

  testWidgets('Page should display season list and episodes when loaded',
      (WidgetTester tester) async {
    final state = TvDetailState.initial().copyWith(
      tvDetailState: RequestState.Loaded,
      tvDetail: testTvDetail,
      tvRecommendationsState: RequestState.Loaded,
      tvRecommendations: <Tv>[],
      isAddedToWatchlist: false,
      seasonState: RequestState.Loaded,
      seasonDetail: testSeasonDetail,
      selectedSeasonNumber: 1,
    );

    whenListen(
      mockBloc,
      Stream<TvDetailState>.empty(),
      initialState: state,
    );

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(find.text('Seasons'), findsOneWidget);
    expect(find.text('Episodes'), findsOneWidget);
    expect(find.text('E1. Episode 1'), findsOneWidget);

    final seasonCard = find.byKey(const Key('season_1'));
    expect(seasonCard, findsOneWidget);
    await tester.tap(seasonCard, warnIfMissed: false);
    await tester.pump();
  });

  testWidgets('Page should display season error when season fails',
      (WidgetTester tester) async {
    final state = TvDetailState.initial().copyWith(
      tvDetailState: RequestState.Loaded,
      tvDetail: testTvDetail,
      tvRecommendationsState: RequestState.Loaded,
      tvRecommendations: <Tv>[],
      isAddedToWatchlist: false,
      seasonState: RequestState.Error,
      message: 'Failed to load season',
    );

    whenListen(
      mockBloc,
      Stream<TvDetailState>.empty(),
      initialState: state,
    );

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(find.text('Failed to load season'), findsOneWidget);
  });
}
