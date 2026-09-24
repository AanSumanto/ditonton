import 'package:core/core.dart';
import 'package:tv/data/datasources/tv_local_data_source.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:tv/presentation/provider/tv_list_notifier.dart';
import 'package:tv/presentation/provider/watchlist_tv_notifier.dart';
import 'package:tv/domain/usecases/get_now_playing_tv.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_tv_season_detail.dart';
import 'package:tv/domain/usecases/get_watchlist_tv.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  TvRepository,
  TvRemoteDataSource,
  TvLocalDataSource,
  DatabaseHelper,
  // TV usecases
  GetNowPlayingTv,
  GetPopularTv,
  GetTopRatedTv,
  GetTvDetail,
  GetTvRecommendations,
  GetTvSeasonDetail,
  GetWatchlistTv,
  GetWatchlistTvStatus,
  SaveWatchlistTv,
  RemoveWatchlistTv,
  // TV Notifiers for backward compatibility
  TvListNotifier,
  WatchlistTvNotifier,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
