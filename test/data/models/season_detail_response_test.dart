import 'dart:convert';
import 'package:ditonton/data/models/episode_model.dart';
import 'package:ditonton/data/models/season_detail_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';

void main() {
  final tEpisodeModel = EpisodeModel(
    id: 1,
    name: 'Episode 1',
    overview: 'Overview',
    stillPath: '/still.jpg',
    voteAverage: 8.0,
    episodeNumber: 1,
    seasonNumber: 1,
  );

  final tSeasonDetailResponse = SeasonDetailResponse(
    id: 1,
    name: 'Season 1',
    overview: 'Season 1 Overview',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
    episodes: [tEpisodeModel],
  );

  test('should be a subclass of SeasonDetail entity', () async {
    final result = tSeasonDetailResponse.toEntity();
    expect(result, testSeasonDetail);
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_season_detail.json'));
      // act
      final result = SeasonDetailResponse.fromJson(jsonMap);
      // assert
      expect(result, tSeasonDetailResponse);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // act
      final result = tSeasonDetailResponse.toJson();
      // assert
      final expectedJsonMap = {
        'id': 1,
        'name': 'Season 1',
        'overview': 'Season 1 Overview',
        'poster_path': '/poster.jpg',
        'season_number': 1,
        'episodes': [
          {
            'id': 1,
            'name': 'Episode 1',
            'overview': 'Overview',
            'still_path': '/still.jpg',
            'vote_average': 8.0,
            'episode_number': 1,
            'season_number': 1,
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
