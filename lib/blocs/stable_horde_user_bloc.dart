import 'dart:convert';

import 'package:package_info/package_info.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/model/stable_horde_user.dart';

import 'package:http/http.dart' as http;
import 'package:stable_horde_flutter/utils/http_wrapper.dart';

class _StableHordeUserBloc {

  Future<StableHordeUser?> lookupUser(String? apiKey) async {
    apiKey ??= await sharedPrefsBloc.getApiKey();

    if (apiKey == null) {
      return null;
    }

    final headers = await getHttpHeaders(apiKey);

    final response = await http.get(
      Uri.parse(
        'https://stablehorde.net/api/v2/find_user',
      ),
      headers: headers,
    );

    if (response.statusCode == 401 || response.statusCode == 404) {
      sharedPrefsBloc.setApiKey(null);
      return null;
    }

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

    return StableHordeUser(
      jsonResponse['username'],
      (jsonResponse['kudos'] as num).toInt(),
      jsonResponse['usage']['requests'],
      jsonResponse['contributions']['fulfillments'],
    );
  }
}

final stableHordeUserBloc = _StableHordeUserBloc();
