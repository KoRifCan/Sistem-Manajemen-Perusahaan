import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Collections
  static CollectionReference get users => firestore.collection('users');
  static CollectionReference get employees => firestore.collection('employees');
  static CollectionReference get departments => firestore.collection('departments');
  static CollectionReference get positions => firestore.collection('positions');
  static CollectionReference get positionGrades => firestore.collection('position_grades');
  static CollectionReference get attendance => firestore.collection('attendance');
  static CollectionReference get leaves => firestore.collection('leaves');
  static CollectionReference get leaveBalances => firestore.collection('leave_balances');
  static CollectionReference get leaveTypes => firestore.collection('leave_types');
  static CollectionReference get permissions => firestore.collection('permissions');
  static CollectionReference get overtimes => firestore.collection('overtimes');
  static CollectionReference get businessTrips => firestore.collection('business_trips');
  static CollectionReference get payrollPeriods => firestore.collection('payroll_periods');
  static CollectionReference get payslips => firestore.collection('payslips');
  static CollectionReference get salaryComponents => firestore.collection('salary_components');
  static CollectionReference get taxRecords => firestore.collection('tax_records');
  static CollectionReference get bpjsRecords => firestore.collection('bpjs_records');
  static CollectionReference get loans => firestore.collection('loans');
  static CollectionReference get thrRecords => firestore.collection('thr_records');
  static CollectionReference get approvals => firestore.collection('approvals');
  static CollectionReference get assets => firestore.collection('assets');
  static CollectionReference get assetCategories => firestore.collection('asset_categories');
  static CollectionReference get assetLoans => firestore.collection('asset_loans');
  static CollectionReference get documents => firestore.collection('documents');
  static CollectionReference get documentCategories => firestore.collection('document_categories');
  static CollectionReference get helpTickets => firestore.collection('help_tickets');
  static CollectionReference get notifications => firestore.collection('notifications');
  static CollectionReference get company => firestore.collection('company');
  static CollectionReference get auditLogs => firestore.collection('audit_logs');
  static CollectionReference get roles => firestore.collection('roles');
  static CollectionReference get permissions_col => firestore.collection('permissions');

  static Future<String> uploadFile(String path, String fileName, Uint8List bytes) async {
    final ref = storage.ref().child('$path/$fileName');
    await ref.putData(bytes);
    return await ref.getDownloadURL();
  }

  static Future<String> uploadImage(String path, String fileName, Uint8List bytes) async {
    final ref = storage.ref().child('$path/$fileName');
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    return await ref.getDownloadURL();
  }

  static Future<void> deleteFile(String url) async {
    try {
      final ref = storage.refFromURL(url);
      await ref.delete();
    } catch (_) {}
  }

  static Future<String?> getFCMToken() async {
    try {
      return await messaging.getToken();
    } catch (_) {
      return null;
    }
  }

  static Future<void> logAudit({
    required String userId,
    required String action,
    required String module,
    String? description,
    String? documentId,
  }) async {
    await auditLogs.add({
      'userId': userId,
      'action': action,
      'module': module,
      'description': description ?? '',
      'documentId': documentId,
      'timestamp': FieldValue.serverTimestamp(),
      'ipAddress': '',
      'device': '',
    });
  }
}
