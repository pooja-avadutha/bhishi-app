import 'package:flutter/material.dart';
import '../../data/datasources/storage_service.dart';
import '../../data/models/app_models.dart';
import '../../core/app_constants.dart';

class BhishiProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  List<GroupModel> _groups = [];
  List<PaymentModel> _paymentRecords = [];

  bool get isLoggedIn => _isLoggedIn;
  List<GroupModel> get groups => _groups;
  List<PaymentModel> get paymentRecords => _paymentRecords;

  BhishiProvider() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await StorageService.init();
    _isLoggedIn = StorageService.isLoggedIn();
    _groups = StorageService.getGroups();
    _paymentRecords = StorageService.getPaymentRecords();
    notifyListeners();
  }

  // Auth
  Future<bool> login(String username, String password) async {
    if (username == AppConstants.defaultUsername && password == AppConstants.defaultPassword) {
      _isLoggedIn = true;
      await StorageService.setLoggedIn(true);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    await StorageService.setLoggedIn(false);
    notifyListeners();
  }

  // Groups
  Future<void> addGroup(GroupModel group) async {
    _groups.add(group);
    await StorageService.saveGroups(_groups);
    notifyListeners();
  }

  Future<void> updateGroup(GroupModel updatedGroup) async {
    final index = _groups.indexWhere((g) => g.id == updatedGroup.id);
    if (index != -1) {
      _groups[index] = updatedGroup;
      await StorageService.saveGroups(_groups);
      notifyListeners();
    }
  }

  // Payments
  Future<void> addPayment(PaymentModel record) async {
    _paymentRecords.add(record);
    await StorageService.savePaymentRecords(_paymentRecords);
    notifyListeners();
  }

  // Statistics for Graphs
  double getTotalMonthlyCollection() {
    double total = 0;
    for (var g in _groups) {
      total += g.monthlyAmount * g.members.length;
    }
    return total;
  }

  double getAgentTotalProfit() {
    double total = 0;
    for (var g in _groups) {
      final monthsProcessed = g.winners.length;
      total += (g.monthlyAmount * g.members.length) * g.agentCommission * monthsProcessed;
    }
    return total;
  }
}
