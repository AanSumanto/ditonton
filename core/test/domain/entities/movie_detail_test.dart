import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should support value equality', () {
    expect(
      MovieDetail(
        adult: false,
        backdropPath: 'backdropPath',
        genres: [Genre(id: 1, name: 'Action')],
        id: 1,
        originalTitle: 'originalTitle',
        overview: 'overview',
        posterPath: 'posterPath',
        releaseDate: 'releaseDate',
        runtime: 120,
        title: 'title',
        voteAverage: 1.0,
        voteCount: 1,
      ),
      MovieDetail(
        adult: false,
        backdropPath: 'backdropPath',
        genres: [Genre(id: 1, name: 'Action')],
        id: 1,
        originalTitle: 'originalTitle',
        overview: 'overview',
        posterPath: 'posterPath',
        releaseDate: 'releaseDate',
        runtime: 120,
        title: 'title',
        voteAverage: 1.0,
        voteCount: 1,
      ),
    );
  });
}
