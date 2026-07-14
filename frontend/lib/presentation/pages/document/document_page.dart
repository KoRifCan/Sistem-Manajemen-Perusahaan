import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

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
            _buildDocumentCard(context, 'KTP', 'assets/images/ktp.png', 'Valid', Colors.green),
            _buildDocumentCard(context, 'NPWP', 'assets/images/npwp.png', 'Perlu Diperbarui', Colors.orange),
            _buildDocumentCard(context, 'BPJS Kesehatan', 'assets/images/bpjs.png', 'Valid', Colors.green),
            _buildDocumentCard(context, 'BPJS Ketenagakerjaan', 'assets/images/bpjs-tk.png', 'Valid', Colors.green),
            _buildDocumentCard(context, 'Ijazah', 'assets/images/ijazah.png', 'Belum Unggah', Colors.grey),
            const SizedBox(height: 24),
            Text('Dokumen Perusahaan', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _buildDocumentCard(context, 'Kontrak Kerja', 'assets/images/contract.png', 'Upload 05 Jan 2026', Colors.blue),
            _buildDocumentCard(context, 'SK Pengangkatan', 'assets/images/sk.png', 'Upload 01 Des 2025', Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(BuildContext context, String title, String icon, String status, Color statusColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.description, color: statusColor),
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
