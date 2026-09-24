import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/season.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvDetail = TvDetail(
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    name: 'Name',
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    overview: 'Overview',
    posterPath: 'posterPath',
    firstAirDate: '2021-01-01',
    voteAverage: 1.0,
    voteCount: 1,
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
  );

  final tTvDetailEqual = TvDetail(
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    name: 'Name',
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    overview: 'Overview',
    posterPath: 'posterPath',
    firstAirDate: '2021-01-01',
    voteAverage: 1.0,
    voteCount: 1,
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
  );

  test('should support value equality', () {
    expect(tTvDetail, equals(tTvDetailEqual));
  });
}
