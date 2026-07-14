import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/employee_provider.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/theme/app_theme.dart';

class EmployeeDetailPage extends StatelessWidget {
  final String id;
  const EmployeeDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EmployeeProvider>();
    final employee = provider.employees.where((e) => e.id == id).firstOrNull;
    final theme = Theme.of(context);

    if (employee == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Karyawan')),
        body: const Center(child: Text('Karyawan tidak ditemukan')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(employee.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.go('/employees/${employee.id}/edit'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    child: Text(Helpers.getInitials(employee.name), style: TextStyle(fontSize: 28, color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  Text(employee.name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  Text(employee.nip, style: TextStyle(color: AppTheme.textSecondary(context))),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: employee.isActive ? AppTheme.statusApproved(context).withOpacity(0.1) : AppTheme.statusRejected(context).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      employee.isActive ? 'Aktif' : 'Nonaktif',
                      style: TextStyle(color: employee.isActive ? AppTheme.statusApproved(context) : AppTheme.statusRejected(context), fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(context, 'Data Pribadi', [
              _buildInfoRow('NIK', employee.nik ?? '-'),
              _buildInfoRow('Tempat, Tgl Lahir', '${employee.placeOfBirth ?? '-'}, ${employee.dateOfBirth != null ? Helpers.formatDate(employee.dateOfBirth!) : '-'}'),
              _buildInfoRow('Jenis Kelamin', employee.gender ?? '-'),
              _buildInfoRow('Agama', employee.religion ?? '-'),
              _buildInfoRow('Gol. Darah', employee.bloodType ?? '-'),
              _buildInfoRow('Status Nikah', employee.maritalStatus ?? '-'),
              _buildInfoRow('Alamat', employee.address ?? '-'),
              _buildInfoRow('Kota', employee.city ?? '-'),
            ]),
            const SizedBox(height: 16),
            _buildSection(context, 'Data Kepegawaian', [
              _buildInfoRow('NIP', employee.nip),
              _buildInfoRow('Status', employee.status ?? '-'),
              _buildInfoRow('Tanggal Masuk', Helpers.formatDate(employee.joinDate)),
              _buildInfoRow('Berakhir Kontrak', employee.contractEndDate != null ? Helpers.formatDate(employee.contractEndDate!) : '-'),
              _buildInfoRow('Shift', employee.shift ?? '-'),
              _buildInfoRow('Lokasi Kerja', employee.location ?? '-'),
            ]),
            const SizedBox(height: 16),
            _buildSection(context, 'Keuangan', [
              _buildInfoRow('Gaji Pokok', employee.baseSalary != null ? Helpers.formatCurrency(employee.baseSalary!) : '-'),
              _buildInfoRow('Status Pajak', employee.taxStatus ?? '-'),
              _buildInfoRow('Bank', employee.bankName ?? '-'),
              _buildInfoRow('No. Rekening', employee.bankAccount ?? '-'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text(label, style: TextStyle(color: AppTheme.textSecondary(context)))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
