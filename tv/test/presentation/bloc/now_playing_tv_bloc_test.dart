import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';

import 'package:tv/presentation/bloc/now_playing_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late NowPlayingTvBloc bloc;
  late MockGetNowPlayingTv mockGetNowPlayingTv;

  setUp(() {
    mockGetNowPlayingTv = MockGetNowPlayingTv();
    bloc = NowPlayingTvBloc(getNowPlayingTv: mockGetNowPlayingTv);
  });

  test('initial state should be empty', () {
    expect(bloc.state, NowPlayingTvEmpty());
  });

  blocTest<NowPlayingTvBloc, NowPlayingTvState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Right(testTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTv()),
    expect: () => [
      NowPlayingTvLoading(),
      NowPlayingTvLoaded(testTvList),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingTv.execute());
    },
  );

  blocTest<NowPlayingTvBloc, NowPlayingTvState>(
    'should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTv()),
    expect: () => [
      NowPlayingTvLoading(),
      const NowPlayingTvError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingTv.execute());
    },
  );
}
