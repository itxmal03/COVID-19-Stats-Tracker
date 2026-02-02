import 'dart:convert';

import 'package:covid_tracker/models/worldstats_model.dart';
import 'package:covid_tracker/services/utilities/app_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StatsServices extends ChangeNotifier {
  WorldStatsModel? _worldStats;
  bool _loading = false;

  WorldStatsModel? get worldStats => _worldStats;
  bool get loading => _loading;

  Future<void> getWorldStats() async {
    _loading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse(AppUrl.worldStatsApi));
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        _worldStats = WorldStatsModel.fromJson(decode);
        _loading = false;
      notifyListeners();
      } else {
        throw Exception('Error to load api data!');
      }
    } catch (e) {
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
