import 'dart:io';
import 'package:core/common/ssl_pinning.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/io_client.dart';

void main() {
  group('SSL Pinning', () {
    test('should succeed connecting to TMDB with custom SSL pinning client',
        () async {
      await HttpSSLPinning.init();
      final client = await HttpSSLPinning.createLEClient();
      final response = await client.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/now_playing?api_key=2174d146bb9c0eab47529b2e77d6b526'));
      expect(response.statusCode, 200);
      expect(HttpSSLPinning.client, isNotNull);
    });

    test(
        'should fail connecting to non-matching host with custom SSL pinning client',
        () async {
      final client = await HttpSSLPinning.createLEClient();
      expect(
        () => client.get(Uri.parse('https://google.com')),
        throwsA(isA<HandshakeException>()),
      );
    });

    test('customHttpClient should initialize successfully', () async {
      final httpClient = await HttpSSLPinning.customHttpClient(isTestMode: true);
      expect(httpClient, isA<HttpClient>());
    });

    test('init should initialize _clientInstance', () async {
      await HttpSSLPinning.init();
      expect(HttpSSLPinning.client, isA<IOClient>());
    });

    test('client should throw StateError if accessed before init', () {
      HttpSSLPinning.resetForTesting();
      expect(() => HttpSSLPinning.client, throwsStateError);
    });
  });
}
