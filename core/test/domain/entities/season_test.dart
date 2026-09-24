import 'package:core/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tSeason = Season(
    airDate: '2021-01-01',
    episodeCount: 10,
    id: 1,
    name: 'Season 1',
    overview: 'overview',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
  );

  final tSeasonEqual = Season(
    airDate: '2021-01-01',
    episodeCount: 10,
    id: 1,
    name: 'Season 1',
    overview: 'overview',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
  );

  test('should support value equality', () {
    expect(tSeason, equals(tSeasonEqual));
    expect(tSeason.props, [
      '2021-01-01',
      10,
      1,
      'Season 1',
      'overview',
      '/poster.jpg',
      1,
    ]);
  });
}
