import 'dart:convert';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/model/stable_horde_user.dart';

import 'package:http/http.dart' as http;

class _StableHordeUserBloc {

  Future<StableHordeUser?> lookupUser(String apiKey) async  {

    final headers = {
      'Accept': '* / *',
      'Accept-Language': 'en-US,en;q=0.9',
      'Connection': 'keep-alive',
      "Content-Type": "application/json",
      "apikey": apiKey,
    };

    final response = await http.get(
      Uri.parse(
        'https://stablehorde.net/api/v2/find_user',
      ),
      headers: headers,
    );

    if (response.statusCode != 200) {
      final exception = Exception(
        'Failed to get user: '
            '${response.statusCode} ${response.body}',
      );
      print(exception);
      Sentry.captureException(exception, stackTrace: StackTrace.current);
      return null;
    }

    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }
}

final stableHordeUserBloc = _StableHordeUserBloc();