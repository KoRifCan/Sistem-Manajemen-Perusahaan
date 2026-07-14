import 'package:flutter/material.dart';
import '../../data/models/payroll_model.dart';
import '../../data/repositories/payroll_repository.dart';

class PayrollProvider extends ChangeNotifier {
  final PayrollRepository _repository = PayrollRepository();
  List<PayrollPeriodModel> _periods = [];
  List<PayslipModel> _payslips = [];
  PayslipModel? _selectedPayslip;
  bool _isLoading = false;
  String? _error;

  List<PayrollPeriodModel> get periods => _periods;
  List<PayslipModel> get payslips => _payslips;
  PayslipModel? get selectedPayslip => _selectedPayslip;
  bool get isLoading => _isLoading;
  String? get error => _error;

  PayrollProvider() {
    loadPeriods();
  }

  void loadPeriods() {
    _repository.getPayrollPeriods().listen((data) {
      _periods = data;
      notifyListeners();
    });
  }

  Future<void> loadPayslips(String employeeId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _payslips = await _repository.getEmployeePayslips(employeeId);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectPayslip(String id) async {
    _selectedPayslip = await _repository.getPayslipById(id);
    notifyListeners();
  }

  Future<String> generatePayslipPDF(String payslipId) async {
    return await _repository.generatePayslipPDF(payslipId);
  }
}
