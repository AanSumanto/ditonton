import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
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
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testSeason = Season(
  airDate: '2021-01-01',
  episodeCount: 10,
  id: 1,
  name: 'Season 1',
  overview: 'overview',
  posterPath: '/poster.jpg',
  seasonNumber: 1,
);

final testTv = Tv(
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 1,
  name: 'Name',
  originCountry: ['US'],
  originalLanguage: 'en',
  originalName: 'Original Name',
  overview: 'Overview',
  popularity: 1.0,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  firstAirDate: '2021-01-01',
  voteAverage: 1.0,
  voteCount: 1,
);

final testTvList = [testTv];

final testTvDetail = TvDetail(
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
  seasons: [testSeason],
);

final testWatchlistTv = Tv.watchlist(
  id: 1,
  name: 'Name',
  posterPath: 'posterPath',
  overview: 'Overview',
);

final testTvTable = TvTable(
  id: 1,
  name: 'Name',
  posterPath: 'posterPath',
  overview: 'Overview',
);

final testTvMap = {
  'id': 1,
  'overview': 'Overview',
  'posterPath': 'posterPath',
  'name': 'Name',
};
