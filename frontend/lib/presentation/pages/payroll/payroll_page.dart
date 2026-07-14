import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/payroll_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/theme/app_theme.dart';

class PayrollPage extends StatefulWidget {
  const PayrollPage({super.key});

  @override
  State<PayrollPage> createState() => _PayrollPageState();
}

class _PayrollPageState extends State<PayrollPage> {
  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      context.read<PayrollProvider>().loadPayslips(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PayrollProvider>();
    final theme = Theme.of(context);
    final isHR = context.read<AuthProvider>().user?.isHR ?? false;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isHR) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text('Periode Aktif', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(Helpers.formatMonthYear(DateTime.now()), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text('Total Gaji', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text('Rp 0', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showCreatePeriodDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Buat Periode'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _processPayroll(context),
                      icon: const Icon(Icons.calculate),
                      label: const Text('Proses Payroll'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Riwayat Slip Gaji', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.payslips.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long_outlined, size: 64, color: AppTheme.textHint(context)),
                            const SizedBox(height: 16),
                            Text('Belum ada slip gaji', style: TextStyle(color: AppTheme.textSecondary(context))),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: provider.payslips.length,
                        itemBuilder: (context, index) {
                          final payslip = provider.payslips[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: payslip.status == 'paid' ? AppTheme.statusApproved(context).withOpacity(0.1) : AppTheme.statusPending(context).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  payslip.status == 'paid' ? Icons.check_circle : Icons.pending,
                                  color: payslip.status == 'paid' ? AppTheme.statusApproved(context) : AppTheme.statusPending(context),
                                ),
                              ),
                              title: Text(Helpers.formatMonthYear(payslip.createdAt), style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Gaji Pokok: ${Helpers.formatCurrency(payslip.baseSalary)}'),
                                  Text('Take Home Pay: ${Helpers.formatCurrency(payslip.netSalary)}'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.picture_as_pdf),
                                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('PDF akan tersedia di update berikutnya')),
                                ),
                              ),
                              isThreeLine: true,
                              onTap: () => context.go('/payroll/${payslip.id}'),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _processPayroll(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Proses payroll akan tersedia di update berikutnya')),
    );
  }

  void _showCreatePeriodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buat Periode Baru'),
        content: const Text('Periode akan dibuat untuk bulan berjalan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Periode baru akan tersedia di update berikutnya')),
              );
            },
            child: const Text('Buat'),
          ),
        ],
      ),
    );
  }
}
