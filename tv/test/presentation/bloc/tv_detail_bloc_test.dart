import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvDetailBloc bloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetTvSeasonDetail mockGetTvSeasonDetail;
  late MockGetWatchlistTvStatus mockGetWatchlistTvStatus;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetTvSeasonDetail = MockGetTvSeasonDetail();
    mockGetWatchlistTvStatus = MockGetWatchlistTvStatus();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    bloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getTvSeasonDetail: mockGetTvSeasonDetail,
      getWatchListStatus: mockGetWatchlistTvStatus,
      saveWatchlist: mockSaveWatchlistTv,
      removeWatchlist: mockRemoveWatchlistTv,
    );
  });

  const tId = 1;
  const tSeasonNumber = 1;
  final tTvs = <Tv>[testTv];

  test('initial state should be initial', () {
    expect(bloc.state, TvDetailState.initial());
  });

  group('FetchTvDetail', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, Loaded, RecommendationsLoaded] when data is gotten successfully',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvDetail));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvs));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        TvDetailState.initial().copyWith(tvDetailState: RequestState.Loading),
        TvDetailState.initial().copyWith(
          tvDetail: testTvDetail,
          tvDetailState: RequestState.Loaded,
          tvRecommendationsState: RequestState.Loading,
        ),
        TvDetailState.initial().copyWith(
          tvDetail: testTvDetail,
          tvDetailState: RequestState.Loaded,
          tvRecommendations: tTvs,
          tvRecommendationsState: RequestState.Loaded,
        ),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, Error] when get tv detail is unsuccessful',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvs));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        TvDetailState.initial().copyWith(tvDetailState: RequestState.Loading),
        TvDetailState.initial().copyWith(
          tvDetailState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, Loaded, RecommendationsError] when recommendations fail',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvDetail));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        TvDetailState.initial().copyWith(tvDetailState: RequestState.Loading),
        TvDetailState.initial().copyWith(
          tvDetail: testTvDetail,
          tvDetailState: RequestState.Loaded,
          tvRecommendationsState: RequestState.Loading,
        ),
        TvDetailState.initial().copyWith(
          tvDetail: testTvDetail,
          tvDetailState: RequestState.Loaded,
          tvRecommendationsState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
      },
    );
  });

  group('FetchTvSeasonDetail', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, Loaded] when season detail is gotten successfully',
      build: () {
        when(mockGetTvSeasonDetail.execute(tId, tSeasonNumber))
            .thenAnswer((_) async => Right(testSeasonDetail));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeasonDetail(tId, tSeasonNumber)),
      expect: () => [
        TvDetailState.initial().copyWith(
          selectedSeasonNumber: tSeasonNumber,
          seasonState: RequestState.Loading,
        ),
        TvDetailState.initial().copyWith(
          selectedSeasonNumber: tSeasonNumber,
          seasonDetail: testSeasonDetail,
          seasonState: RequestState.Loaded,
        ),
      ],
      verify: (bloc) {
        verify(mockGetTvSeasonDetail.execute(tId, tSeasonNumber));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, Error] when season detail fails',
      build: () {
        when(mockGetTvSeasonDetail.execute(tId, tSeasonNumber))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeasonDetail(tId, tSeasonNumber)),
      expect: () => [
        TvDetailState.initial().copyWith(
          selectedSeasonNumber: tSeasonNumber,
          seasonState: RequestState.Loading,
        ),
        TvDetailState.initial().copyWith(
          selectedSeasonNumber: tSeasonNumber,
          seasonState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetTvSeasonDetail.execute(tId, tSeasonNumber));
      },
    );
  });

  group('Watchlist Operations', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should update watchlist message and status when add watchlist success',
      build: () {
        when(mockSaveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchlistTvStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(AddTvWatchlist(testTvDetail)),
      expect: () => [
        TvDetailState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTv.execute(testTvDetail));
        verify(mockGetWatchlistTvStatus.execute(testTvDetail.id));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should update watchlist message when add watchlist failed',
      build: () {
        when(mockSaveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        when(mockGetWatchlistTvStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(AddTvWatchlist(testTvDetail)),
      expect: () => [
        TvDetailState.initial().copyWith(
          watchlistMessage: 'Database Failure',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTv.execute(testTvDetail));
        verify(mockGetWatchlistTvStatus.execute(testTvDetail.id));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should update watchlist message and status when remove watchlist success',
      build: () {
        when(mockRemoveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchlistTvStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveTvWatchlist(testTvDetail)),
      expect: () => [
        TvDetailState.initial().copyWith(
          watchlistMessage: 'Removed from Watchlist',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTv.execute(testTvDetail));
        verify(mockGetWatchlistTvStatus.execute(testTvDetail.id));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should update watchlist message when remove watchlist failed',
      build: () {
        when(mockRemoveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        when(mockGetWatchlistTvStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveTvWatchlist(testTvDetail)),
      expect: () => [
        TvDetailState.initial().copyWith(
          watchlistMessage: 'Database Failure',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTv.execute(testTvDetail));
        verify(mockGetWatchlistTvStatus.execute(testTvDetail.id));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should get watchlist status',
      build: () {
        when(mockGetWatchlistTvStatus.execute(tId))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadTvWatchlistStatus(tId)),
      expect: () => [
        TvDetailState.initial().copyWith(isAddedToWatchlist: true),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvStatus.execute(tId));
      },
    );
  });
}
