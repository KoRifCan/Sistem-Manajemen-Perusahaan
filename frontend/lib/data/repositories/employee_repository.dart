import 'package:cloud_firestore/cloud_firestore.dart';
import '../datasources/firebase_service.dart';
import '../models/employee_model.dart';

class EmployeeRepository {
  Stream<List<EmployeeModel>> getAllEmployees({String? departmentId, bool? active}) {
    Query query = FirebaseService.employees.orderBy('name');
    if (departmentId != null) query = query.where('departmentId', isEqualTo: departmentId);
    if (active != null) query = query.where('isActive', isEqualTo: active);
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return EmployeeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<EmployeeModel?> getEmployeeById(String id) async {
    final doc = await FirebaseService.employees.doc(id).get();
    if (!doc.exists) return null;
    return EmployeeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Future<void> addEmployee(EmployeeModel employee) async {
    final doc = await FirebaseService.employees.add(employee.toMap());
    await doc.update({'id': doc.id});
  }

  Future<void> updateEmployee(String id, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now();
    await FirebaseService.employees.doc(id).update(data);
  }

  Future<void> deleteEmployee(String id) async {
    await FirebaseService.employees.doc(id).update({'isActive': false, 'updatedAt': DateTime.now()});
  }

  Future<List<Map<String, dynamic>>> getDepartments() async {
    final snapshot = await FirebaseService.departments.orderBy('name').get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
  }

  Future<List<Map<String, dynamic>>> getPositions() async {
    final snapshot = await FirebaseService.positions.orderBy('name').get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
  }
}
