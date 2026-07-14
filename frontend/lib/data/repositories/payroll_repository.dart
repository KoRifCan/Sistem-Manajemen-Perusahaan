import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../datasources/firebase_service.dart';
import '../models/payroll_model.dart';

class PayrollRepository {
  Stream<List<PayrollPeriodModel>> getPayrollPeriods() {
    return FirebaseService.payrollPeriods
        .orderBy('year', descending: true)
        .orderBy('month', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return PayrollPeriodModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
            }).toList());
  }

  Future<List<PayslipModel>> getEmployeePayslips(String employeeId) async {
    final snapshot = await FirebaseService.payslips
        .where('employeeId', isEqualTo: employeeId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) {
      return PayslipModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<PayslipModel?> getPayslipById(String id) async {
    final doc = await FirebaseService.payslips.doc(id).get();
    if (!doc.exists) return null;
    return PayslipModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Future<void> createPayrollPeriod(PayrollPeriodModel period) async {
    await FirebaseService.payrollPeriods.add(period.toMap());
  }

  Future<void> processPayroll(String periodId) async {
    await FirebaseService.payrollPeriods.doc(periodId).update({'status': 'processing'});
  }

  Future<List<Map<String, dynamic>>> getSalaryComponents() async {
    final snapshot = await FirebaseService.salaryComponents.orderBy('name').get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
  }

  Future<String> generatePayslipPDF(String payslipId) async {
    final function = FirebaseFunctions.instance.httpsCallable('generatePayslipPDF');
    final result = await function.call({'payslipId': payslipId});
    return result.data['url'];
  }
}
