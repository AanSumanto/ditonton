import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/season_detail.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_tv_season_detail.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';

// Events
abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchTvDetail extends TvDetailEvent {
  final int id;

  const FetchTvDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class FetchTvSeasonDetail extends TvDetailEvent {
  final int id;
  final int seasonNumber;

  const FetchTvSeasonDetail(this.id, this.seasonNumber);

  @override
  List<Object?> get props => [id, seasonNumber];
}

class AddTvWatchlist extends TvDetailEvent {
  final TvDetail tv;

  const AddTvWatchlist(this.tv);

  @override
  List<Object?> get props => [tv];
}

class RemoveTvWatchlist extends TvDetailEvent {
  final TvDetail tv;

  const RemoveTvWatchlist(this.tv);

  @override
  List<Object?> get props => [tv];
}

class LoadTvWatchlistStatus extends TvDetailEvent {
  final int id;

  const LoadTvWatchlistStatus(this.id);

  @override
  List<Object?> get props => [id];
}

// State
class TvDetailState extends Equatable {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final TvDetail? tvDetail;
  final RequestState tvDetailState;
  final List<Tv> tvRecommendations;
  final RequestState tvRecommendationsState;
  final SeasonDetail? seasonDetail;
  final RequestState seasonState;
  final int selectedSeasonNumber;
  final bool isAddedToWatchlist;
  final String watchlistMessage;
  final String message;

  const TvDetailState({
    this.tvDetail,
    this.tvDetailState = RequestState.Empty,
    this.tvRecommendations = const [],
    this.tvRecommendationsState = RequestState.Empty,
    this.seasonDetail,
    this.seasonState = RequestState.Empty,
    this.selectedSeasonNumber = 1,
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
    this.message = '',
  });

  factory TvDetailState.initial() {
    return const TvDetailState();
  }

  TvDetailState copyWith({
    TvDetail? tvDetail,
    RequestState? tvDetailState,
    List<Tv>? tvRecommendations,
    RequestState? tvRecommendationsState,
    SeasonDetail? seasonDetail,
    RequestState? seasonState,
    int? selectedSeasonNumber,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
    String? message,
  }) {
    return TvDetailState(
      tvDetail: tvDetail ?? this.tvDetail,
      tvDetailState: tvDetailState ?? this.tvDetailState,
      tvRecommendations: tvRecommendations ?? this.tvRecommendations,
      tvRecommendationsState:
          tvRecommendationsState ?? this.tvRecommendationsState,
      seasonDetail: seasonDetail ?? this.seasonDetail,
      seasonState: seasonState ?? this.seasonState,
      selectedSeasonNumber:
          selectedSeasonNumber ?? this.selectedSeasonNumber,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        tvDetail,
        tvDetailState,
        tvRecommendations,
        tvRecommendationsState,
        seasonDetail,
        seasonState,
        selectedSeasonNumber,
        isAddedToWatchlist,
        watchlistMessage,
        message,
      ];
}

// BLoC
class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetTvSeasonDetail getTvSeasonDetail;
  final GetWatchlistTvStatus getWatchListStatus;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;

  TvDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getTvSeasonDetail,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(TvDetailState.initial()) {
    on<FetchTvDetail>((event, emit) async {
      emit(state.copyWith(tvDetailState: RequestState.Loading));

      final detailResult = await getTvDetail.execute(event.id);
      final recommendationResult =
          await getTvRecommendations.execute(event.id);

      detailResult.fold(
        (failure) {
          emit(state.copyWith(
            tvDetailState: RequestState.Error,
            message: failure.message,
          ));
        },
        (tv) {
          emit(state.copyWith(
            tvDetail: tv,
            tvDetailState: RequestState.Loaded,
            tvRecommendationsState: RequestState.Loading,
          ));

          recommendationResult.fold(
            (failure) {
              emit(state.copyWith(
                tvRecommendationsState: RequestState.Error,
                message: failure.message,
              ));
            },
            (tvs) {
              emit(state.copyWith(
                tvRecommendations: tvs,
                tvRecommendationsState: RequestState.Loaded,
              ));
            },
          );
        },
      );
    });

    on<FetchTvSeasonDetail>((event, emit) async {
      emit(state.copyWith(
        selectedSeasonNumber: event.seasonNumber,
        seasonState: RequestState.Loading,
      ));

      final result =
          await getTvSeasonDetail.execute(event.id, event.seasonNumber);
      result.fold(
        (failure) {
          emit(state.copyWith(
            seasonState: RequestState.Error,
            message: failure.message,
          ));
        },
        (seasonData) {
          emit(state.copyWith(
            seasonDetail: seasonData,
            seasonState: RequestState.Loaded,
          ));
        },
      );
    });

    on<AddTvWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.tv);
      final status = await getWatchListStatus.execute(event.tv.id);

      result.fold(
        (failure) {
          emit(state.copyWith(
            watchlistMessage: failure.message,
            isAddedToWatchlist: status,
          ));
        },
        (successMessage) {
          emit(state.copyWith(
            watchlistMessage: successMessage,
            isAddedToWatchlist: status,
          ));
        },
      );
    });

    on<RemoveTvWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.tv);
      final status = await getWatchListStatus.execute(event.tv.id);

      result.fold(
        (failure) {
          emit(state.copyWith(
            watchlistMessage: failure.message,
            isAddedToWatchlist: status,
          ));
        },
        (successMessage) {
          emit(state.copyWith(
            watchlistMessage: successMessage,
            isAddedToWatchlist: status,
          ));
        },
      );
    });


    on<LoadTvWatchlistStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: result));
    });
  }
}
