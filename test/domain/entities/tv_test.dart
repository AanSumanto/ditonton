import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTv = Tv(
    backdropPath: '/path.jpg',
    genreIds: [1, 2],
    id: 1,
    name: 'Name',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    firstAirDate: '2021-01-01',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTvEqual = Tv(
    backdropPath: '/path.jpg',
    genreIds: [1, 2],
    id: 1,
    name: 'Name',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    firstAirDate: '2021-01-01',
    voteAverage: 1.0,
    voteCount: 1,
  );

  test('should support value equality', () {
    expect(tTv, equals(tTvEqual));
  });

  test('watchlist constructor should create valid entity', () {
    final tTvWatchlist = Tv.watchlist(
      id: 1,
      name: 'Name',
      posterPath: '/path.jpg',
      overview: 'Overview',
    );
    expect(tTvWatchlist.id, 1);
    expect(tTvWatchlist.name, 'Name');
    expect(tTvWatchlist.posterPath, '/path.jpg');
    expect(tTvWatchlist.overview, 'Overview');
  });
}
