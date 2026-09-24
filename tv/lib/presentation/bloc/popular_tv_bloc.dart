import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';

// Events
abstract class PopularTvEvent extends Equatable {
  const PopularTvEvent();

  @override
  List<Object?> get props => [];
}

class FetchPopularTv extends PopularTvEvent {}

// States
abstract class PopularTvState extends Equatable {
  const PopularTvState();

  @override
  List<Object?> get props => [];
}

class PopularTvEmpty extends PopularTvState {}

class PopularTvLoading extends PopularTvState {}

class PopularTvLoaded extends PopularTvState {
  final List<Tv> tvs;

  const PopularTvLoaded(this.tvs);

  @override
  List<Object?> get props => [tvs];
}

class PopularTvError extends PopularTvState {
  final String message;

  const PopularTvError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTv getPopularTv;

  PopularTvBloc({required this.getPopularTv}) : super(PopularTvEmpty()) {
    on<FetchPopularTv>((event, emit) async {
      emit(PopularTvLoading());
      final result = await getPopularTv.execute();
      result.fold(
        (failure) => emit(PopularTvError(failure.message)),
        (tvs) => emit(PopularTvLoaded(tvs)),
      );
    });
  }
}
