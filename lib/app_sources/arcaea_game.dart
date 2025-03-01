import 'package:easy_localization/easy_localization.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:obtainium/custom_errors.dart';
import 'package:obtainium/providers/source_provider.dart';
import 'dart:convert';

class ArcaeaGame extends AppSource {
  ArcaeaGame() {
    hosts = ['arcaea.lowiro.com'];
    name = 'Arcaea ${tr('app')}';
  }

  @override
  String sourceSpecificStandardizeURL(String url, {bool forSelection = false}) {
    return 'https://${hosts[0]}';
  }

  @override
  Future<APKDetails> getLatestAPKDetails(
    String standardUrl,
    Map<String, dynamic> additionalSettings,
  ) async {
    Map<String, dynamic> json;
    try {
        Response res = 
            await sourceRequest(
            'https://webapi.lowiro.com/webapi/serve/static/bin/arcaea/apk', 
            additionalSettings);
        jsonMap = jsonDecode(res);
    } catch (e) {
        // placeholder
        throw NoVersionError();
    }
    
    if (json['success'] != true)
        throw NoVersionError(); // May failed for many reasons
    
    Map<String, String> messages = json['value'];
    var version = messages['version'];
    String apkUrl = messages['url'];
    return APKDetails(
        version,
        [MapEntry<String, String>('Arcaea-$version.apk', apkUrl)],
        AppNames('Arcaea', 'Arcaea'));

  }
}
