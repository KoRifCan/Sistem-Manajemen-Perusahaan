import 'package:cloud_firestore/cloud_firestore.dart';
import '../datasources/firebase_service.dart';
import '../models/leave_model.dart';

class LeaveRepository {
  Stream<List<LeaveModel>> getEmployeeLeaves(String employeeId) {
    return FirebaseService.leaves
        .where('employeeId', isEqualTo: employeeId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return LeaveModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
            }).toList());
  }

  Stream<List<LeaveModel>> getPendingLeaves(String approverId) {
    return FirebaseService.leaves
        .where('status', isEqualTo: 'pending')
        .where('approvedBy', isEqualTo: approverId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return LeaveModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
            }).toList());
  }

  Future<void> submitLeave(LeaveModel leave) async {
    await FirebaseService.leaves.add(leave.toMap());
  }

  Future<void> approveLeave(String id, String approverId) async {
    await FirebaseService.leaves.doc(id).update({
      'status': 'approved',
      'approvedBy': approverId,
      'approvedAt': DateTime.now(),
    });
  }

  Future<void> rejectLeave(String id, String approverId, String reason) async {
    await FirebaseService.leaves.doc(id).update({
      'status': 'rejected',
      'approvedBy': approverId,
      'approvedAt': DateTime.now(),
      'rejectReason': reason,
    });
  }

  Future<void> cancelLeave(String id) async {
    await FirebaseService.leaves.doc(id).update({'status': 'cancelled'});
  }

  Future<int> getLeaveBalance(String employeeId, String type) async {
    final doc = await FirebaseService.leaveBalances
        .where('employeeId', isEqualTo: employeeId)
        .where('type', isEqualTo: type)
        .get();
    if (doc.docs.isEmpty) return 0;
    return (doc.docs.first.data() as Map<String, dynamic>)['balance'] ?? 0;
  }
}
