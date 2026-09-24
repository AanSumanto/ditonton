import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv is added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Failed');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loading);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display error message when error',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Error message');

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Page should display recommendation loading and error',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loading);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    when(mockNotifier.recommendationState).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Error Rec');
    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
    expect(find.text('Error Rec'), findsOneWidget);
  });

  testWidgets('Page should display recommendations and navigate on tap',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[testTv]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(
      ChangeNotifierProvider<TvDetailNotifier>.value(
        value: mockNotifier,
        child: MaterialApp(
          routes: {
            '/': (context) => TvDetailPage(id: 1),
            '/tv-detail': (context) => Scaffold(body: Text('New Tv Detail')),
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
