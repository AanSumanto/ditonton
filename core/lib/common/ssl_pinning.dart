import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class HttpSSLPinning {
  static http.Client? _clientInstance;
  static http.Client get client => _clientInstance ?? http.Client();

  static Future<http.Client> get _instance async =>
      _clientInstance ??= await createLEClient();

  static Future<http.Client> createLEClient() async {
    IOClient client = IOClient(await customHttpClient());
    return client;
  }

  static Future<HttpClient> customHttpClient({
    bool isTestMode = false,
  }) async {
    SecurityContext context = SecurityContext(withTrustedRoots: false);
    try {
      List<int> bytes = [];
      if (isTestMode) {
        var file = File('assets/certificates.pem');
        if (!file.existsSync()) {
          file = File('../assets/certificates.pem');
        }
        if (!file.existsSync()) {
          file = File('../../assets/certificates.pem');
        }
        bytes = file.readAsBytesSync();
      } else {
        try {
          bytes = (await rootBundle.load('assets/certificates.pem'))
              .buffer
              .asUint8List();
        } catch (_) {
          var file = File('assets/certificates.pem');
          if (!file.existsSync()) {
            file = File('../assets/certificates.pem');
          }
          if (!file.existsSync()) {
            file = File('../../assets/certificates.pem');
          }
          if (file.existsSync()) {
            bytes = file.readAsBytesSync();
          }
        }
      }
      context.setTrustedCertificatesBytes(bytes);
    } on TlsException catch (e) {
      if (e.osError?.message != null &&
          e.osError!.message.contains('CERT_ALREADY_IN_HASH_TABLE')) {
        // certificate already added
      } else {
        rethrow;
      }
    }
    HttpClient httpClient = HttpClient(context: context);
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    return httpClient;
  }

  static Future<void> init() async {
    _clientInstance = await _instance;
  }
}
