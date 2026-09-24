library search;

// Usecases
export 'domain/usecases/search_movies.dart';
export 'domain/usecases/search_tv.dart';

// BLoC
export 'presentation/bloc/movie_search_bloc.dart';
export 'presentation/bloc/tv_search_bloc.dart' hide debounce;

// Presentation
export 'presentation/pages/search_page.dart';
export 'presentation/pages/tv_search_page.dart';

// Provider (for backward compatibility)
export 'presentation/provider/movie_search_notifier.dart';
export 'presentation/provider/tv_search_notifier.dart';
