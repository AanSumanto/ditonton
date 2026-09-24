import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieSearchNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockMovieSearchNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MovieSearchNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loading);

    final progressFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView and items when data is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.searchResult).thenReturn(<Movie>[testMovie]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    expect(listViewFinder, findsOneWidget);
    expect(find.byType(MovieCard), findsOneWidget);
  });

  testWidgets('Page should trigger search when text submitted',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Empty);

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    final textField = find.byType(TextField);
    await tester.enterText(textField, 'spiderman');
    await tester.testTextInput.receiveAction(TextInputAction.search);

    verify(mockNotifier.fetchMovieSearch('spiderman'));
  });

  testWidgets('Page should display empty container when state is not loading/loaded',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Empty);

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    expect(find.byType(TextField), findsOneWidget);
  });
}
