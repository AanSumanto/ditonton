import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvModel = TvModel(
    backdropPath: '/path.jpg',
    genreIds: [1, 2, 3],
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
  final tTvResponse = TvResponse(tvList: <TvModel>[tTvModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "results": [
          {
            "backdrop_path": "/path.jpg",
            "genre_ids": [1, 2, 3],
            "id": 1,
            "name": "Name",
            "origin_country": ["US"],
            "original_language": "en",
            "original_name": "Original Name",
            "overview": "Overview",
            "popularity": 1.0,
            "poster_path": "/path.jpg",
            "first_air_date": "2021-01-01",
            "vote_average": 1.0,
            "vote_count": 1
          }
        ],
      };
      // act
      final result = TvResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvResponse);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/path.jpg",
            "genre_ids": [1, 2, 3],
            "id": 1,
            "name": "Name",
            "origin_country": ["US"],
            "original_language": "en",
            "original_name": "Original Name",
            "overview": "Overview",
            "popularity": 1.0,
            "poster_path": "/path.jpg",
            "first_air_date": "2021-01-01",
            "vote_average": 1.0,
            "vote_count": 1
          }
        ],
      };
      // act
      final result = tTvResponse.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });
}
