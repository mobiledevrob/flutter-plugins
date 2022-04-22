// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import 'types.dart';

/// String version of [launchUrl].
///
/// This should be used only in the very rare case of needing to launch a URL
/// that is considered valid by the host platform, but not by Dart's [Uri]
/// class. In all other cases, use [launchUrl] instead, as that will ensure
/// that you are providing a valid URL.
///
/// The behavior of this method when passing an invalid URL is entirely
/// platform-specific; no effort is made by the plugin to make the URL valid.
/// Some platforms may provide best-effort interpretation of an invalid URL,
/// others will immediately fail if the URL can't be parsed according to the
/// official standards that define URL formats.
Future<bool> launchUrlString(
  String urlString, {
  LaunchMode mode = LaunchMode.platformDefault,
  WebViewConfiguration webViewConfiguration = const WebViewConfiguration(),
  String? webOnlyWindowName,
}) async {
  final bool isWebURL =
      urlString.startsWith('http:') || urlString.startsWith('https:');
  if (mode == LaunchMode.inAppWebView && !isWebURL) {
    throw ArgumentError.value(urlString, 'urlString',
        'To use an in-app web view, you must provide an http(s) URL.');
  }
  final bool useWebView = mode == LaunchMode.inAppWebView ||
      (isWebURL && mode == LaunchMode.platformDefault);

  // TODO(stuartmorgan): Create a replacement platform interface method that
  // uses something more like the new argument structure, and switch to using
  // that, to support launch mode on more platforms.
  return await UrlLauncherPlatform.instance.launch(
    urlString,
    useSafariVC: useWebView,
    useWebView: useWebView,
    enableJavaScript: webViewConfiguration.enableJavaScript,
    enableDomStorage: webViewConfiguration.enableDomStorage,
    universalLinksOnly: mode == LaunchMode.externalNonBrowserApplication,
    headers: webViewConfiguration.headers,
    webOnlyWindowName: webOnlyWindowName,
  );
}

/// String version of [canLaunchUrl].
///
/// This should be used only in the very rare case of needing to check a URL
/// that is considered valid by the host platform, but not by Dart's [Uri]
/// class. In all other cases, use [canLaunchUrl] instead, as that will ensure
/// that you are providing a valid URL.
///
/// The behavior of this method when passing an invalid URL is entirely
/// platform-specific; no effort is made by the plugin to make the URL valid.
/// Some platforms may provide best-effort interpretation of an invalid URL,
/// others will immediately fail if the URL can't be parsed according to the
/// official standards that define URL formats.
Future<bool> canLaunchUrlString(String urlString) async {
  return await UrlLauncherPlatform.instance.canLaunch(urlString);
}
