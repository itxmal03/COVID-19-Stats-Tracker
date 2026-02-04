import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:covid_tracker/models/worldstats_model.dart';
import 'package:covid_tracker/services/utilities/app_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StatsServices extends ChangeNotifier {
  WorldStatsModel? _worldStats;
  List<dynamic> _countriesList = [];
  List<dynamic> _filteredCountriesList = [];
  bool _loading = false;
  bool _loadingCountries = false;
  String? _errorStats;
  String? _errorCountries;

  WorldStatsModel? get worldStats => _worldStats;
  List<dynamic> get countriesList => _countriesList;
  List<dynamic> get filteredCountriesList => _filteredCountriesList;

  String? get errorStats => _errorStats;
  String? get errorCountries => _errorCountries;

  bool get loading => _loading;
  bool get loadingCountries => _loadingCountries;

  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> getWorldStats() async {
    _loading = true;
    _errorStats = null;
    notifyListeners();

    if (!await _hasInternet()) {
      _loading = false;
      _errorStats = 'No internet connection';
      notifyListeners();
      return;
    }

    try {
      final response = await http
          .get(Uri.parse(AppUrl.worldStatsApi))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _worldStats = WorldStatsModel.fromJson(jsonDecode(response.body));
      } else {
        _worldStats = null;
        _errorStats = _mapStatusCode(response.statusCode);
      }
    } on TimeoutException {
      _errorStats = 'Request timed out!';
    } catch (_) {
      _errorStats = 'Failed to load data!';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> getCountriesList() async {
    _loadingCountries = true;
    _errorCountries = null;
    notifyListeners();

    if (!await _hasInternet()) {
      _loadingCountries = false;
      _errorCountries = 'No internet connection';
      notifyListeners();
      return;
    }

    try {
      final response = await http
          .get(Uri.parse(AppUrl.countriesList))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _countriesList = jsonDecode(response.body);
        _filteredCountriesList = List.from(_countriesList);
      } else {
        _countriesList = [];
        _errorCountries = _mapStatusCode(response.statusCode);
      }
    } on TimeoutException {
      _errorCountries = 'Request timed out!';
    } catch (_) {
      _errorCountries = 'Failed to load data!';
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

  Timer? _debounce;
  void filterCountries(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.isEmpty) {
        _filteredCountriesList = List.from(_countriesList);
      } else {
        _filteredCountriesList = _countriesList.where((country) {
          final name = country['country'].toString().toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();
      }
      notifyListeners();
    });
  }

  void resetFilteredCountries() {
    _filteredCountriesList = List.from(_countriesList);
    notifyListeners();
  }
}
