import '../utils/firestore_helpers.dart';
class PayrollPeriodModel {
  final String id;
  final String month;
  final int year;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? paymentDate;
  final String status; // draft, processing, completed, closed
  final int employeeCount;
  final double totalSalary;
  final double totalDeductions;
  final double totalNetSalary;
  final DateTime createdAt;

  PayrollPeriodModel({
    required this.id,
    required this.month,
    required this.year,
    required this.startDate,
    required this.endDate,
    this.paymentDate,
    this.status = 'draft',
    this.employeeCount = 0,
    this.totalSalary = 0,
    this.totalDeductions = 0,
    this.totalNetSalary = 0,
    required this.createdAt,
  });

  factory PayrollPeriodModel.fromMap(Map<String, dynamic> map, String id) {
    return PayrollPeriodModel(
      id: id,
      month: map['month'] ?? '',
      year: map['year'] ?? DateTime.now().year,
      startDate: toDateTime(map['startDate']) ?? DateTime.now(),
      endDate: toDateTime(map['endDate']) ?? DateTime.now(),
      paymentDate: toDateTime(map['paymentDate']),
      status: map['status'] ?? 'draft',
      employeeCount: map['employeeCount'] ?? 0,
      totalSalary: (map['totalSalary'] as num?)?.toDouble() ?? 0,
      totalDeductions: (map['totalDeductions'] as num?)?.toDouble() ?? 0,
      totalNetSalary: (map['totalNetSalary'] as num?)?.toDouble() ?? 0,
      createdAt: toDateTime(map['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'month': month,
    'year': year,
    'startDate': startDate,
    'endDate': endDate,
    'paymentDate': paymentDate,
    'status': status,
    'employeeCount': employeeCount,
    'totalSalary': totalSalary,
    'totalDeductions': totalDeductions,
    'totalNetSalary': totalNetSalary,
    'createdAt': createdAt,
  };
}

class PayslipModel {
  final String id;
  final String employeeId;
  final String periodId;
  final double baseSalary;
  final double overtimePay;
  final Map<String, double> allowances;
  final Map<String, double> deductions;
  final double grossSalary;
  final double pph21;
  final double bpjsKesehatan;
  final double bpjsKetenagakerjaan;
  final double loanDeduction;
  final double netSalary;
  final String status; // draft, approved, paid
  final DateTime? paidAt;
  final String? paymentMethod;
  final DateTime createdAt;

  PayslipModel({
    required this.id,
    required this.employeeId,
    required this.periodId,
    this.baseSalary = 0,
    this.overtimePay = 0,
    this.allowances = const {},
    this.deductions = const {},
    this.grossSalary = 0,
    this.pph21 = 0,
    this.bpjsKesehatan = 0,
    this.bpjsKetenagakerjaan = 0,
    this.loanDeduction = 0,
    this.netSalary = 0,
    this.status = 'draft',
    this.paidAt,
    this.paymentMethod,
    required this.createdAt,
  });

  factory PayslipModel.fromMap(Map<String, dynamic> map, String id) {
    return PayslipModel(
      id: id,
      employeeId: map['employeeId'] ?? '',
      periodId: map['periodId'] ?? '',
      baseSalary: (map['baseSalary'] as num?)?.toDouble() ?? 0,
      overtimePay: (map['overtimePay'] as num?)?.toDouble() ?? 0,
      allowances: Map<String, double>.from(map['allowances'] ?? {}),
      deductions: Map<String, double>.from(map['deductions'] ?? {}),
      grossSalary: (map['grossSalary'] as num?)?.toDouble() ?? 0,
      pph21: (map['pph21'] as num?)?.toDouble() ?? 0,
      bpjsKesehatan: (map['bpjsKesehatan'] as num?)?.toDouble() ?? 0,
      bpjsKetenagakerjaan: (map['bpjsKetenagakerjaan'] as num?)?.toDouble() ?? 0,
      loanDeduction: (map['loanDeduction'] as num?)?.toDouble() ?? 0,
      netSalary: (map['netSalary'] as num?)?.toDouble() ?? 0,
      status: map['status'] ?? 'draft',
      paidAt: toDateTime(map['paidAt']),
      paymentMethod: map['paymentMethod'],
      createdAt: toDateTime(map['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'employeeId': employeeId,
    'periodId': periodId,
    'baseSalary': baseSalary,
    'overtimePay': overtimePay,
    'allowances': allowances,
    'deductions': deductions,
    'grossSalary': grossSalary,
    'pph21': pph21,
    'bpjsKesehatan': bpjsKesehatan,
    'bpjsKetenagakerjaan': bpjsKetenagakerjaan,
    'loanDeduction': loanDeduction,
    'netSalary': netSalary,
    'status': status,
    'paidAt': paidAt,
    'paymentMethod': paymentMethod,
    'createdAt': createdAt,
  };
}
