import 'package:tv/data/models/season_model.dart';
import 'package:core/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tSeasonModel = SeasonModel(
    airDate: '2021-01-01',
    episodeCount: 10,
    id: 1,
    name: 'Season 1',
    overview: 'overview',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
  );

  final tSeason = Season(
    airDate: '2021-01-01',
    episodeCount: 10,
    id: 1,
    name: 'Season 1',
    overview: 'overview',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
  );

  test('should be a subclass of Season entity', () async {
    final result = tSeasonModel.toEntity();
    expect(result, tSeason);
  });

  test('fromJson should return valid model', () async {
    final jsonMap = {
      'air_date': '2021-01-01',
      'episode_count': 10,
      'id': 1,
      'name': 'Season 1',
      'overview': 'overview',
      'poster_path': '/poster.jpg',
      'season_number': 1,
    };
    final result = SeasonModel.fromJson(jsonMap);
    expect(result, tSeasonModel);
  });

  test('toJson should return JSON map containing proper data', () async {
    final expectedJsonMap = {
      'air_date': '2021-01-01',
      'episode_count': 10,
      'id': 1,
      'name': 'Season 1',
      'overview': 'overview',
      'poster_path': '/poster.jpg',
      'season_number': 1,
    };
    final result = tSeasonModel.toJson();
    expect(result, expectedJsonMap);
  });
}
