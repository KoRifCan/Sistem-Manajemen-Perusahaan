import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/datasources/firebase_service.dart';

class AssetProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _assets = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _loans = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _assetSub;
  StreamSubscription? _categorySub;
  StreamSubscription? _loanSub;

  List<Map<String, dynamic>> get assets => _assets;
  List<Map<String, dynamic>> get categories => _categories;
  List<Map<String, dynamic>> get loans => _loans;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void loadAssets() {
    _assetSub?.cancel();
    _assetSub = FirebaseService.assets.orderBy('name').snapshots().listen((snapshot) {
      _assets = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  void loadCategories() {
    _categorySub?.cancel();
    _categorySub = FirebaseService.assetCategories.orderBy('name').snapshots().listen((snapshot) {
      _categories = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  void loadLoans() {
    _loanSub?.cancel();
    _loanSub = FirebaseService.assetLoans.orderBy('createdAt', descending: true).snapshots().listen((snapshot) {
      _loans = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
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

  Future<bool> borrowAsset(String assetId, String employeeId, String employeeName) async {
    try {
      final batch = FirebaseService.firestore.batch();
      final loanRef = FirebaseService.assetLoans.doc();
      batch.set(loanRef, {
        'assetId': assetId,
        'employeeId': employeeId,
        'employeeName': employeeName,
        'borrowDate': DateTime.now(),
        'status': 'Dipinjam',
        'createdAt': DateTime.now(),
      });
      batch.update(FirebaseService.assets.doc(assetId), {'status': 'Dipinjam'});
      await batch.commit();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> returnAsset(String loanId, String assetId) async {
    try {
      final batch = FirebaseService.firestore.batch();
      batch.update(FirebaseService.assetLoans.doc(loanId), {
        'returnDate': DateTime.now(),
        'status': 'Dikembalikan',
      });
      batch.update(FirebaseService.assets.doc(assetId), {'status': 'Tersedia'});
      await batch.commit();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _assetSub?.cancel();
    _categorySub?.cancel();
    _loanSub?.cancel();
    super.dispose();
  }
}
