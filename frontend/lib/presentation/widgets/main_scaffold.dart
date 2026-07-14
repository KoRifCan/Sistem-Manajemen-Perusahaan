import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/settings_provider.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final notif = context.watch<NotificationProvider>();
    final isDark = context.watch<SettingsProvider>().isDark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 768;
        return isWide ? _buildDesktop(context, auth, notif) : _buildMobile(context, auth, notif);
      },
    );
  }

  Widget _buildDesktop(BuildContext context, AuthProvider auth, NotificationProvider notif) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _getSelectedIndex(context),
            onDestinationSelected: (index) => _onNavigate(context, index),
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Icon(Icons.business, size: 32, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 4),
                  Text('SMP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
            destinations: _navItems.map((item) => NavigationRailDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.activeIcon),
              label: Text(item.label, style: const TextStyle(fontSize: 11)),
            )).toList(),
            trailing: Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => auth.logout(),
                  tooltip: 'Logout',
                ),
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildMobile(BuildContext context, AuthProvider auth, NotificationProvider notif) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(context)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => context.go('/notifications'),
              ),
              if (notif.unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      '${notif.unreadCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Text(
                      auth.user?.name.isNotEmpty == true ? auth.user!.name[0].toUpperCase() : '?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(auth.user?.name ?? 'Pengguna', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(auth.user?.email ?? '', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            ..._navItems.map((item) => ListTile(
              leading: Icon(item.icon),
              title: Text(item.label),
              selected: _getSelectedIndex(context) == _navItems.indexOf(item),
              onTap: () {
                Navigator.pop(context);
                _onNavigate(context, _navItems.indexOf(item));
              },
            )),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
                context.go('/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                auth.logout();
                context.go('/login');
              },
            ),
          ],
        ),
      ),
      body: child,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final selected = _getSelectedIndex(context);
    final mobileItems = _navItems.where((item) => item.showBottomNav).toList();
    return BottomNavigationBar(
      currentIndex: mobileItems.indexOf(_navItems[selected]),
      onTap: (index) {
        final item = _navItems.where((i) => i.showBottomNav).toList()[index];
        _onNavigate(context, _navItems.indexOf(item));
      },
      items: mobileItems.map((item) => BottomNavigationBarItem(
        icon: Icon(item.icon),
        activeIcon: Icon(item.activeIcon),
        label: item.label,
      )).toList(),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final idx = _navItems.indexWhere((item) => location.startsWith(item.path));
    return idx >= 0 ? idx : 0;
  }

  String _getTitle(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final item = _navItems.firstWhere((item) => location.startsWith(item.path), orElse: () => _navItems[0]);
    return item.label;
  }

  void _onNavigate(BuildContext context, int index) {
    if (index >= 0 && index < _navItems.length) {
      context.go(_navItems[index].path);
    }
  }
}

class _NavItem {
  final String label;
  final String path;
  final IconData icon;
  final IconData activeIcon;
  final bool showBottomNav;

  const _NavItem({
    required this.label,
    required this.path,
    required this.icon,
    required this.activeIcon,
    this.showBottomNav = true,
  });
}

const List<_NavItem> _navItems = [
  _NavItem(label: 'Dashboard', path: '/dashboard', icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard),
  _NavItem(label: 'Karyawan', path: '/employees', icon: Icons.people_outlined, activeIcon: Icons.people),
  _NavItem(label: 'Absensi', path: '/attendance', icon: Icons.fingerprint_outlined, activeIcon: Icons.fingerprint),
  _NavItem(label: 'Cuti', path: '/leaves', icon: Icons.beach_access_outlined, activeIcon: Icons.beach_access),
  _NavItem(label: 'Payroll', path: '/payroll', icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet),
  _NavItem(label: 'Approval', path: '/approvals', icon: Icons.checklist_outlined, activeIcon: Icons.checklist),
  _NavItem(label: 'Organisasi', path: '/organization', icon: Icons.account_tree_outlined, activeIcon: Icons.account_tree),
  _NavItem(label: 'Aset', path: '/assets', icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2),
  _NavItem(label: 'Dokumen', path: '/documents', icon: Icons.folder_outlined, activeIcon: Icons.folder),
  _NavItem(label: 'Laporan', path: '/reports', icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart, showBottomNav: false),
  _NavItem(label: 'Profile', path: '/profile', icon: Icons.person_outlined, activeIcon: Icons.person, showBottomNav: false),
];
