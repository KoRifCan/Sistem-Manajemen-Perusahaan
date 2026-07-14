import 'dart:async';
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
  StreamSubscription? _periodSub;
  StreamSubscription? _payslipSub;

  List<PayrollPeriodModel> get periods => _periods;
  List<PayslipModel> get payslips => _payslips;
  PayslipModel? get selectedPayslip => _selectedPayslip;
  bool get isLoading => _isLoading;
  String? get error => _error;

  PayrollProvider() {
    _periodSub = _repository.getPayrollPeriods().listen((data) {
      _periods = data;
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  void loadPayslips(String employeeId) {
    _payslipSub?.cancel();
    _isLoading = true;
    notifyListeners();
    _payslipSub = _repository.getEmployeePayslips(employeeId).listen((data) {
      _payslips = data;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<void> selectPayslip(String id) async {
    _selectedPayslip = await _repository.getPayslipById(id);
    notifyListeners();
  }

  Future<String> generatePayslipPDF(String payslipId) async {
    return await _repository.generatePayslipPDF(payslipId);
  }

  @override
  void dispose() {
    _periodSub?.cancel();
    _payslipSub?.cancel();
    super.dispose();
  }
}
