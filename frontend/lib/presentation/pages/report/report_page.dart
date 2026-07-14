import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHR = context.read<AuthProvider>().user?.isHR ?? false;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Laporan', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _buildReportCard(context, Icons.people, 'Laporan Karyawan', 'Data karyawan per departemen', Colors.blue),
            _buildReportCard(context, Icons.fingerprint, 'Laporan Absensi', 'Rekap kehadiran per periode', Colors.green),
            _buildReportCard(context, Icons.beach_access, 'Laporan Cuti', 'Riwayat cuti karyawan', Colors.orange),
            _buildReportCard(context, Icons.monetization_on, 'Laporan Payroll', 'Summary gaji & PPh 21', Colors.red),
            _buildReportCard(context, Icons.inventory_2, 'Laporan Aset', 'Daftar aset & peminjaman', Colors.purple),
            _buildReportCard(context, Icons.assessment, 'Laporan BPJS', 'Iuran BPJS Kesehatan & TK', Colors.teal),
            if (isHR) ...[
              const SizedBox(height: 16),
              Text('Export', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.table_chart),
                label: const Text('Export Excel'),
                style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Export PDF'),
                style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, IconData icon, String title, String subtitle, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
