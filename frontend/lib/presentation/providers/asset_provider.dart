import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/datasources/firebase_service.dart';

class AssetProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _assets = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _loans = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get assets => _assets;
  List<Map<String, dynamic>> get categories => _categories;
  List<Map<String, dynamic>> get loans => _loans;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void loadAssets() {
    FirebaseService.assets.orderBy('name').snapshots().listen((snapshot) {
      _assets = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
      notifyListeners();
    });
  }

  void loadCategories() {
    FirebaseService.assetCategories.orderBy('name').snapshots().listen((snapshot) {
      _categories = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
      notifyListeners();
    });
  }

  void loadLoans() {
    FirebaseService.assetLoans.orderBy('createdAt', descending: true).snapshots().listen((snapshot) {
      _loans = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
      notifyListeners();
    });
  }

  Future<void> addAsset(Map<String, dynamic> data) async {
    data['createdAt'] = DateTime.now();
    data['status'] = 'Tersedia';
    await FirebaseService.assets.add(data);
  }

  Future<void> updateAsset(String id, Map<String, dynamic> data) async {
    await FirebaseService.assets.doc(id).update(data);
  }

  Future<void> borrowAsset(String assetId, String employeeId, String employeeName) async {
    await FirebaseService.assetLoans.add({
      'assetId': assetId,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'borrowDate': DateTime.now(),
      'status': 'Dipinjam',
      'createdAt': DateTime.now(),
    });
    await FirebaseService.assets.doc(assetId).update({'status': 'Dipinjam'});
  }

  Future<void> returnAsset(String loanId, String assetId) async {
    await FirebaseService.assetLoans.doc(loanId).update({
      'returnDate': DateTime.now(),
      'status': 'Dikembalikan',
    });
    await FirebaseService.assets.doc(assetId).update({'status': 'Tersedia'});
  }
}
