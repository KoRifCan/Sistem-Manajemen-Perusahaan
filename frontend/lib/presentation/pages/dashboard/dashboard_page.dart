import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/approval_provider.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/company_logo.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    if (auth.user != null) {
      context.read<ApprovalProvider>().loadPendingApprovals(auth.user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final pendingApprovals = context.watch<ApprovalProvider>().pendingApprovals;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width > 768;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreeting(context, auth, isDark),
          const SizedBox(height: 20),
          _buildQuickStats(context, isWide),
          const SizedBox(height: 20),
          _buildPendingApprovals(context, pendingApprovals, isDark),
          if (isWide) ...[
            const SizedBox(height: 20),
            _buildQuickActions(context, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildGreeting(BuildContext context, AuthProvider auth, bool isDark) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0d47a1), const Color(0xFF1a1a2e)]
              : [const Color(0xFF1a73e8), const Color(0xFF0d47a1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1a73e8).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selamat datang,', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(
                      auth.user?.name ?? 'Pengguna',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const CompanyLogo(size: 48, showText: false),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.white.withOpacity(0.7)),
              const SizedBox(width: 6),
              Text(Helpers.formatDate(DateTime.now()), style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.business_center, size: 12, color: Colors.white.withOpacity(0.7)),
                    const SizedBox(width: 4),
                    Text('PT. KoRifCan', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, bool isWide) {
    final stats = [
      _StatData(Icons.people_alt, 'Total Karyawan', '245', AppTheme.cardColors[0]),
      _StatData(Icons.fingerprint, 'Hadir Hari Ini', '210', AppTheme.cardColors[1]),
      _StatData(Icons.beach_access, 'Cuti Hari Ini', '12', AppTheme.cardColors[2]),
      _StatData(Icons.monetization_on, 'Gaji Bulan Ini', 'Rp 1,2 M', AppTheme.cardColors[3]),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Ringkasan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const Spacer(),
            Text('Bulan ini', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 12),
        if (isWide)
          Row(
            children: stats.map((s) => Expanded(child: _buildStatCard(s, context))).toList(),
          )
        else
          ...stats.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildStatCard(s, context),
          )),
      ],
    );
  }

  Widget _buildStatCard(_StatData stat, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width > 768 ? 12 : 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16213e) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [stat.color.withOpacity(0.15), stat.color.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(stat.icon, color: stat.color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stat.title, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                const SizedBox(height: 4),
                Text(stat.value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
          ),
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [stat.color.withOpacity(0.5), stat.color.withOpacity(0.1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingApprovals(BuildContext context, List<dynamic> pendingApprovals, bool isDark) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16213e) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.checklist, color: AppTheme.accentOrange, size: 20),
              ),
              const SizedBox(width: 10),
              Text('Approval Pending', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const Spacer(),
              TextButton(
                onPressed: () => context.go('/approvals'),
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (pendingApprovals.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(Icons.check_circle_outline, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text('Tidak ada approval pending', style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            )
          else
            ...pendingApprovals.take(5).map((approval) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.03) : Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Icon(Icons.checklist, color: theme.colorScheme.primary, size: 20),
                ),
                title: Text(approval.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: Text('${approval.requesterName} - ${approval.type}', style: const TextStyle(fontSize: 12)),
                trailing: const Icon(Icons.chevron_right, size: 20),
                onTap: () => context.go('/approvals'),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16213e) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.flash_on, color: AppTheme.primaryBlue, size: 20),
              ),
              const SizedBox(width: 10),
              Text('Aksi Cepat', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildActionButton(context, Icons.person_add, 'Tambah\nKaryawan', '/employees/add', AppTheme.cardColors[0])),
              const SizedBox(width: 12),
              Expanded(child: _buildActionButton(context, Icons.beach_access, 'Ajukan\nCuti', '/leaves/add', AppTheme.cardColors[2])),
              const SizedBox(width: 12),
              Expanded(child: _buildActionButton(context, Icons.fingerprint, 'Absen\nSekarang', '/attendance', AppTheme.cardColors[1])),
              const SizedBox(width: 12),
              Expanded(child: _buildActionButton(context, Icons.inventory_2, 'Aset\nBaru', '/assets', AppTheme.cardColors[5])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, String route, Color color) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.go(route),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.02)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.15)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatData {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  const _StatData(this.icon, this.title, this.value, this.color);
}
