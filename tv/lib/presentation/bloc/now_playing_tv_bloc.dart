import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_now_playing_tv.dart';

// Events
abstract class NowPlayingTvEvent extends Equatable {
  const NowPlayingTvEvent();

  @override
  List<Object?> get props => [];
}

class FetchNowPlayingTv extends NowPlayingTvEvent {}

// States
abstract class NowPlayingTvState extends Equatable {
  const NowPlayingTvState();

  @override
  List<Object?> get props => [];
}

class NowPlayingTvEmpty extends NowPlayingTvState {}

class NowPlayingTvLoading extends NowPlayingTvState {}

class NowPlayingTvLoaded extends NowPlayingTvState {
  final List<Tv> tvs;

  const NowPlayingTvLoaded(this.tvs);

  @override
  List<Object?> get props => [tvs];
}

class NowPlayingTvError extends NowPlayingTvState {
  final String message;

  const NowPlayingTvError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class NowPlayingTvBloc extends Bloc<NowPlayingTvEvent, NowPlayingTvState> {
  final GetNowPlayingTv getNowPlayingTv;

  NowPlayingTvBloc({required this.getNowPlayingTv})
      : super(NowPlayingTvEmpty()) {
    on<FetchNowPlayingTv>((event, emit) async {
      emit(NowPlayingTvLoading());
      final result = await getNowPlayingTv.execute();
      result.fold(
        (failure) => emit(NowPlayingTvError(failure.message)),
        (tvs) => emit(NowPlayingTvLoaded(tvs)),
      );
    });
  }
}
