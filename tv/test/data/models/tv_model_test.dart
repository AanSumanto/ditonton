import 'package:tv/data/models/tv_model.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvModel = TvModel(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTv = Tv(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    voteAverage: 1,
    voteCount: 1,
  );

  test('should be a subclass of Tv entity', () async {
    final result = tTvModel.toEntity();
    expect(result, tTv);
  });

  test('fromJson should return valid model', () async {
    final jsonMap = {
      'backdrop_path': 'backdropPath',
      'genre_ids': [1, 2, 3],
      'id': 1,
      'name': 'name',
      'origin_country': ['US'],
      'original_language': 'en',
      'original_name': 'originalName',
      'overview': 'overview',
      'popularity': 1.0,
      'poster_path': 'posterPath',
      'first_air_date': 'firstAirDate',
      'vote_average': 1.0,
      'vote_count': 1,
    };
    final result = TvModel.fromJson(jsonMap);
    expect(result, tTvModel);
  });

  test('fromJson should handle null genre_ids and origin_country', () async {
    final jsonMap = {
      'id': 1,
      'genre_ids': null,
      'origin_country': null,
    };
    final result = TvModel.fromJson(jsonMap);
    expect(result.genreIds, isEmpty);
    expect(result.originCountry, isNull);
  });

  test('toJson should return JSON map containing proper data', () async {
    final expectedJsonMap = {
      'backdrop_path': 'backdropPath',
      'genre_ids': [1, 2, 3],
      'id': 1,
      'name': 'name',
      'origin_country': ['US'],
      'original_language': 'en',
      'original_name': 'originalName',
      'overview': 'overview',
      'popularity': 1.0,
      'poster_path': 'posterPath',
      'first_air_date': 'firstAirDate',
      'vote_average': 1.0,
      'vote_count': 1,
    };
    final result = tTvModel.toJson();
    expect(result, expectedJsonMap);
  });
}
