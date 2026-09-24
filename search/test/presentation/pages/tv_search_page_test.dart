import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:search/presentation/bloc/tv_search_bloc.dart';
import 'package:search/presentation/pages/tv_search_page.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvSearchBloc
    extends MockBloc<TvSearchEvent, TvSearchState>
    implements TvSearchBloc {}

void main() {
  late MockTvSearchBloc mockBloc;

  setUp(() {
    mockBloc = MockTvSearchBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvSearchBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    whenListen(
      mockBloc,
      Stream<TvSearchState>.empty(),
      initialState: TvSearchLoading(),
    );

    final progressFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(TvSearchPage()));

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView and items when data is loaded',
      (WidgetTester tester) async {
    whenListen(
      mockBloc,
      Stream<TvSearchState>.empty(),
      initialState: TvSearchLoaded(<Tv>[testTv]),
    );

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TvSearchPage()));

    expect(listViewFinder, findsOneWidget);
    expect(find.byType(TvCard), findsOneWidget);
  });

  testWidgets('Page should trigger search when text submitted',
      (WidgetTester tester) async {
    whenListen(
      mockBloc,
      Stream<TvSearchState>.empty(),
      initialState: TvSearchEmpty(),
    );

    await tester.pumpWidget(_makeTestableWidget(TvSearchPage()));

    final textField = find.byType(TextField);
    await tester.enterText(textField, 'game of thrones');
    await tester.testTextInput.receiveAction(TextInputAction.search);

    expect(textField, findsOneWidget);
  });

  testWidgets(
      'Page should display empty container when state is not loading/loaded',
      (WidgetTester tester) async {
    whenListen(
      mockBloc,
      Stream<TvSearchState>.empty(),
      initialState: TvSearchEmpty(),
    );

    await tester.pumpWidget(_makeTestableWidget(TvSearchPage()));

    expect(find.byType(TextField), findsOneWidget);
  });
}
