import 'package:flutter/material.dart';
import '../../data/models/attendance_model.dart';
import '../../data/repositories/attendance_repository.dart';
import '../../data/datasources/firebase_service.dart';

class AttendanceProvider extends ChangeNotifier {
  final AttendanceRepository _repository = AttendanceRepository();
  List<AttendanceModel> _todayAttendance = [];
  List<AttendanceModel> _employeeAttendance = [];
  bool _isLoading = false;
  bool _isCheckedIn = false;
  String? _currentAttendanceId;
  String? _error;

  List<AttendanceModel> get todayAttendance => _todayAttendance;
  List<AttendanceModel> get employeeAttendance => _employeeAttendance;
  bool get isLoading => _isLoading;
  bool get isCheckedIn => _isCheckedIn;
  String? get currentAttendanceId => _currentAttendanceId;
  String? get error => _error;

  void loadTodayAttendance() {
    _repository.getTodayAttendance().listen((data) {
      _todayAttendance = data;
      notifyListeners();
    });
  }

  void loadEmployeeAttendance(String employeeId) {
    _repository.getEmployeeAttendance(employeeId).listen((data) {
      _employeeAttendance = data;
      notifyListeners();
    });
  }

  Future<bool> checkIn({
    required String employeeId,
    required String photoUrl,
    required double lat,
    required double lng,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final attendance = AttendanceModel(
        id: '',
        employeeId: employeeId,
        date: DateTime.now(),
        checkIn: DateTime.now(),
        checkInPhoto: photoUrl,
        checkInLat: lat,
        checkInLng: lng,
        status: 'Hadir',
      );
      final docRef = await FirebaseService.attendance.add(attendance.toMap());
      _currentAttendanceId = docRef.id;
      _isCheckedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> checkOut(String attendanceId, String photoUrl, double lat, double lng) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.checkOut(attendanceId, {
        'checkOut': DateTime.now(),
        'checkOutPhoto': photoUrl,
        'checkOutLat': lat,
        'checkOutLng': lng,
      });
      _isCheckedIn = false;
      _currentAttendanceId = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
