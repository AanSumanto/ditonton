import 'package:ditonton/domain/entities/episode.dart';
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

  final tEpisodeEqual = Episode(
    id: 1,
    name: 'Episode 1',
    overview: 'Overview',
    stillPath: '/still.jpg',
    voteAverage: 8.0,
    episodeNumber: 1,
    seasonNumber: 1,
  );

  test('should support value equality', () {
    expect(tEpisode, equals(tEpisodeEqual));
  });
}
