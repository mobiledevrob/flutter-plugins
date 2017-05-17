// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:test/test.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  const channel = const MethodChannel('plugins.flutter.io/url_launcher');
  final List<MethodCall> log = <MethodCall>[];
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    log.add(methodCall);
  });

  tearDown(() {
    log.clear();
  });

  test('canLaunch test', () async {
    await canLaunch('http://example.com/');
    expect(
      log,
      equals(<MethodCall>[new MethodCall('canLaunch', 'http://example.com/')]),
    );
    log.clear();
  });

  test('launch test', () async {
    await launch('http://example.com/');
    expect(log,
        equals(<MethodCall>[new MethodCall('launch', 'http://example.com/')]));
  });
}
