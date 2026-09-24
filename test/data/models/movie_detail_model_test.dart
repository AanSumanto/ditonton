import 'dart:convert';

import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tMovieDetailResponse = MovieDetailResponse(
    adult: false,
    backdropPath: '/path.jpg',
    budget: 100,
    genres: [GenreModel(id: 1, name: 'Action')],
    homepage: 'https://google.com',
    id: 1,
    imdbId: 'imdb1',
    originalLanguage: 'en',
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    releaseDate: '2020-05-05',
    revenue: 120,
    runtime: 120,
    status: 'Status',
    tagline: 'Tagline',
    title: 'Title',
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: '/path.jpg',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    posterPath: '/path.jpg',
    releaseDate: '2020-05-05',
    runtime: 120,
    title: 'Title',
    voteAverage: 1.0,
    voteCount: 1,
  );

  test('should be a subclass of MovieDetail entity', () async {
    final result = tMovieDetailResponse.toEntity();
    expect(result, tMovieDetail);
  });

  test('fromJson should return valid model', () async {
    final Map<String, dynamic> jsonMap =
        json.decode(readJson('dummy_data/movie_detail.json'));
    final result = MovieDetailResponse.fromJson(jsonMap);
    expect(result, isNotNull);
    expect(result.id, 1);
    expect(result.title, 'Title');
  });

  test('toJson should return proper JSON map', () async {
    final result = tMovieDetailResponse.toJson();
    expect(result['id'], 1);
    expect(result['title'], 'Title');
  });
}
