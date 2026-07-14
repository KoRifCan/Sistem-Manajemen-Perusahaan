import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/datasources/firebase_service.dart';

class OrganizationProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _departments = [];
  List<Map<String, dynamic>> _positions = [];
  List<Map<String, dynamic>> _grades = [];
  Map<String, dynamic>? _companyProfile;
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _deptSub;
  StreamSubscription? _positionSub;
  StreamSubscription? _gradeSub;
  StreamSubscription? _profileSub;

  List<Map<String, dynamic>> get departments => _departments;
  List<Map<String, dynamic>> get positions => _positions;
  List<Map<String, dynamic>> get grades => _grades;
  Map<String, dynamic>? get companyProfile => _companyProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void loadData() {
    _deptSub?.cancel();
    _positionSub?.cancel();
    _gradeSub?.cancel();
    _profileSub?.cancel();
    _loadDepartments();
    _loadPositions();
    _loadGrades();
    _loadCompanyProfile();
  }

  void _loadDepartments() {
    _deptSub = FirebaseService.departments.orderBy('name').snapshots().listen((snapshot) {
      _departments = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  void _loadPositions() {
    _positionSub = FirebaseService.positions.orderBy('name').snapshots().listen((snapshot) {
      _positions = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  void _loadGrades() {
    _gradeSub = FirebaseService.positionGrades.orderBy('level').snapshots().listen((snapshot) {
      _grades = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  void _loadCompanyProfile() {
    _profileSub = FirebaseService.company.doc('profile').snapshots().listen((doc) {
      if (doc.exists) {
        _companyProfile = {'id': doc.id, ...doc.data() as Map<String, dynamic>};
        notifyListeners();
      }
    }, onError: (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<void> addDepartment(String name, String? parentId, {String? code}) async {
    await FirebaseService.departments.add({
      'name': name,
      'parentId': parentId,
      'code': code,
      'createdAt': DateTime.now(),
    });
  }

  Future<void> updateDepartment(String id, Map<String, dynamic> data) async {
    await FirebaseService.departments.doc(id).update(data);
  }

  Future<void> addPosition(Map<String, dynamic> data) async {
    data['createdAt'] = DateTime.now();
    await FirebaseService.positions.add(data);
  }

  Future<void> updateCompanyProfile(Map<String, dynamic> data) async {
    await FirebaseService.company.doc('profile').set(data, SetOptions(merge: true));
  }

  @override
  void dispose() {
    _deptSub?.cancel();
    _positionSub?.cancel();
    _gradeSub?.cancel();
    _profileSub?.cancel();
    super.dispose();
  }
}
