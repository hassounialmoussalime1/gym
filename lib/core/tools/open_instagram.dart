import 'package:url_launcher/url_launcher.dart';

Future<void> openInstagram() async {
  final Uri url = Uri.parse('https://www.instagram.com/power_gear2');

  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch Instagram';
  }
}
