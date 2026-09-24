import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late DatabaseHelper databaseHelper;

  setUp(() {
    databaseHelper = DatabaseHelper();
  });

  final tMovie = MovieTable(
    id: 1,
    title: 'Spider-Man',
    posterPath: '/path.jpg',
    overview: 'Overview',
  );

  final tTv = TvTable(
    id: 1,
    name: 'Game of Thrones',
    posterPath: '/path.jpg',
    overview: 'Overview',
  );

  test('should insert and retrieve movie from database', () async {
    final insertResult = await databaseHelper.insertWatchlist(tMovie);
    expect(insertResult, 1);

    final movie = await databaseHelper.getMovieById(1);
    expect(movie, isNotNull);
    expect(movie!['title'], 'Spider-Man');

    final movies = await databaseHelper.getWatchlistMovies();
    expect(movies.isNotEmpty, true);

    final removeResult = await databaseHelper.removeWatchlist(tMovie);
    expect(removeResult, 1);

    final removedMovie = await databaseHelper.getMovieById(1);
    expect(removedMovie, isNull);
  });

  test('should insert and retrieve TV series from database', () async {
    final insertResult = await databaseHelper.insertWatchlistTv(tTv);
    expect(insertResult, 1);

    final tv = await databaseHelper.getTvById(1);
    expect(tv, isNotNull);
    expect(tv!['name'], 'Game of Thrones');

    final tvs = await databaseHelper.getWatchlistTv();
    expect(tvs.isNotEmpty, true);

    final removeResult = await databaseHelper.removeWatchlistTv(tTv);
    expect(removeResult, 1);

    final removedTv = await databaseHelper.getTvById(1);
    expect(removedTv, isNull);
  });
}
