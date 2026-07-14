import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/datasources/firebase_service.dart';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final String? referenceId;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.createdAt,
    this.referenceId,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map, String id) {
    return AppNotification(
      id: id,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      type: map['type'] ?? '',
      isRead: map['isRead'] ?? false,
      createdAt: (map['createdAt'] as DateTime?) ?? DateTime.now(),
      referenceId: map['referenceId'],
    );
  }
}

class NotificationProvider extends ChangeNotifier {
  List<AppNotification> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;

  void loadNotifications(String userId) {
    FirebaseService.notifications
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _notifications = snapshot.docs.map((doc) {
        return AppNotification.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      _unreadCount = _notifications.where((n) => !n.isRead).length;
      notifyListeners();
    });
  }

  Future<void> markAsRead(String id) async {
    await FirebaseService.notifications.doc(id).update({'isRead': true});
  }

  Future<void> markAllAsRead(String userId) async {
    final batch = FirebaseService.firestore.batch();
    final snapshot = await FirebaseService.notifications
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }
}
