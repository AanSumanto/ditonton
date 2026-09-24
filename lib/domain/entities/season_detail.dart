import 'package:equatable/equatable.dart';

import 'episode.dart';

class SeasonDetail extends Equatable {
  final int id;
  final String name;
  final String overview;
  final int seasonNumber;
  final String? posterPath;
  final List<Episode> episodes;

  SeasonDetail({
    required this.id,
    required this.name,
    required this.overview,
    required this.seasonNumber,
    required this.posterPath,
    required this.episodes,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        seasonNumber,
        posterPath,
        episodes,
      ];
}
