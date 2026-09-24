import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/tv_search_page.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvSearchNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvSearchNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvSearchNotifier>.value(
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

    await tester.pumpWidget(_makeTestableWidget(TvSearchPage()));

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView and items when data is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.searchResult).thenReturn(<Tv>[testTv]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TvSearchPage()));

    expect(listViewFinder, findsOneWidget);
    expect(find.byType(TvCard), findsOneWidget);
  });

  testWidgets('Page should trigger search when text submitted',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Empty);

    await tester.pumpWidget(_makeTestableWidget(TvSearchPage()));

    final textField = find.byType(TextField);
    await tester.enterText(textField, 'game of thrones');
    await tester.testTextInput.receiveAction(TextInputAction.search);

    verify(mockNotifier.fetchTvSearch('game of thrones'));
  });

  testWidgets(
      'Page should display empty container when state is not loading/loaded',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Empty);

    await tester.pumpWidget(_makeTestableWidget(TvSearchPage()));

    expect(find.byType(TextField), findsOneWidget);
  });
}
