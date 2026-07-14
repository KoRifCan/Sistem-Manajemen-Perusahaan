import 'package:flutter/material.dart';
import '../../data/models/leave_model.dart';
import '../../data/repositories/leave_repository.dart';

class LeaveProvider extends ChangeNotifier {
  final LeaveRepository _repository = LeaveRepository();
  List<LeaveModel> _leaves = [];
  List<LeaveModel> _pendingApprovals = [];
  bool _isLoading = false;
  String? _error;

  List<LeaveModel> get leaves => _leaves;
  List<LeaveModel> get pendingApprovals => _pendingApprovals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void loadEmployeeLeaves(String employeeId) {
    _isLoading = true;
    notifyListeners();
    _repository.getEmployeeLeaves(employeeId).listen((data) {
      _leaves = data;
      _isLoading = false;
      notifyListeners();
    });
  }

  void loadPendingApprovals(String approverId) {
    _repository.getPendingLeaves(approverId).listen((data) {
      _pendingApprovals = data;
      notifyListeners();
    });
  }

  Future<bool> submitLeave(LeaveModel leave) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.submitLeave(leave);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> approveLeave(String id, String approverId) async {
    try {
      await _repository.approveLeave(id, approverId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> rejectLeave(String id, String approverId, String reason) async {
    try {
      await _repository.rejectLeave(id, approverId, reason);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelLeave(String id) async {
    try {
      await _repository.cancelLeave(id);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
