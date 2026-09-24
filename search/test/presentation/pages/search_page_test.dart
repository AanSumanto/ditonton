import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:search/presentation/bloc/movie_search_bloc.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieSearchBloc
    extends MockBloc<MovieSearchEvent, MovieSearchState>
    implements MovieSearchBloc {}

void main() {
  late MockMovieSearchBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieSearchBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieSearchBloc>.value(
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
      Stream.fromIterable([SearchLoading()]),
      initialState: SearchLoading(),
    );

    final progressFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView and items when data is loaded',
      (WidgetTester tester) async {
    whenListen(
      mockBloc,
      Stream.fromIterable([SearchLoaded(<Movie>[testMovie])]),
      initialState: SearchLoaded(<Movie>[testMovie]),
    );

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    expect(listViewFinder, findsOneWidget);
    expect(find.byType(MovieCard), findsOneWidget);
  });

  testWidgets('Page should trigger search when text submitted',
      (WidgetTester tester) async {
    whenListen(
      mockBloc,
      Stream.fromIterable([SearchEmpty()]),
      initialState: SearchEmpty(),
    );

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    final textField = find.byType(TextField);
    await tester.enterText(textField, 'spiderman');
    await tester.testTextInput.receiveAction(TextInputAction.search);

    expect(textField, findsOneWidget);
  });

  testWidgets(
      'Page should display empty container when state is not loading/loaded',
      (WidgetTester tester) async {
    whenListen(
      mockBloc,
      Stream.fromIterable([SearchEmpty()]),
      initialState: SearchEmpty(),
    );

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    expect(find.byType(TextField), findsOneWidget);
  });
}
