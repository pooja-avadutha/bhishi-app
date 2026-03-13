import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_models.dart';
import '../../core/app_constants.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Auth
  static Future<void> setLoggedIn(bool value) async {
    await _prefs?.setBool(AppConstants.keyIsLoggedIn, value);
  }

  static bool isLoggedIn() {
    return _prefs?.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }

  // Groups (Now contains its own members)
  static Future<void> saveGroups(List<GroupModel> groups) async {
    final List<String> groupsJson = groups.map((g) => g.toJson()).toList();
    await _prefs?.setStringList(AppConstants.keyGroups, groupsJson);
  }

  static List<GroupModel> getGroups() {
    final List<String>? groupsJson = _prefs?.getStringList(AppConstants.keyGroups);
    if (groupsJson == null) return [];
    return groupsJson.map((g) => GroupModel.fromJson(g)).toList();
  }

  // Global Payment records (optional, if we want cross-group tracking, but usually within group)
  static Future<void> savePaymentRecords(List<PaymentModel> records) async {
    final List<String> recordsJson = records.map((r) => json.encode(r.toMap())).toList();
    await _prefs?.setStringList('payment_records', recordsJson);
  }

  static List<PaymentModel> getPaymentRecords() {
    final List<String>? recordsJson = _prefs?.getStringList('payment_records');
    if (recordsJson == null) return [];
    return recordsJson.map((r) => PaymentModel.fromMap(json.decode(r))).toList();
  }

  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
