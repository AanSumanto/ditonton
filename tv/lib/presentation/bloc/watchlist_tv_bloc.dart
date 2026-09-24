import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_watchlist_tv.dart';

// Events
abstract class WatchlistTvEvent extends Equatable {
  const WatchlistTvEvent();

  @override
  List<Object?> get props => [];
}

class FetchWatchlistTv extends WatchlistTvEvent {}

// States
abstract class WatchlistTvState extends Equatable {
  const WatchlistTvState();

  @override
  List<Object?> get props => [];
}

class WatchlistTvEmpty extends WatchlistTvState {}

class WatchlistTvLoading extends WatchlistTvState {}

class WatchlistTvLoaded extends WatchlistTvState {
  final List<Tv> tvs;

  const WatchlistTvLoaded(this.tvs);

  @override
  List<Object?> get props => [tvs];
}

class WatchlistTvError extends WatchlistTvState {
  final String message;

  const WatchlistTvError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTv getWatchlistTv;

  WatchlistTvBloc({required this.getWatchlistTv})
      : super(WatchlistTvEmpty()) {
    on<FetchWatchlistTv>((event, emit) async {
      emit(WatchlistTvLoading());
      final result = await getWatchlistTv.execute();
      result.fold(
        (failure) => emit(WatchlistTvError(failure.message)),
        (tvs) => emit(WatchlistTvLoaded(tvs)),
      );
    });
  }
}
