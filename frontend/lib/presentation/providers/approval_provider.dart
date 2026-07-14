import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/approval_model.dart';
import '../../data/datasources/firebase_service.dart';

class ApprovalProvider extends ChangeNotifier {
  List<ApprovalRequestModel> _pendingApprovals = [];
  List<ApprovalRequestModel> _myRequests = [];
  List<ApprovalRequestModel> _history = [];
  bool _isLoading = false;
  String? _error;

  List<ApprovalRequestModel> get pendingApprovals => _pendingApprovals;
  List<ApprovalRequestModel> get myRequests => _myRequests;
  List<ApprovalRequestModel> get history => _history;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void loadPendingApprovals(String approverId) {
    FirebaseService.approvals
        .where('status', isEqualTo: 'pending')
        .where('steps', arrayContains: {'approverId': approverId, 'status': 'pending'})
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _pendingApprovals = snapshot.docs.map((doc) {
        return ApprovalRequestModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      notifyListeners();
    });
  }

  void loadMyRequests(String requesterId) {
    FirebaseService.approvals
        .where('requesterId', isEqualTo: requesterId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _myRequests = snapshot.docs.map((doc) {
        return ApprovalRequestModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      notifyListeners();
    });
  }

  Future<bool> approve(String approvalId, String approverId, {String? note}) async {
    try {
      await FirebaseService.firestore
          .collection('approvals')
          .doc(approvalId)
          .update({
        'status': 'approved',
        'approvedBy': approverId,
        'approvedAt': DateTime.now(),
        'note': note,
      });
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> reject(String approvalId, String approverId, String reason) async {
    try {
      await FirebaseService.firestore
          .collection('approvals')
          .doc(approvalId)
          .update({
        'status': 'rejected',
        'approvedBy': approverId,
        'approvedAt': DateTime.now(),
        'rejectReason': reason,
      });
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> submitApproval(ApprovalRequestModel request) async {
    await FirebaseService.approvals.add(request.toMap());
  }
}
