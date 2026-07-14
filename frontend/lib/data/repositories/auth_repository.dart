import 'package:firebase_auth/firebase_auth.dart';
import '../datasources/firebase_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  User? get currentUser => FirebaseService.auth.currentUser;

  Stream<User?> get authStateChanges => FirebaseService.auth.authStateChanges();

  Future<UserModel?> login(String email, String password) async {
    final result = await FirebaseService.auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (result.user == null) return null;
    final doc = await FirebaseService.users.doc(result.user!.uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Future<UserModel?> register({
    required String email,
    required String password,
    required String name,
    String role = 'staff',
  }) async {
    final result = await FirebaseService.auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (result.user == null) return null;
    final user = UserModel(
      uid: result.user!.uid,
      email: email,
      name: name,
      role: role,
      createdAt: DateTime.now(),
    );
    await FirebaseService.users.doc(result.user!.uid).set(user.toMap());
    return user;
  }

  Stream<UserModel?> getCurrentUserData() {
    final user = currentUser;
    if (user == null) return Stream.value(null);
    return FirebaseService.users.doc(user.uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    });
  }

  Future<void> logout() async {
    await FirebaseService.auth.signOut();
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    await FirebaseService.users.doc(userId).update(data);
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    final user = currentUser;
    if (user == null || user.email == null) throw Exception('User not found');
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  Future<void> resetPassword(String email) async {
    await FirebaseService.auth.sendPasswordResetEmail(email: email);
  }
}
