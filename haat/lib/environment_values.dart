import 'dart:convert';
import 'package:flutter/services.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFDevEnvironmentValues {
  static const String currentEnvironment = 'Development';
  static const String environmentValuesPath =
      'assets/environment_values/environment.json';

  static final FFDevEnvironmentValues _instance =
      FFDevEnvironmentValues._internal();

  factory FFDevEnvironmentValues() {
    return _instance;
  }

  FFDevEnvironmentValues._internal();

  Future<void> initialize() async {
    try {
      final String response =
          await rootBundle.loadString(environmentValuesPath);
      final data = await json.decode(response);
      _baseURL = data['baseURL'];
      _dataSource = data['dataSource'];
      _bankCode = data['bankCode'];
    } catch (e) {
      print('Error loading environment values: $e');
    }
  }

  String _baseURL = '';
  String get baseURL => _baseURL;

  String _dataSource = '';
  String get dataSource => _dataSource;

  String _bankCode = '';
  String get bankCode => _bankCode;
}
