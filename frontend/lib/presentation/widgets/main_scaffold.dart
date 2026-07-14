import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/settings_provider.dart';
import 'company_logo.dart';
import 'theme_toggle.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final notif = context.watch<NotificationProvider>();
    final isDark = context.watch<SettingsProvider>().isDark;
    final role = auth.user?.role;
    final navItems = _navItemsForRole(role);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 768;
        return isWide ? _buildDesktop(context, auth, notif, isDark, navItems) : _buildMobile(context, auth, notif, isDark, navItems);
      },
    );
  }

  Widget _buildDesktop(BuildContext context, AuthProvider auth, NotificationProvider notif, bool isDark, List<_NavItem> navItems) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _getSelectedIndex(context, navItems),
            onDestinationSelected: (index) => _onNavigate(context, index, navItems),
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const CompanyLogo(size: 48, showText: false),
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PremiumThemeToggle(size: 32),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () => auth.logout(),
                    tooltip: 'Logout',
                  ),
                ],
              ),
            ),
            destinations: navItems.map((item) => NavigationRailDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.activeIcon),
              label: Text(item.label, style: const TextStyle(fontSize: 11)),
            )).toList(),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobile(BuildContext context, AuthProvider auth, NotificationProvider notif, bool isDark, List<_NavItem> navItems) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1a73e8), Color(0xFF0d47a1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(Icons.business_center, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(_getTitle(context, navItems)),
          ],
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          PremiumThemeToggle(size: 36),
          const SizedBox(width: 4),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => context.go('/notifications'),
              ),
              if (notif.unreadCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.red, Colors.orange]),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${notif.unreadCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
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
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF0d47a1), const Color(0xFF1a1a2e)]
                      : [const Color(0xFF1a73e8), const Color(0xFF0d47a1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Text(
                                auth.user?.name.isNotEmpty == true ? auth.user!.name[0].toUpperCase() : '?',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(auth.user?.name ?? 'Pengguna', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                                Text(auth.user?.email ?? '', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Icon(Icons.business_center, size: 16, color: Colors.white70),
                          SizedBox(width: 6),
                          Text('PT. KoRifCan', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...navItems.map((item) => ListTile(
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _getSelectedIndex(context, navItems) == navItems.indexOf(item)
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item.icon,
                  color: _getSelectedIndex(context, navItems) == navItems.indexOf(item)
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ),
              title: Text(
                item.label,
                style: TextStyle(
                  fontWeight: _getSelectedIndex(context, navItems) == navItems.indexOf(item) ? FontWeight.w600 : FontWeight.normal,
                  color: _getSelectedIndex(context, navItems) == navItems.indexOf(item)
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ),
              selected: _getSelectedIndex(context, navItems) == navItems.indexOf(item),
              onTap: () {
                Navigator.pop(context);
                _onNavigate(context, navItems.indexOf(item), navItems);
              },
            )),
            const Divider(),
            ListTile(
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.1),
                ),
                child: const Icon(Icons.settings),
              ),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
                context.go('/settings');
              },
            ),
            ListTile(
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red.withOpacity(0.1),
                ),
                child: const Icon(Icons.logout, color: Colors.red),
              ),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
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
      bottomNavigationBar: _buildBottomNav(context, navItems),
    );
  }

  Widget _buildBottomNav(BuildContext context, List<_NavItem> navItems) {
    final selected = _getSelectedIndex(context, navItems);
    final mobileItems = navItems.where((item) => item.showBottomNav).toList();
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerTheme.color ?? Colors.grey.shade200, width: 0.5),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: mobileItems.indexOf(navItems[selected]),
        onTap: (index) {
          final item = navItems.where((i) => i.showBottomNav).toList()[index];
          _onNavigate(context, navItems.indexOf(item), navItems);
        },
        items: mobileItems.map((item) => BottomNavigationBarItem(
          icon: Icon(item.icon),
          activeIcon: Icon(item.activeIcon),
          label: item.label,
        )).toList(),
      ),
    );
  }

  int _getSelectedIndex(BuildContext context, List<_NavItem> navItems) {
    final location = GoRouterState.of(context).uri.toString();
    final idx = navItems.indexWhere((item) => location.startsWith(item.path));
    return idx >= 0 ? idx : 0;
  }

  String _getTitle(BuildContext context, List<_NavItem> navItems) {
    final location = GoRouterState.of(context).uri.toString();
    final item = navItems.firstWhere((item) => location.startsWith(item.path), orElse: () => navItems[0]);
    return item.label;
  }

  void _onNavigate(BuildContext context, int index, List<_NavItem> navItems) {
    if (index >= 0 && index < navItems.length) {
      context.go(navItems[index].path);
    }
  }
}

class _NavItem {
  final String label;
  final String path;
  final IconData icon;
  final IconData activeIcon;
  final bool showBottomNav;
  final List<String>? roles;

  const _NavItem({
    required this.label,
    required this.path,
    required this.icon,
    required this.activeIcon,
    this.showBottomNav = true,
    this.roles,
  });

  bool canAccess(String? role) {
    if (roles == null) return true;
    if (role == null) return false;
    return roles!.contains(role);
  }
}

List<_NavItem> _navItemsForRole(String? role) {
  return _navItems.where((item) => item.canAccess(role)).toList();
}

const List<_NavItem> _navItems = [
  _NavItem(label: 'Dashboard', path: '/dashboard', icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard),
  _NavItem(label: 'Karyawan', path: '/employees', icon: Icons.people_outlined, activeIcon: Icons.people, roles: ['super_admin', 'director', 'manager', 'hr']),
  _NavItem(label: 'Absensi', path: '/attendance', icon: Icons.fingerprint_outlined, activeIcon: Icons.fingerprint, roles: ['super_admin', 'director', 'manager', 'hr', 'staff']),
  _NavItem(label: 'Cuti', path: '/leaves', icon: Icons.beach_access_outlined, activeIcon: Icons.beach_access, roles: ['super_admin', 'director', 'manager', 'hr', 'staff']),
  _NavItem(label: 'Payroll', path: '/payroll', icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet, roles: ['super_admin', 'director', 'hr', 'finance', 'staff']),
  _NavItem(label: 'Approval', path: '/approvals', icon: Icons.checklist_outlined, activeIcon: Icons.checklist, roles: ['super_admin', 'director', 'manager', 'hr', 'finance', 'staff']),
  _NavItem(label: 'Organisasi', path: '/organization', icon: Icons.account_tree_outlined, activeIcon: Icons.account_tree, roles: ['super_admin', 'hr']),
  _NavItem(label: 'Aset', path: '/assets', icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2, roles: ['super_admin', 'manager', 'staff']),
  _NavItem(label: 'Dokumen', path: '/documents', icon: Icons.folder_outlined, activeIcon: Icons.folder, roles: ['super_admin', 'manager', 'hr', 'staff']),
  _NavItem(label: 'Laporan', path: '/reports', icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart, showBottomNav: false, roles: ['super_admin', 'director', 'hr', 'finance']),
  _NavItem(label: 'Profile', path: '/profile', icon: Icons.person_outlined, activeIcon: Icons.person, showBottomNav: false),
];
