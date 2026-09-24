import 'package:equatable/equatable.dart';

import 'package:core/domain/entities/season_detail.dart';
import 'episode_model.dart';

class SeasonDetailResponse extends Equatable {
  final int id;
  final String name;
  final String overview;
  final int seasonNumber;
  final String? posterPath;
  final List<EpisodeModel> episodes;

  SeasonDetailResponse({
    required this.id,
    required this.name,
    required this.overview,
    required this.seasonNumber,
    required this.posterPath,
    required this.episodes,
  });

  factory SeasonDetailResponse.fromJson(Map<String, dynamic> json) =>
      SeasonDetailResponse(
        id: json['id'],
        name: json['name'] ?? '',
        overview: json['overview'] ?? '',
        seasonNumber: json['season_number'] ?? 0,
        posterPath: json['poster_path'],
        episodes: json['episodes'] != null
            ? List<EpisodeModel>.from(
                json['episodes'].map((x) => EpisodeModel.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'overview': overview,
        'season_number': seasonNumber,
        'poster_path': posterPath,
        'episodes': List<dynamic>.from(episodes.map((x) => x.toJson())),
      };

  SeasonDetail toEntity() => SeasonDetail(
        id: id,
        name: name,
        overview: overview,
        seasonNumber: seasonNumber,
        posterPath: posterPath,
        episodes: episodes.map((x) => x.toEntity()).toList(),
      );

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
