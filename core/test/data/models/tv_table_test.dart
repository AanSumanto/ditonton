import 'package:core/data/models/tv_table.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final tTvTable = TvTable(
    id: 1,
    name: 'Name',
    posterPath: 'posterPath',
    overview: 'Overview',
  );

  final tTvWatchlist = Tv.watchlist(
    id: 1,
    name: 'Name',
    posterPath: 'posterPath',
    overview: 'Overview',
  );

  test('should be a subclass of Tv entity', () async {
    final result = tTvTable.toEntity();
    expect(result, tTvWatchlist);
  });

  test('fromEntity should return valid TvTable', () {
    final result = TvTable.fromEntity(testTvDetail);
    expect(result, tTvTable);
  });

  test('fromMap should return valid TvTable', () {
    final map = {
      'id': 1,
      'name': 'Name',
      'posterPath': 'posterPath',
      'overview': 'Overview',
    };
    final result = TvTable.fromMap(map);
    expect(result, tTvTable);
  });

  test('toJson should return valid map', () {
    final expectedMap = {
      'id': 1,
      'name': 'Name',
      'posterPath': 'posterPath',
      'overview': 'Overview',
    };
    final result = tTvTable.toJson();
    expect(result, expectedMap);
  });
}
