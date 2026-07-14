import '../utils/firestore_helpers.dart';
class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role;
  final String? employeeId;
  final String? departmentId;
  final String? positionId;
  final bool isActive;
  final String? photoUrl;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.employeeId,
    this.departmentId,
    this.positionId,
    this.isActive = true,
    this.photoUrl,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'staff',
      employeeId: map['employeeId'],
      departmentId: map['departmentId'],
      positionId: map['positionId'],
      isActive: map['isActive'] ?? true,
      photoUrl: map['photoUrl'],
      createdAt: toDateTime(map['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    'name': name,
    'role': role,
    'employeeId': employeeId,
    'departmentId': departmentId,
    'positionId': positionId,
    'isActive': isActive,
    'photoUrl': photoUrl,
    'createdAt': createdAt,
  };

  bool get isAdmin => role == 'super_admin';
  bool get isDirector => role == 'director';
  bool get isManager => role == 'manager';
  bool get isHR => role == 'hr';
  bool get isFinance => role == 'finance';
  bool get isStaff => role == 'staff';
}
