class AttendanceModel {
  final String id;
  final String employeeId;
  final DateTime date;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String? checkInPhoto;
  final String? checkOutPhoto;
  final double? checkInLat;
  final double? checkInLng;
  final double? checkOutLat;
  final double? checkOutLng;
  final String? status; // Hadir, Terlambat, Izin, Sakit, Cuti, Alpha
  final String? note;
  final bool isLate;
  final bool isEarlyLeave;
  final int? lateMinutes;
  final int? earlyLeaveMinutes;
  final int? overtimeMinutes;
  final String? approvedBy;

  AttendanceModel({
    required this.id,
    required this.employeeId,
    required this.date,
    this.checkIn,
    this.checkOut,
    this.checkInPhoto,
    this.checkOutPhoto,
    this.checkInLat,
    this.checkInLng,
    this.checkOutLat,
    this.checkOutLng,
    this.status,
    this.note,
    this.isLate = false,
    this.isEarlyLeave = false,
    this.lateMinutes,
    this.earlyLeaveMinutes,
    this.overtimeMinutes,
    this.approvedBy,
  });

  factory AttendanceModel.fromMap(Map<String, dynamic> map, String id) {
    return AttendanceModel(
      id: id,
      employeeId: map['employeeId'] ?? '',
      date: (map['date'] as DateTime?) ?? DateTime.now(),
      checkIn: map['checkIn'] as DateTime?,
      checkOut: map['checkOut'] as DateTime?,
      checkInPhoto: map['checkInPhoto'],
      checkOutPhoto: map['checkOutPhoto'],
      checkInLat: (map['checkInLat'] as num?)?.toDouble(),
      checkInLng: (map['checkInLng'] as num?)?.toDouble(),
      checkOutLat: (map['checkOutLat'] as num?)?.toDouble(),
      checkOutLng: (map['checkOutLng'] as num?)?.toDouble(),
      status: map['status'],
      note: map['note'],
      isLate: map['isLate'] ?? false,
      isEarlyLeave: map['isEarlyLeave'] ?? false,
      lateMinutes: (map['lateMinutes'] as num?)?.toInt(),
      earlyLeaveMinutes: (map['earlyLeaveMinutes'] as num?)?.toInt(),
      overtimeMinutes: (map['overtimeMinutes'] as num?)?.toInt(),
      approvedBy: map['approvedBy'],
    );
  }

  Map<String, dynamic> toMap() => {
    'employeeId': employeeId,
    'date': date,
    'checkIn': checkIn,
    'checkOut': checkOut,
    'checkInPhoto': checkInPhoto,
    'checkOutPhoto': checkOutPhoto,
    'checkInLat': checkInLat,
    'checkInLng': checkInLng,
    'checkOutLat': checkOutLat,
    'checkOutLng': checkOutLng,
    'status': status,
    'note': note,
    'isLate': isLate,
    'isEarlyLeave': isEarlyLeave,
    'lateMinutes': lateMinutes,
    'earlyLeaveMinutes': earlyLeaveMinutes,
    'overtimeMinutes': overtimeMinutes,
    'approvedBy': approvedBy,
  };
}
