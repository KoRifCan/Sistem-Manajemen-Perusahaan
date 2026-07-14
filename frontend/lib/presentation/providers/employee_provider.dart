import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/employee_model.dart';
import '../../data/repositories/employee_repository.dart';

class EmployeeProvider extends ChangeNotifier {
  final EmployeeRepository _repository = EmployeeRepository();
  List<EmployeeModel> _employees = [];
  EmployeeModel? _selectedEmployee;
  List<Map<String, dynamic>> _departments = [];
  List<Map<String, dynamic>> _positions = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _employeeSub;
  StreamSubscription? _deptSub;
  StreamSubscription? _positionSub;

  List<EmployeeModel> get employees => _employees;
  EmployeeModel? get selectedEmployee => _selectedEmployee;
  List<Map<String, dynamic>> get departments => _departments;
  List<Map<String, dynamic>> get positions => _positions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  EmployeeProvider() {
    _deptSub = _repository.getDepartments().listen((data) {
      _departments = data;
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      notifyListeners();
    });
    _positionSub = _repository.getPositions().listen((data) {
      _positions = data;
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  void loadEmployees({String? departmentId}) {
    _employeeSub?.cancel();
    _isLoading = true;
    notifyListeners();
    _employeeSub = _repository.getAllEmployees(departmentId: departmentId).listen((data) {
      _employees = data;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<void> addEmployee(EmployeeModel employee) async {
    try {
      await _repository.addEmployee(employee);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateEmployee(String id, Map<String, dynamic> data) async {
    try {
      await _repository.updateEmployee(id, data);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteEmployee(String id) async {
    try {
      await _repository.deleteEmployee(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void selectEmployee(EmployeeModel? employee) {
    _selectedEmployee = employee;
    notifyListeners();
  }

  @override
  void dispose() {
    _employeeSub?.cancel();
    _deptSub?.cancel();
    _positionSub?.cancel();
    super.dispose();
  }
}
