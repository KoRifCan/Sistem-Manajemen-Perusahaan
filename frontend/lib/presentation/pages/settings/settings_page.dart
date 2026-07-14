import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Tampilan', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Card(
            child: SwitchListTile(
              value: settings.isDark,
              onChanged: (_) => settings.toggleTheme(),
              title: const Text('Mode Gelap'),
              subtitle: const Text('Ganti tema terang/gelap'),
              secondary: Icon(settings.isDark ? Icons.dark_mode : Icons.light_mode),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Bahasa'),
              subtitle: Text(settings.locale == const Locale('id', 'ID') ? 'Indonesia' : 'English'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: const Text('Pilih Bahasa'),
                    children: [
                      SimpleDialogOption(
                        onPressed: () {
                          settings.setLocale(const Locale('id', 'ID'));
                          Navigator.pop(context);
                        },
                        child: const Text('Indonesia'),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          settings.setLocale(const Locale('en', 'US'));
                          Navigator.pop(context);
                        },
                        child: const Text('English'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Text('Notifikasi', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Card(
            child: SwitchListTile(
              value: settings.notificationsEnabled,
              onChanged: (_) => settings.toggleNotifications(),
              title: const Text('Notifikasi Push'),
              subtitle: const Text('Terima notifikasi di perangkat'),
              secondary: const Icon(Icons.notifications),
            ),
          ),
          const SizedBox(height: 24),
          Text('Keamanan', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Card(
            child: SwitchListTile(
              value: settings.biometricEnabled,
              onChanged: (_) => settings.toggleBiometric(),
              title: const Text('Biometric'),
              subtitle: const Text('Buka aplikasi dengan sidik jari / wajah'),
              secondary: const Icon(Icons.fingerprint),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Ubah Password'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 24),
          Text('Akun', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(auth.user?.name.isNotEmpty == true ? auth.user!.name[0].toUpperCase() : '?'),
              ),
              title: Text(auth.user?.name ?? 'Pengguna'),
              subtitle: Text(auth.user?.email ?? ''),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Versi Aplikasi'),
              subtitle: const Text('1.0.0'),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                auth.logout();
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Logout', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
