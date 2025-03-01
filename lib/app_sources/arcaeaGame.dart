import 'package:easy_localization/easy_localization.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:obtainium/custom_errors.dart';
import 'package:obtainium/providers/source_provider.dart';
import 'dart:convert';
import 'package:flutter_js/flutter_js.dart';

final jsRuntime = getJavascriptRuntime();
/**
This is an experimental provider
using user-defined JavaScript to parse Web
 */
class ArcaeaGame extends AppSource {
  ArcaeaGame() {
    hosts = ['arcaea.lowiro.com'];
    name = 'Arcaea ${tr('app')} (Experimental)';
  }

  @override
  String sourceSpecificStandardizeURL(String url, {bool forSelection = false}) {
    return url;
  }

  @override
  Future<APKDetails> getLatestAPKDetails(
    String standardUrl,
    Map<String, dynamic> additionalSettings,
  ) async {
    Response res = 
      await sourceRequest(
      'https://webapi.lowiro.com/webapi/serve/static/bin/arcaea/apk', 
      additionalSettings);

    // A script example (Placeholder)
    String script = '''
      function parseData(input) {
        // parseData
        let res = JSON.parse(input);
        if (!res.success) return;
        res = res.value;
        return {
          name: "Arcaea",
          version: res.version,
          author: "lowiro",
          url: res.url
        };
      }
    ''';

    JsEvalResult jsResult = jsRuntime.evaluate(jsCode);
    if (!(jsResult.rawResult is Map)) 
      throw NoVersionError();
    Map<String, dynamic> data = Map<String, dynamic>.from(jsResult.rawResult);
    String version = data['version']!;
    String name = data['name']!;
    String author = data['author'] ?? name;
    return APKDetails(
      version,
      [MapEntry<String, String>('$name-$version.apk', apkUrl)],
      AppNames(author, name));
  }
}
