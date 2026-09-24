import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:search/domain/usecases/search_movies.dart';

// Debounce helper
EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

// Events
abstract class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();

  @override
  List<Object?> get props => [];
}

class OnQueryChanged extends MovieSearchEvent {
  final String query;

  const OnQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

// States
abstract class MovieSearchState extends Equatable {
  const MovieSearchState();

  @override
  List<Object?> get props => [];
}

class SearchEmpty extends MovieSearchState {}

class SearchLoading extends MovieSearchState {}

class SearchLoaded extends MovieSearchState {
  final List<Movie> result;

  const SearchLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class SearchError extends MovieSearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchBloc({required this.searchMovies}) : super(SearchEmpty()) {
    on<OnQueryChanged>(
      (event, emit) async {
        final query = event.query;
        if (query.isEmpty) {
          emit(SearchEmpty());
          return;
        }

        emit(SearchLoading());
        final result = await searchMovies.execute(query);

        result.fold(
          (failure) => emit(SearchError(failure.message)),
          (data) => emit(SearchLoaded(data)),
        );
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }
}
