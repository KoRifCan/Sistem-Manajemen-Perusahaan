import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/payroll_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/export_utils.dart';
import '../../../core/theme/app_theme.dart';

class PayslipDetailPage extends StatelessWidget {
  final String id;
  const PayslipDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PayrollProvider>();
    final theme = Theme.of(context);

    // In production, fetch payslip by ID
    final payslip = provider.payslips.where((p) => p.id == id).firstOrNull;

    if (payslip == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Slip Gaji')),
        body: const Center(child: Text('Data tidak ditemukan')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Slip Gaji'),
        actions: [
          IconButton(icon: const Icon(Icons.picture_as_pdf), onPressed: () => _exportPdf(context, payslip.id)),
          IconButton(icon: const Icon(Icons.share), onPressed: () => _sharePayslip(context, payslip)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('SLIP GAJI', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(Helpers.formatMonthYear(payslip.createdAt), style: TextStyle(color: AppTheme.textSecondary(context))),
                    const Divider(height: 24),
                    _buildDetailRow('Gaji Pokok', Helpers.formatCurrency(payslip.baseSalary)),
                    _buildDetailRow('Lembur', Helpers.formatCurrency(payslip.overtimePay)),
                    _buildDetailRow('Tunjangan', Helpers.formatCurrency(payslip.allowances.values.fold(0.0, (a, b) => a + b))),
                    const Divider(),
                    _buildDetailRow('Gaji Kotor', Helpers.formatCurrency(payslip.grossSalary), bold: true),
                    const Divider(),
                    _buildDetailRow('Potongan PPh 21', '-${Helpers.formatCurrency(payslip.pph21)}', color: AppTheme.statusRejected(context)),
                    _buildDetailRow('BPJS Kesehatan', '-${Helpers.formatCurrency(payslip.bpjsKesehatan)}', color: AppTheme.statusRejected(context)),
                    _buildDetailRow('BPJS Ketenagakerjaan', '-${Helpers.formatCurrency(payslip.bpjsKetenagakerjaan)}', color: AppTheme.statusRejected(context)),
                    if (payslip.loanDeduction > 0)
                      _buildDetailRow('Pinjaman', '-${Helpers.formatCurrency(payslip.loanDeduction)}', color: Colors.red),
                    const Divider(thickness: 2),
                    _buildDetailRow('TOTAL DITERIMA', Helpers.formatCurrency(payslip.netSalary), bold: true, color: AppTheme.statusApproved(context), fontSize: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status:', style: TextStyle(color: AppTheme.textSecondary(context))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: payslip.status == 'paid' ? AppTheme.statusApproved(context).withOpacity(0.1) : AppTheme.statusPending(context).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            payslip.status.toUpperCase(),
                            style: TextStyle(
                              color: payslip.status == 'paid' ? AppTheme.statusApproved(context) : AppTheme.statusPending(context),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (payslip.paidAt != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tanggal Bayar:', style: TextStyle(color: AppTheme.textSecondary(context))),
                          Text(Helpers.formatDate(payslip.paidAt!)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exportPdf(BuildContext context, String id) {
    final payslip = context.read<PayrollProvider>().payslips.where((p) => p.id == id).firstOrNull;
    if (payslip == null) return;
    ExportUtils.exportPayslipPDF(
      context,
      context.read<AuthProvider>().user?.name ?? 'Karyawan',
      Helpers.formatMonthYear(payslip.createdAt),
      {
        'Gaji Pokok': Helpers.formatCurrency(payslip.baseSalary),
        'Lembur': Helpers.formatCurrency(payslip.overtimePay),
        'Gaji Kotor': Helpers.formatCurrency(payslip.grossSalary),
        'PPh 21': '-${Helpers.formatCurrency(payslip.pph21)}',
        'BPJS Kesehatan': '-${Helpers.formatCurrency(payslip.bpjsKesehatan)}',
        'BPJS TK': '-${Helpers.formatCurrency(payslip.bpjsKetenagakerjaan)}',
        'TOTAL': Helpers.formatCurrency(payslip.netSalary),
      },
    );
  }

  void _sharePayslip(BuildContext context, dynamic payslip) {
    Share.share('Slip Gaji ${Helpers.formatMonthYear(payslip.createdAt)} - ${Helpers.formatCurrency(payslip.netSalary)}');
  }

  Widget _buildDetailRow(String label, String value, {bool bold = false, Color? color, double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontSize: fontSize)),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w600, color: color, fontSize: fontSize)),
        ],
      ),
    );
  }
}
