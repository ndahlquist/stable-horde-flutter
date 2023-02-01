import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';

Future<Map<String, String>?> getHttpHeaders(String? apiKey) async {
  var apiKey = await sharedPrefsBloc.getApiKey();
  apiKey ??= "0000000000"; // Anonymous API key.

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

Future<http.Response?> httpGet(
  String url, {
  Map<String, String>? headers,
}) async {
  headers ??= await getHttpHeaders(null);

  final uri = Uri.parse(url);
  try {
    return await http.get(uri, headers: headers);
  } on http.ClientException catch (e) {
    print(e);
    return null;
  } on IOException catch (e) {
    print(e);
    return null;
  }
}

Future<http.Response?> httpPost(
  String url, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
}) async {
  headers ??= await getHttpHeaders(null);

  final uri = Uri.parse(url);
  try {
    return await http.post(
      uri,
      headers: headers,
      body: body,
      encoding: encoding,
    );
  } on http.ClientException catch (e) {
    print(e);
    return null;
  } on IOException catch (e) {
    print(e);
    return null;
  }
}
