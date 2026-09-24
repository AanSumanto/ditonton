import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:search/domain/usecases/search_tv.dart';

// Debounce helper
EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

// Events
abstract class TvSearchEvent extends Equatable {
  const TvSearchEvent();

  @override
  List<Object?> get props => [];
}

class OnTvQueryChanged extends TvSearchEvent {
  final String query;

  const OnTvQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

// States
abstract class TvSearchState extends Equatable {
  const TvSearchState();

  @override
  List<Object?> get props => [];
}

class TvSearchEmpty extends TvSearchState {}

class TvSearchLoading extends TvSearchState {}

class TvSearchLoaded extends TvSearchState {
  final List<Tv> result;

  const TvSearchLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class TvSearchError extends TvSearchState {
  final String message;

  const TvSearchError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTv searchTv;

  TvSearchBloc({required this.searchTv}) : super(TvSearchEmpty()) {
    on<OnTvQueryChanged>(
      (event, emit) async {
        final query = event.query;
        if (query.isEmpty) {
          emit(TvSearchEmpty());
          return;
        }

        emit(TvSearchLoading());
        final result = await searchTv.execute(query);

        result.fold(
          (failure) => emit(TvSearchError(failure.message)),
          (data) => emit(TvSearchLoaded(data)),
        );
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }
}
