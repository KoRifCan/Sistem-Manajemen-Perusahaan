import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/approval_provider.dart';
import '../../../core/utils/helpers.dart';

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
    final isWide = MediaQuery.of(context).size.width > 768;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Selamat datang, ${auth.user?.name ?? 'Pengguna'}', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('${Helpers.formatDate(DateTime.now())}', style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 24),
          isWide ? _buildWideCards(context) : _buildNarrowCards(context),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildCard(context, Icons.people, 'Total Karyawan', '245', Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildCard(context, Icons.beach_access, 'Cuti Hari Ini', '12', Colors.orange)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildCard(context, Icons.fingerprint, 'Hadir Hari Ini', '210', Colors.green)),
              const SizedBox(width: 12),
              Expanded(child: _buildCard(context, Icons.monetization_on, 'Gaji Bulan Ini', 'Rp 1,2 M', Colors.red)),
            ],
          ),
          const SizedBox(height: 24),
          Text('Approval Pending', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          if (pendingApprovals.isEmpty)
            Card(child: Padding(padding: const EdgeInsets.all(24), child: Center(child: Text('Tidak ada approval pending', style: TextStyle(color: Colors.grey.shade600)))))
          else
            ...pendingApprovals.take(5).map((approval) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Icon(Icons.checklist, color: theme.colorScheme.primary),
                ),
                title: Text(approval.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('${approval.requesterName} - ${approval.type}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/approvals'),
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideCards(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildCard(context, Icons.people, 'Total Karyawan', '245', Colors.blue)),
        const SizedBox(width: 12),
        Expanded(child: _buildCard(context, Icons.beach_access, 'Cuti Hari Ini', '12', Colors.orange)),
        const SizedBox(width: 12),
        Expanded(child: _buildCard(context, Icons.fingerprint, 'Hadir Hari Ini', '210', Colors.green)),
        const SizedBox(width: 12),
        Expanded(child: _buildCard(context, Icons.monetization_on, 'Gaji Bulan Ini', 'Rp 1,2 M', Colors.red)),
      ],
    );
  }

  Widget _buildNarrowCards(BuildContext context) {
    return const SizedBox.shrink();
  }
}
