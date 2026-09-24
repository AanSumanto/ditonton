import 'package:movie/movie.dart';
import 'package:tv/tv.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/domain/usecases/search_tv.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  MovieRepository,
  TvRepository,
  SearchMovies,
  SearchTv,
])
void main() {}
