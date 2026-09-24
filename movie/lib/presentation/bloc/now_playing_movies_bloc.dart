import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';

// Events
abstract class NowPlayingMoviesEvent extends Equatable {
  const NowPlayingMoviesEvent();

  @override
  List<Object?> get props => [];
}

class FetchNowPlayingMovies extends NowPlayingMoviesEvent {}

// States
abstract class NowPlayingMoviesState extends Equatable {
  const NowPlayingMoviesState();

  @override
  List<Object?> get props => [];
}

class NowPlayingMoviesEmpty extends NowPlayingMoviesState {}

class NowPlayingMoviesLoading extends NowPlayingMoviesState {}

class NowPlayingMoviesLoaded extends NowPlayingMoviesState {
  final List<Movie> movies;

  const NowPlayingMoviesLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class NowPlayingMoviesError extends NowPlayingMoviesState {
  final String message;

  const NowPlayingMoviesError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class NowPlayingMoviesBloc
    extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMoviesBloc({required this.getNowPlayingMovies})
      : super(NowPlayingMoviesEmpty()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(NowPlayingMoviesLoading());
      final result = await getNowPlayingMovies.execute();
      result.fold(
        (failure) => emit(NowPlayingMoviesError(failure.message)),
        (movies) => emit(NowPlayingMoviesLoaded(movies)),
      );
    });
  }
}
