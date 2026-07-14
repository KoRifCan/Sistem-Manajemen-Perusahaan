import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/datasources/firebase_service.dart';

class DocumentProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _documents = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get documents => _documents;
  bool get isLoading => _isLoading;

  void loadDocuments(String employeeId) {
    _isLoading = true;
    notifyListeners();
    FirebaseService.documents
        .where('employeeId', isEqualTo: employeeId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _documents = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<String?> uploadDocument({
    required String employeeId,
    required String name,
    required String category,
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      final url = await FirebaseService.uploadFile('documents/$employeeId', fileName, bytes);
      await FirebaseService.documents.add({
        'employeeId': employeeId,
        'name': name,
        'category': category,
        'url': url,
        'fileName': fileName,
        'createdAt': DateTime.now(),
      });
      return url;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteDocument(String id) async {
    try {
      await FirebaseService.documents.doc(id).delete();
      return true;
    } catch (_) {
      return false;
    }
  }
}
