import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  final String? backdropPath;
  final List<Genre> genres;
  final int id;
  final String name;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final String overview;
  final String posterPath;
  final String? firstAirDate;
  final double voteAverage;
  final int voteCount;
  final List<Season> seasons;

  TvDetail({
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.name,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.overview,
    required this.posterPath,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
    required this.seasons,
  });

  @override
  List<Object?> get props => [
        backdropPath,
        genres,
        id,
        name,
        numberOfEpisodes,
        numberOfSeasons,
        overview,
        posterPath,
        firstAirDate,
        voteAverage,
        voteCount,
        seasons,
      ];
}
