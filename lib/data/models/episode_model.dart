import 'package:equatable/equatable.dart';

import '../../domain/entities/episode.dart';

class EpisodeModel extends Equatable {
  final int id;
  final String name;
  final String overview;
  final int episodeNumber;
  final int seasonNumber;
  final String? stillPath;
  final double voteAverage;

  EpisodeModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.episodeNumber,
    required this.seasonNumber,
    required this.stillPath,
    required this.voteAverage,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) => EpisodeModel(
        id: json['id'],
        name: json['name'] ?? '',
        overview: json['overview'] ?? '',
        episodeNumber: json['episode_number'] ?? 0,
        seasonNumber: json['season_number'] ?? 0,
        stillPath: json['still_path'],
        voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'overview': overview,
        'episode_number': episodeNumber,
        'season_number': seasonNumber,
        'still_path': stillPath,
        'vote_average': voteAverage,
      };

  Episode toEntity() => Episode(
        id: id,
        name: name,
        overview: overview,
        episodeNumber: episodeNumber,
        seasonNumber: seasonNumber,
        stillPath: stillPath,
        voteAverage: voteAverage,
      );

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
