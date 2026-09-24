import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tEpisode = Episode(
    id: 1,
    name: 'Episode 1',
    overview: 'Overview',
    stillPath: '/still.jpg',
    voteAverage: 8.0,
    episodeNumber: 1,
    seasonNumber: 1,
  );

  final tSeasonDetail = SeasonDetail(
    id: 1,
    name: 'Season 1',
    overview: 'Season 1 Overview',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
    episodes: [tEpisode],
  );

  final tSeasonDetailEqual = SeasonDetail(
    id: 1,
    name: 'Season 1',
    overview: 'Season 1 Overview',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
    episodes: [tEpisode],
  );

  test('should support value equality', () {
    expect(tSeasonDetail, equals(tSeasonDetailEqual));
  });
}
