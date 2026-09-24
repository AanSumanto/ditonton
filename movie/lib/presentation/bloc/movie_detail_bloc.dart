import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';

// Events
abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchMovieDetail extends MovieDetailEvent {
  final int id;

  const FetchMovieDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class AddMovieWatchlist extends MovieDetailEvent {
  final MovieDetail movie;

  const AddMovieWatchlist(this.movie);

  @override
  List<Object?> get props => [movie];
}

class RemoveMovieWatchlist extends MovieDetailEvent {
  final MovieDetail movie;

  const RemoveMovieWatchlist(this.movie);

  @override
  List<Object?> get props => [movie];
}

class LoadMovieWatchlistStatus extends MovieDetailEvent {
  final int id;

  const LoadMovieWatchlistStatus(this.id);

  @override
  List<Object?> get props => [id];
}


// State
class MovieDetailState extends Equatable {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final MovieDetail? movieDetail;
  final RequestState movieDetailState;
  final List<Movie> movieRecommendations;
  final RequestState movieRecommendationsState;
  final bool isAddedToWatchlist;
  final String watchlistMessage;
  final String message;

  const MovieDetailState({
    this.movieDetail,
    this.movieDetailState = RequestState.Empty,
    this.movieRecommendations = const [],
    this.movieRecommendationsState = RequestState.Empty,
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
    this.message = '',
  });

  factory MovieDetailState.initial() {
    return const MovieDetailState();
  }

  MovieDetailState copyWith({
    MovieDetail? movieDetail,
    RequestState? movieDetailState,
    List<Movie>? movieRecommendations,
    RequestState? movieRecommendationsState,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
    String? message,
  }) {
    return MovieDetailState(
      movieDetail: movieDetail ?? this.movieDetail,
      movieDetailState: movieDetailState ?? this.movieDetailState,
      movieRecommendations:
          movieRecommendations ?? this.movieRecommendations,
      movieRecommendationsState:
          movieRecommendationsState ?? this.movieRecommendationsState,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        movieDetail,
        movieDetailState,
        movieRecommendations,
        movieRecommendationsState,
        isAddedToWatchlist,
        watchlistMessage,
        message,
      ];
}

// BLoC
class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieDetailState.initial()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(state.copyWith(movieDetailState: RequestState.Loading));

      final detailResult = await getMovieDetail.execute(event.id);
      final recommendationResult =
          await getMovieRecommendations.execute(event.id);

      detailResult.fold(
        (failure) {
          emit(state.copyWith(
            movieDetailState: RequestState.Error,
            message: failure.message,
          ));
        },
        (movie) {
          emit(state.copyWith(
            movieDetail: movie,
            movieDetailState: RequestState.Loaded,
            movieRecommendationsState: RequestState.Loading,
          ));

          recommendationResult.fold(
            (failure) {
              emit(state.copyWith(
                movieRecommendationsState: RequestState.Error,
                message: failure.message,
              ));
            },
            (movies) {
              emit(state.copyWith(
                movieRecommendations: movies,
                movieRecommendationsState: RequestState.Loaded,
              ));
            },
          );
        },
      );
    });

    on<AddMovieWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.movie);
      final status = await getWatchListStatus.execute(event.movie.id);

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

    on<RemoveMovieWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.movie);
      final status = await getWatchListStatus.execute(event.movie.id);

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


    on<LoadMovieWatchlistStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: result));
    });
  }
}

