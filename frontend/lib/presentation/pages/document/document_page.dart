import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../providers/auth_provider.dart';
import '../../providers/document_provider.dart';
import '../../../core/theme/app_theme.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({super.key});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      context.read<DocumentProvider>().loadDocuments(user.uid);
    }
  }

  Future<void> _uploadDocument(String title) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.bytes == null) return;

    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    final provider = context.read<DocumentProvider>();
    final url = await provider.uploadDocument(
      employeeId: user.uid,
      name: title,
      category: 'Karyawan',
      bytes: file.bytes!,
      fileName: file.name,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(url != null ? '$title berhasil diupload' : 'Gagal upload $title')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<DocumentProvider>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dokumen Saya', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            if (provider.isLoading) const LinearProgressIndicator(),
            ...provider.documents.map((doc) => Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.statusApproved(context).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.description, color: AppTheme.statusApproved(context)),
                ),
                title: Text(doc['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(doc['fileName'] ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => provider.deleteDocument(doc['id']),
                ),
              ),
            )),
            const SizedBox(height: 24),
            Text('Upload Dokumen Baru', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _buildUploadCard(context, 'KTP', Icons.badge),
            _buildUploadCard(context, 'NPWP', Icons.receipt_long),
            _buildUploadCard(context, 'BPJS Kesehatan', Icons.health_and_safety),
            _buildUploadCard(context, 'BPJS Ketenagakerjaan', Icons.work),
            _buildUploadCard(context, 'Ijazah', Icons.school),
            const SizedBox(height: 24),
            Text('Dokumen Perusahaan', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _buildUploadCard(context, 'Kontrak Kerja', Icons.assignment),
            _buildUploadCard(context, 'SK Pengangkatan', Icons.description),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadCard(BuildContext context, String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryBlue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: const Text('Belum diupload'),
        trailing: IconButton(
          icon: const Icon(Icons.cloud_upload_outlined),
          onPressed: () => _uploadDocument(title),
        ),
      ),
    );
  }
}
