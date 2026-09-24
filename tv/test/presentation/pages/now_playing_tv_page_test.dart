import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:tv/presentation/bloc/now_playing_tv_bloc.dart';
import 'package:tv/presentation/pages/now_playing_tv_page.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class MockNowPlayingTvBloc
    extends MockBloc<NowPlayingTvEvent, NowPlayingTvState>
    implements NowPlayingTvBloc {}

void main() {
  late MockNowPlayingTvBloc mockBloc;

  setUp(() {
    mockBloc = MockNowPlayingTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<NowPlayingTvBloc>.value(
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
      Stream<NowPlayingTvState>.empty(),
      initialState: NowPlayingTvLoading(),
    );

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(NowPlayingTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    whenListen(
      mockBloc,
      Stream<NowPlayingTvState>.empty(),
      initialState: NowPlayingTvLoaded(<Tv>[testTv]),
    );

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(NowPlayingTvPage()));

    expect(listViewFinder, findsOneWidget);
    expect(find.byType(TvCard), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    whenListen(
      mockBloc,
      Stream<NowPlayingTvState>.empty(),
      initialState: const NowPlayingTvError('Error message'),
    );

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(NowPlayingTvPage()));

    expect(textFinder, findsOneWidget);
  });
}
