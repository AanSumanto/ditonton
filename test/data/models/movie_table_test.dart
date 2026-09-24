import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tMovieWatchlist = Movie.watchlist(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  test('should be a subclass of Movie entity', () async {
    final result = tMovieTable.toEntity();
    expect(result, tMovieWatchlist);
  });

  test('fromEntity should return valid MovieTable', () {
    final result = MovieTable.fromEntity(testMovieDetail);
    expect(result, tMovieTable);
  });

  test('fromMap should return valid MovieTable', () {
    final map = {
      'id': 1,
      'title': 'title',
      'posterPath': 'posterPath',
      'overview': 'overview',
    };
    final result = MovieTable.fromMap(map);
    expect(result, tMovieTable);
  });

  test('toJson should return valid map', () {
    final expectedMap = {
      'id': 1,
      'title': 'title',
      'posterPath': 'posterPath',
      'overview': 'overview',
    };
    final result = tMovieTable.toJson();
    expect(result, expectedMap);
  });
}
