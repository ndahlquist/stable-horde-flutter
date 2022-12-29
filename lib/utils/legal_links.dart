import 'package:stable_horde_flutter/blocs/conversions_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

Future launchPrivacyPolicy() async {
  const url = "https://zoomscroller.com/privacy-policy.html";
  await launchUrlInExternalApp(url);
}

Future launchTermsOfService() async {
  const url = "https://zoomscroller.com/terms-of-service.html";
  await launchUrlInExternalApp(url);
}

Future launchUrlInExternalApp(String url) async {
  conversionsBloc.viewLink(url);

  final uri = Uri.parse(url);

  final successful = await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );

  if (!successful) {
    throw Exception("Failed to open $url in external app");
  }
}
