import 'package:equatable/equatable.dart';

class Episode extends Equatable {
  final int id;
  final String name;
  final String overview;
  final int episodeNumber;
  final int seasonNumber;
  final String? stillPath;
  final double voteAverage;

  Episode({
    required this.id,
    required this.name,
    required this.overview,
    required this.episodeNumber,
    required this.seasonNumber,
    required this.stillPath,
    required this.voteAverage,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        episodeNumber,
        seasonNumber,
        stillPath,
        voteAverage,
      ];
}
