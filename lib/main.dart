import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:looney_cam/pages/displayResult.dart';
import 'package:looney_cam/pages/videoApp.dart';
import 'package:looney_cam/pages/home.dart';
import 'package:looney_cam/pages/makeImage.dart';
import 'package:looney_cam/pages/start.dart';

import 'package:flutter/foundation.dart';

import 'package:sentry/sentry.dart';

final _sentry = SentryClient(
    dsn:
        "https://b79dff615895426f8c0e899e42c313ac@o456590.ingest.sentry.io/5449814");

bool get isInDebugMode {
  // Assume you're in production mode.
  bool inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code only sets `inDebugMode` to true
  // in a development environment.
  assert(inDebugMode = true);

  return inDebugMode;
}

Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  if (isInDebugMode) {
    // Print the full stacktrace in debug mode.
    print(stackTrace);
    return;
  }
  final SentryResponse response = await
      // Send the Exception and Stacktrace to Sentry in Production mode.
      _sentry.captureException(
    exception: error,
    stackTrace: stackTrace,
  );

  if (response.isSuccessful) {
    print('Success! Event ID: ${response.eventId}');
  } else {
    print('Failed to report to Sentry.io: ${response.error}');
  }
}

Future<void> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runZonedGuarded(() async {
      runApp(MaterialApp(
          theme: ThemeData(highlightColor: Colors.white),
          initialRoute: '/start',
          routes: {
            '/start': (context) => Start(),
            '/home': (context) => Home(),
            '/image': (context) => MakeImage(),
            '/video': (context) => VideoApp(),
            '/result': (context) => DisplayResult(),
          }));
    }, (Object error, StackTrace stackTrace) async {
      await _reportError(error, stackTrace);
    });
  });
}
