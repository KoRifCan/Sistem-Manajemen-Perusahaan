import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../../core/utils/helpers.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    final user = auth.user;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Silakan login')));
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: theme.colorScheme.primary,
                      child: Text(
                        Helpers.getInitials(user.name),
                        style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(user.name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Text(user.email, style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user.role.replaceAll('_', ' ').toUpperCase(),
                        style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit Profil'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.document_scanner),
                    title: const Text('Dokumen Saya'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go('/documents'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.receipt_long),
                    title: const Text('Slip Gaji'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go('/payroll'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Pengaturan'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go('/settings'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
