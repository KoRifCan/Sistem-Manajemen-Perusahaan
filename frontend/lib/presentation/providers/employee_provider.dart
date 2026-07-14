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

  List<EmployeeModel> get employees => _employees;
  EmployeeModel? get selectedEmployee => _selectedEmployee;
  List<Map<String, dynamic>> get departments => _departments;
  List<Map<String, dynamic>> get positions => _positions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  EmployeeProvider() {
    loadDepartments();
    loadPositions();
  }

  void loadEmployees({String? departmentId}) {
    _isLoading = true;
    notifyListeners();
    _repository.getAllEmployees(departmentId: departmentId).listen((data) {
      _employees = data;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> loadDepartments() async {
    _departments = await _repository.getDepartments();
    notifyListeners();
  }

  Future<void> loadPositions() async {
    _positions = await _repository.getPositions();
    notifyListeners();
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
}
