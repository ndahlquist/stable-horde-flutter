import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';

Future<Map<String, String>?> getHttpHeaders(String apiKey) async {
  final pi = await PackageInfo.fromPlatform();

  return {
    'Accept': '* / *',
    'Accept-Language': 'en-US,en;q=0.9',
    'Connection': 'keep-alive',
    'Content-Type': 'application/json',
    'Client-Agent': 'stable-horde-flutter:${pi.version}:ndahlquist',
    'apikey': apiKey,
  };
}

Future<http.Response?> httpGet(String url,
    {Map<String, String>? headers}) async {
  final uri = Uri.parse(url);
  try {
    return await http.get(uri, headers: headers);
  } on http.ClientException catch (e) {
    if (e.message.contains("Failed host lookup") ||
        e.message.contains("Connection timed out") ||
        e.message.contains("Software caused connection abort")) {
      // No internet connection or connection interrupted.
      return null;
    }

    rethrow;
  }
}

Future<http.Response?> httpPost(
  String url, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
}) async {
  final uri = Uri.parse(url);
  try {
    return await http.post(
      uri,
      headers: headers,
      body: body,
      encoding: encoding,
    );
  } on http.ClientException catch (e) {
    if (e.message.contains("Failed host lookup") ||
        e.message.contains("Connection timed out") ||
        e.message.contains("Software caused connection abort")) {
      // No internet connection or connection interrupted.
      return null;
    }

    rethrow;
  }
}
