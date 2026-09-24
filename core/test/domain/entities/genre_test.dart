import 'package:core/domain/entities/genre.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should support value equality', () {
    expect(
      Genre(id: 1, name: 'Action'),
      Genre(id: 1, name: 'Action'),
    );
  });
}
