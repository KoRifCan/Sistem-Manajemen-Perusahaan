import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/employee_provider.dart';
import '../../presentation/providers/auth_provider.dart';
import 'helpers.dart';

class ExportUtils {
  static Future<void> exportEmployeesToPDF(BuildContext context) async {
    final provider = context.read<EmployeeProvider>();
    final employees = provider.employees;
    final auth = context.read<AuthProvider>();
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text('Laporan Karyawan - ${auth.user?.name ?? "PT. KoRifCan"}'),
          ),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            cellStyle: const pw.TextStyle(fontSize: 9),
            headers: ['NIP', 'Nama', 'Email', 'Status'],
            data: employees.map((e) => [e.nip, e.name, e.email ?? '-', e.isActive ? 'Aktif' : 'Nonaktif']).toList(),
          ),
        ],
      ),
    );
    await _saveAndOpen(context, pdf, 'laporan_karyawan.pdf');
  }

  static Future<void> exportEmployeesToCSV(BuildContext context) async {
    final provider = context.read<EmployeeProvider>();
    final employees = provider.employees;
    final buffer = StringBuffer();
    buffer.writeln('NIP,Nama,Email,Status');
    for (final e in employees) {
      buffer.writeln('${e.nip},${e.name},${e.email ?? '-'},${e.isActive ? 'Aktif' : 'Nonaktif'}');
    }
    await _saveAndShare(context, buffer.toString(), 'laporan_karyawan.csv', 'Export Excel');
  }

  static Future<void> exportPayslipPDF(BuildContext context, String employeeName, String period, Map<String, String> items) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('SLIP GAJI')),
          pw.Paragraph(text: '$employeeName - $period'),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            data: items.entries.map((e) => [e.key, e.value]).toList(),
          ),
        ],
      ),
    );
    await _saveAndOpen(context, pdf, 'slip_gaji_${period.replaceAll(" ", "_")}.pdf');
  }

  static Future<void> _saveAndOpen(BuildContext context, pw.Document pdf, String fileName) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(await pdf.save());
      await OpenFile.open(file.path);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuka file: $e')),
        );
      }
    }
  }

  static Future<void> _saveAndShare(BuildContext context, String content, String fileName, String label) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(content);
      await Share.share('$label\n\n${content.substring(0, content.length.clamp(0, 500))}\n\nFile: $fileName');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal export: $e')),
        );
      }
    }
  }
}
