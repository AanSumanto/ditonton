library tv;

// Repositories
export 'domain/repositories/tv_repository.dart';

// Usecases
export 'domain/usecases/get_now_playing_tv.dart';
export 'domain/usecases/get_popular_tv.dart';
export 'domain/usecases/get_top_rated_tv.dart';
export 'domain/usecases/get_tv_detail.dart';
export 'domain/usecases/get_tv_recommendations.dart';
export 'domain/usecases/get_tv_season_detail.dart';
export 'domain/usecases/get_watchlist_tv.dart';
export 'domain/usecases/get_watchlist_tv_status.dart';
export 'domain/usecases/save_watchlist_tv.dart';
export 'domain/usecases/remove_watchlist_tv.dart';

// Data
export 'data/models/tv_model.dart';
export 'data/models/tv_detail_model.dart';
export 'data/models/tv_response.dart';
export 'data/models/season_model.dart';
export 'data/models/season_detail_response.dart';
export 'data/models/episode_model.dart';
export 'data/datasources/tv_remote_data_source.dart';
export 'data/datasources/tv_local_data_source.dart';
export 'data/repositories/tv_repository_impl.dart';

// BLoC
export 'presentation/bloc/now_playing_tv_bloc.dart';
export 'presentation/bloc/popular_tv_bloc.dart';
export 'presentation/bloc/top_rated_tv_bloc.dart';
export 'presentation/bloc/tv_detail_bloc.dart';
export 'presentation/bloc/watchlist_tv_bloc.dart';

// Presentation
export 'presentation/pages/home_tv_page.dart';
export 'presentation/pages/popular_tv_page.dart';
export 'presentation/pages/top_rated_tv_page.dart';
export 'presentation/pages/now_playing_tv_page.dart';
export 'presentation/pages/tv_detail_page.dart';
export 'presentation/pages/watchlist_tv_page.dart';
export 'presentation/widgets/tv_card_list.dart';

// Provider (for backward compatibility)
export 'presentation/provider/tv_list_notifier.dart';
export 'presentation/provider/popular_tv_notifier.dart';
export 'presentation/provider/top_rated_tv_notifier.dart';
export 'presentation/provider/now_playing_tv_notifier.dart';
export 'presentation/provider/tv_detail_notifier.dart';
export 'presentation/provider/watchlist_tv_notifier.dart';
