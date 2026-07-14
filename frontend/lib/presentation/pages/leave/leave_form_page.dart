import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/leave_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/leave_model.dart';

class LeaveFormPage extends StatefulWidget {
  const LeaveFormPage({super.key});

  @override
  State<LeaveFormPage> createState() => _LeaveFormPageState();
}

class _LeaveFormPageState extends State<LeaveFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _contactController = TextEditingController();
  String? _leaveType;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  int _totalDays = 1;

  @override
  void dispose() {
    _reasonController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Ajukan Cuti')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _leaveType,
                decoration: const InputDecoration(labelText: 'Jenis Cuti *'),
                items: AppConstants.leaveTypes.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _leaveType = v),
                validator: (v) => v == null ? 'Pilih jenis cuti' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDatePicker(context, 'Tanggal Mulai', _startDate, (d) {
                      setState(() {
                        _startDate = d;
                        _calculateDays();
                      });
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDatePicker(context, 'Tanggal Akhir', _endDate, (d) {
                      setState(() {
                        _endDate = d;
                        _calculateDays();
                      });
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Total: $_totalDays hari kerja', style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: 'Alasan *'),
                maxLines: 3,
                validator: (v) => (v == null || v.isEmpty) ? 'Alasan wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Kontak Selama Cuti'),
                hintText: 'No. HP yang bisa dihubungi',
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.upload_file),
                  title: const Text('Lampiran (opsional)'),
                  subtitle: const Text('Upload surat dokter / dokumen pendukung'),
                  trailing: const Icon(Icons.attach_file),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _submitLeave,
          child: const Text('Ajukan Cuti'),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, String label, DateTime date, ValueChanged<DateTime> onSelected) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) onSelected(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(Helpers.formatDate(date)),
      ),
    );
  }

  void _calculateDays() {
    _totalDays = Helpers.calculateLeaveDays(_startDate, _endDate);
  }

  Future<void> _submitLeave() async {
    if (!_formKey.currentState!.validate()) return;
    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    final leave = LeaveModel(
      id: '',
      employeeId: user.uid,
      type: _leaveType!,
      startDate: _startDate,
      endDate: _endDate,
      totalDays: _totalDays,
      reason: _reasonController.text.trim(),
      contactDuringLeave: _contactController.text.trim(),
      createdAt: DateTime.now(),
    );

    final success = await context.read<LeaveProvider>().submitLeave(leave);
    if (success && mounted) context.go('/leaves');
  }
}
