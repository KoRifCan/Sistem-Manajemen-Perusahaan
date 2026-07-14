import '../utils/firestore_helpers.dart';
class LeaveModel {
  final String id;
  final String employeeId;
  final String type; // Cuti Tahunan, Cuti Sakit, dll
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final String reason;
  final String? attachmentUrl;
  final String status; // pending, approved, rejected, cancelled
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? rejectReason;
  final String? contactDuringLeave;
  final DateTime createdAt;

  LeaveModel({
    required this.id,
    required this.employeeId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.reason,
    this.attachmentUrl,
    this.status = 'pending',
    this.approvedBy,
    this.approvedAt,
    this.rejectReason,
    this.contactDuringLeave,
    required this.createdAt,
  });

  factory LeaveModel.fromMap(Map<String, dynamic> map, String id) {
    return LeaveModel(
      id: id,
      employeeId: map['employeeId'] ?? '',
      type: map['type'] ?? '',
      startDate: toDateTime(map['startDate']) ?? DateTime.now(),
      endDate: toDateTime(map['endDate']) ?? DateTime.now(),
      totalDays: map['totalDays'] ?? 0,
      reason: map['reason'] ?? '',
      attachmentUrl: map['attachmentUrl'],
      status: map['status'] ?? 'pending',
      approvedBy: map['approvedBy'],
      approvedAt: toDateTime(map['approvedAt']),
      rejectReason: map['rejectReason'],
      contactDuringLeave: map['contactDuringLeave'],
      createdAt: toDateTime(map['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'employeeId': employeeId,
    'type': type,
    'startDate': startDate,
    'endDate': endDate,
    'totalDays': totalDays,
    'reason': reason,
    'attachmentUrl': attachmentUrl,
    'status': status,
    'approvedBy': approvedBy,
    'approvedAt': approvedAt,
    'rejectReason': rejectReason,
    'contactDuringLeave': contactDuringLeave,
    'createdAt': createdAt,
  };
}
