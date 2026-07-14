import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/company_logo.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    final isDark = settings.isDark;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0d47a1), const Color(0xFF1a1a2e)]
                    : [const Color(0xFF1a73e8), const Color(0xFF0d47a1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: Text(
                    auth.user?.name.isNotEmpty == true ? auth.user!.name[0].toUpperCase() : '?',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(auth.user?.name ?? 'Pengguna', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                      Text(auth.user?.email ?? '', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSection(context, 'Tampilan', [
            _SettingItem(
              icon: isDark ? Icons.dark_mode : Icons.light_mode,
              title: 'Mode Gelap',
              subtitle: 'Ganti tema terang/gelap',
              trailing: Switch(
                value: settings.isDark,
                onChanged: (_) => settings.toggleTheme(),
                activeColor: theme.colorScheme.primary,
              ),
            ),
            _SettingItem(
              icon: Icons.language,
              title: 'Bahasa',
              subtitle: settings.locale == const Locale('id', 'ID') ? 'Indonesia' : 'English',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pilih Bahasa'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('Indonesia'),
                          leading: const Icon(Icons.check),
                          onTap: () {
                            settings.setLocale(const Locale('id', 'ID'));
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('English'),
                          leading: settings.locale == const Locale('en', 'US') ? const Icon(Icons.check) : null,
                          onTap: () {
                            settings.setLocale(const Locale('en', 'US'));
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection(context, 'Notifikasi', [
            _SettingItem(
              icon: Icons.notifications,
              title: 'Notifikasi Push',
              subtitle: 'Terima notifikasi di perangkat',
              trailing: Switch(
                value: settings.notificationsEnabled,
                onChanged: (_) => settings.toggleNotifications(),
                activeColor: theme.colorScheme.primary,
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection(context, 'Keamanan', [
            _SettingItem(
              icon: Icons.fingerprint,
              title: 'Biometric',
              subtitle: 'Buka aplikasi dengan sidik jari / wajah',
              trailing: Switch(
                value: settings.biometricEnabled,
                onChanged: (_) => settings.toggleBiometric(),
                activeColor: theme.colorScheme.primary,
              ),
            ),
            _SettingItem(
              icon: Icons.lock_outline,
              title: 'Ubah Password',
              onTap: () => _showChangePasswordDialog(context),
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection(context, 'Informasi', [
            _SettingItem(
              icon: Icons.info_outline,
              title: 'Versi Aplikasi',
              subtitle: '1.0.0',
            ),
          ]),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                auth.logout();
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Logout', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Center(
            child: Column(
              children: [
                CompanyLogo(size: 36),
                SizedBox(height: 8),
                Text('© 2024 PT. KoRifCan', style: TextStyle(fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<_SettingItem> items) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF16213e) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
            ),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  if (idx > 0)
                    Divider(height: 1, indent: 56, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                  item.onTap != null
                      ? ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(item.icon, size: 20, color: theme.colorScheme.primary),
                          ),
                          title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                          subtitle: item.subtitle != null ? Text(item.subtitle!, style: const TextStyle(fontSize: 12)) : null,
                          trailing: item.trailing ?? const Icon(Icons.chevron_right, size: 20),
                          onTap: item.onTap,
                        )
                      : ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(item.icon, size: 20, color: theme.colorScheme.primary),
                          ),
                          title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                          subtitle: item.subtitle != null ? Text(item.subtitle!, style: const TextStyle(fontSize: 12)) : null,
                          trailing: item.trailing,
                        ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

  void _showChangePasswordDialog(BuildContext context) {
    final currentPassword = TextEditingController();
    final newPassword = TextEditingController();
    final confirmPassword = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPassword,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password Saat Ini'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPassword,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password Baru'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPassword,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Konfirmasi Password Baru'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              if (newPassword.text != confirmPassword.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password baru tidak cocok')),
                );
                return;
              }
              if (newPassword.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password minimal 6 karakter')),
                );
                return;
              }
              if (currentPassword.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password saat ini wajib diisi')),
                );
                return;
              }
              Navigator.pop(context);
              try {
                await context.read<AuthProvider>().changePassword(
                  currentPassword.text,
                  newPassword.text,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password berhasil diubah')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal: ${e.toString().replaceAll("Exception: ", "")}')),
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

class _SettingItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });
}
