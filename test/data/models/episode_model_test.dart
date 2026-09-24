import 'package:ditonton/data/models/episode_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

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

  test('should be a subclass of Episode entity', () async {
    final result = tEpisodeModel.toEntity();
    expect(result, testEpisode);
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      final jsonMap = {
        'id': 1,
        'name': 'Episode 1',
        'overview': 'Overview',
        'still_path': '/still.jpg',
        'vote_average': 8.0,
        'episode_number': 1,
        'season_number': 1,
      };

      final result = EpisodeModel.fromJson(jsonMap);
      expect(result, tEpisodeModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      final result = tEpisodeModel.toJson();
      final expectedJsonMap = {
        'id': 1,
        'name': 'Episode 1',
        'overview': 'Overview',
        'still_path': '/still.jpg',
        'vote_average': 8.0,
        'episode_number': 1,
        'season_number': 1,
      };
      expect(result, expectedJsonMap);
    });
  });
}
