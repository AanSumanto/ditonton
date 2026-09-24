import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvDetailResponse = TvDetailResponse(
    backdropPath: 'backdropPath',
    firstAirDate: '2021-01-01',
    genres: [GenreModel(id: 1, name: 'Action')],
    id: 1,
    name: 'Name',
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    overview: 'Overview',
    posterPath: 'posterPath',
    seasons: [
      SeasonModel(
        airDate: '2021-01-01',
        episodeCount: 10,
        id: 1,
        name: 'Season 1',
        overview: 'overview',
        posterPath: '/poster.jpg',
        seasonNumber: 1,
      ),
    ],
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTvDetail = TvDetail(
    backdropPath: 'backdropPath',
    firstAirDate: '2021-01-01',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    name: 'Name',
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    overview: 'Overview',
    posterPath: 'posterPath',
    seasons: [
      Season(
        airDate: '2021-01-01',
        episodeCount: 10,
        id: 1,
        name: 'Season 1',
        overview: 'overview',
        posterPath: '/poster.jpg',
        seasonNumber: 1,
      ),
    ],
    voteAverage: 1.0,
    voteCount: 1,
  );

  test('should be a subclass of TvDetail entity', () async {
    final result = tTvDetailResponse.toEntity();
    expect(result, tTvDetail);
  });

  test('fromJson should return a valid model from JSON', () async {
    final Map<String, dynamic> jsonMap = {
      'backdrop_path': 'backdropPath',
      'first_air_date': '2021-01-01',
      'genres': [
        {'id': 1, 'name': 'Action'}
      ],
      'id': 1,
      'name': 'Name',
      'number_of_episodes': 10,
      'number_of_seasons': 1,
      'overview': 'Overview',
      'poster_path': 'posterPath',
      'seasons': [
        {
          'air_date': '2021-01-01',
          'episode_count': 10,
          'id': 1,
          'name': 'Season 1',
          'overview': 'overview',
          'poster_path': '/poster.jpg',
          'season_number': 1,
        }
      ],
      'vote_average': 1.0,
      'vote_count': 1,
    };
    final result = TvDetailResponse.fromJson(jsonMap);
    expect(result, tTvDetailResponse);
  });

  test('fromJson should handle null genres and seasons', () async {
    final Map<String, dynamic> jsonMap = {
      'id': 1,
      'genres': null,
      'seasons': null,
    };
    final result = TvDetailResponse.fromJson(jsonMap);
    expect(result.genres, isEmpty);
    expect(result.seasons, isEmpty);
  });

  test('toJson should return JSON map containing proper data', () async {
    final expectedJsonMap = {
      'backdrop_path': 'backdropPath',
      'first_air_date': '2021-01-01',
      'genres': [
        {'id': 1, 'name': 'Action'}
      ],
      'id': 1,
      'name': 'Name',
      'number_of_episodes': 10,
      'number_of_seasons': 1,
      'overview': 'Overview',
      'poster_path': 'posterPath',
      'seasons': [
        {
          'air_date': '2021-01-01',
          'episode_count': 10,
          'id': 1,
          'name': 'Season 1',
          'overview': 'overview',
          'poster_path': '/poster.jpg',
          'season_number': 1,
        }
      ],
      'vote_average': 1.0,
      'vote_count': 1,
    };
    final result = tTvDetailResponse.toJson();
    expect(result, expectedJsonMap);
  });
}
