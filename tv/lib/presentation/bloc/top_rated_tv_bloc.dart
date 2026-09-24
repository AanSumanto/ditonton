import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';

// Events
abstract class TopRatedTvEvent extends Equatable {
  const TopRatedTvEvent();

  @override
  List<Object?> get props => [];
}

class FetchTopRatedTv extends TopRatedTvEvent {}

// States
abstract class TopRatedTvState extends Equatable {
  const TopRatedTvState();

  @override
  List<Object?> get props => [];
}

class TopRatedTvEmpty extends TopRatedTvState {}

class TopRatedTvLoading extends TopRatedTvState {}

class TopRatedTvLoaded extends TopRatedTvState {
  final List<Tv> tvs;

  const TopRatedTvLoaded(this.tvs);

  @override
  List<Object?> get props => [tvs];
}

class TopRatedTvError extends TopRatedTvState {
  final String message;

  const TopRatedTvError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTv getTopRatedTv;

  TopRatedTvBloc({required this.getTopRatedTv}) : super(TopRatedTvEmpty()) {
    on<FetchTopRatedTv>((event, emit) async {
      emit(TopRatedTvLoading());
      final result = await getTopRatedTv.execute();
      result.fold(
        (failure) => emit(TopRatedTvError(failure.message)),
        (tvs) => emit(TopRatedTvLoaded(tvs)),
      );
    });
  }
}
