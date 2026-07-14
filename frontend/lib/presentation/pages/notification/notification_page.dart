import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/theme/app_theme.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      context.read<NotificationProvider>().loadNotifications(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${provider.unreadCount} belum dibaca', style: TextStyle(color: AppTheme.textSecondary(context))),
                TextButton(
                  onPressed: () {
                    final user = context.read<AuthProvider>().user;
                    if (user != null) provider.markAllAsRead(user.uid);
                  },
                  child: const Text('Tandai semua dibaca'),
                ),
              ],
            ),
          ),
          Expanded(
            child: provider.notifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_none, size: 64, color: AppTheme.textHint(context)),
                        const SizedBox(height: 16),
                        Text('Tidak ada notifikasi', style: TextStyle(color: AppTheme.textSecondary(context))),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: provider.notifications.length,
                    itemBuilder: (context, index) {
                      final notif = provider.notifications[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                        color: notif.isRead ? null : theme.colorScheme.primary.withOpacity(0.05),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: notif.isRead ? AppTheme.textSecondary(context).withOpacity(0.1) : theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getNotifIcon(notif.type),
                              color: notif.isRead ? AppTheme.textSecondary(context) : theme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          title: Text(notif.title, style: TextStyle(fontWeight: notif.isRead ? FontWeight.normal : FontWeight.w600)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(notif.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text(Helpers.formatDateTime(notif.createdAt), style: TextStyle(color: AppTheme.textHint(context), fontSize: 11)),
                            ],
                          ),
                          trailing: notif.isRead ? null : Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(color: AppTheme.statusDefault(context), shape: BoxShape.circle),
                          ),
                          onTap: () => provider.markAsRead(notif.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  IconData _getNotifIcon(String type) {
    switch (type) {
      case 'leave': return Icons.beach_access;
      case 'approval': return Icons.checklist;
      case 'payroll': return Icons.monetization_on;
      case 'attendance': return Icons.fingerprint;
      default: return Icons.notifications;
    }
  }
}
