import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({super.key});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dokumen Saya', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _buildDocumentCard(context, 'KTP', Icons.badge, 'Valid', AppTheme.statusApproved(context)),
            _buildDocumentCard(context, 'NPWP', Icons.receipt_long, 'Perlu Diperbarui', AppTheme.statusPending(context)),
            _buildDocumentCard(context, 'BPJS Kesehatan', Icons.health_and_safety, 'Valid', AppTheme.statusApproved(context)),
            _buildDocumentCard(context, 'BPJS Ketenagakerjaan', Icons.work, 'Valid', AppTheme.statusApproved(context)),
            _buildDocumentCard(context, 'Ijazah', Icons.school, 'Belum Unggah', AppTheme.textHint(context)),
            const SizedBox(height: 24),
            Text('Dokumen Perusahaan', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _buildDocumentCard(context, 'Kontrak Kerja', Icons.assignment, 'Upload 05 Jan 2026', AppTheme.statusDefault(context)),
            _buildDocumentCard(context, 'SK Pengangkatan', Icons.description, 'Upload 01 Des 2025', AppTheme.statusDefault(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(BuildContext context, String title, IconData icon, String status, Color statusColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: statusColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(status),
        trailing: IconButton(
          icon: const Icon(Icons.cloud_upload_outlined),
          onPressed: () {},
        ),
      ),
    );
  }
}
