import 'dart:async';
import 'dart:convert';

import 'package:covid_tracker/models/worldstats_model.dart';
import 'package:covid_tracker/services/utilities/app_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StatsServices extends ChangeNotifier {
  WorldStatsModel? _worldStats;
  List<dynamic> _countriesList = [];
  bool _loading = false;
  bool _loadingCountries = false;
  String? _errorStats;
  String? _errorCountries;

  WorldStatsModel? get worldStats => _worldStats;
  List<dynamic> get countriesList => _countriesList;
  String? get errorStats => _errorStats;
  String? get errorCountries => _errorCountries;

  bool get loading => _loading;
  bool get loadingCountries => _loadingCountries;

  Future<void> getWorldStats() async {
    _loading = true;
    _errorStats = null;
    notifyListeners();
    try {
      final response = await http
          .get(Uri.parse(AppUrl.worldStatsApi))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        _worldStats = WorldStatsModel.fromJson(decode);
      } else {
        _worldStats = null;
        _errorStats = _mapStatusCode(response.statusCode);
      }
    } catch (e) {
      if (e is TimeoutException) {
        _errorStats = 'Request timed out!';
      } else {
        _errorStats = 'Failed to load data!';
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> getCountriesList() async {
    _loadingCountries = true;
    _errorCountries = null;
    notifyListeners();
    try {
      final response = await http
          .get(Uri.parse(AppUrl.countriesList))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _countriesList = jsonDecode(response.body);
      } else {
        _countriesList = [];
        _errorCountries = _mapStatusCode(response.statusCode);
      }
    } catch (e) {
      if (e is TimeoutException) {
        _errorCountries = 'Request timed out!';
      } else {
        _errorCountries = 'Failed to load data!';
      }
    } finally {
      _loadingCountries = false;
      notifyListeners();
    }
  }

  String _mapStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized access';
      case 403:
        return 'Access forbidden';
      case 404:
        return 'Data not found';
      case 429:
        return 'Too many requests. Try again later';
      case 500:
        return 'Server error';
      default:
        return 'Unexpected error occurred';
    }
  }
}
