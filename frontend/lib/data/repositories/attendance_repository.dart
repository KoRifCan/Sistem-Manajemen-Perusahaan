import 'package:cloud_firestore/cloud_firestore.dart';
import '../datasources/firebase_service.dart';
import '../models/attendance_model.dart';

class AttendanceRepository {
  Stream<List<AttendanceModel>> getTodayAttendance() {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));
    return FirebaseService.attendance
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThan: end)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return AttendanceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
            }).toList());
  }

  Stream<List<AttendanceModel>> getEmployeeAttendance(String employeeId, {int months = 1}) {
    final start = DateTime.now().subtract(Duration(days: 30 * months));
    return FirebaseService.attendance
        .where('employeeId', isEqualTo: employeeId)
        .where('date', isGreaterThanOrEqualTo: start)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return AttendanceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
            }).toList());
  }

  Future<List<AttendanceModel>> getAttendanceReport({
    required DateTime start,
    required DateTime end,
    String? departmentId,
  }) async {
    Query query = FirebaseService.attendance
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .orderBy('date', descending: true);
    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      return AttendanceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> checkIn(AttendanceModel attendance) async {
    await FirebaseService.attendance.add(attendance.toMap());
  }

  Future<void> checkOut(String attendanceId, Map<String, dynamic> data) async {
    await FirebaseService.attendance.doc(attendanceId).update(data);
  }
}
