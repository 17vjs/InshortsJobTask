import 'package:flutter/services.dart';

class Secrets {
  static const _channel = MethodChannel('com.yourdomain.app/secrets');

  static Future<String> get apiKey async =>
      await _channel.invokeMethod<String>('getApiKey') ?? '';

  static Future<String> get basicAuth async =>
      await _channel.invokeMethod<String>('getBasicAuth') ?? '';
}
