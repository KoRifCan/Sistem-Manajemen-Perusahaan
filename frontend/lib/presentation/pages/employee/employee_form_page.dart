import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/employee_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/employee_model.dart';

class EmployeeFormPage extends StatefulWidget {
  final String? id;
  const EmployeeFormPage({super.key, this.id});

  @override
  State<EmployeeFormPage> createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nipController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nikController = TextEditingController();
  final _placeOfBirthController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _bankAccountController = TextEditingController();
  String? _gender;
  String? _religion;
  String? _bloodType;
  String? _maritalStatus;
  String? _status;
  String? _departmentId;
  String? _positionId;

  bool get isEdit => widget.id != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final provider = context.read<EmployeeProvider>();
      final emp = provider.employees.where((e) => e.id == widget.id).firstOrNull;
      if (emp != null) {
        _nipController.text = emp.nip;
        _nameController.text = emp.name;
        _emailController.text = emp.email ?? '';
        _phoneController.text = emp.phone ?? '';
        _nikController.text = emp.nik ?? '';
        _placeOfBirthController.text = emp.placeOfBirth ?? '';
        _addressController.text = emp.address ?? '';
        _cityController.text = emp.city ?? '';
        _bankAccountController.text = emp.bankAccount ?? '';
        _gender = emp.gender;
        _religion = emp.religion;
        _bloodType = emp.bloodType;
        _maritalStatus = emp.maritalStatus;
        _status = emp.status;
        _departmentId = emp.departmentId;
        _positionId = emp.positionId;
      }
    }
  }

  @override
  void dispose() {
    _nipController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nikController.dispose();
    _placeOfBirthController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _bankAccountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<EmployeeProvider>();
    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    final employee = EmployeeModel(
      id: widget.id ?? '',
      nip: _nipController.text.trim(),
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      nik: _nikController.text.trim(),
      placeOfBirth: _placeOfBirthController.text.trim(),
      gender: _gender,
      religion: _religion,
      bloodType: _bloodType,
      maritalStatus: _maritalStatus,
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      departmentId: _departmentId,
      positionId: _positionId,
      status: _status,
      joinDate: DateTime.now(),
      bankAccount: _bankAccountController.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (isEdit) {
      await provider.updateEmployee(widget.id!, employee.toMap());
    } else {
      await provider.addEmployee(employee);
    }
    if (mounted) context.go('/employees');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EmployeeProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Karyawan' : 'Tambah Karyawan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Data Pribadi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap *'),
                validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextFormField(
                    controller: _nikController,
                    decoration: const InputDecoration(labelText: 'NIK'),
                    maxLength: 16,
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(
                    controller: _nipController,
                    decoration: const InputDecoration(labelText: 'NIP *'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                  )),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email'))),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'No. Telepon'))),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(controller: _placeOfBirthController, decoration: const InputDecoration(labelText: 'Tempat Lahir')),
              const SizedBox(height: 12),
              TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: 'Alamat'), maxLines: 2),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _cityController, decoration: const InputDecoration(labelText: 'Kota'))),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: DropdownButtonFormField<String>(
                    value: _gender,
                    decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                    items: ['Laki-laki', 'Perempuan'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (v) => setState(() => _gender = v),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: DropdownButtonFormField<String>(
                    value: _religion,
                    decoration: const InputDecoration(labelText: 'Agama'),
                    items: AppConstants.religions.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (v) => setState(() => _religion = v),
                  )),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: DropdownButtonFormField<String>(
                    value: _bloodType,
                    decoration: const InputDecoration(labelText: 'Gol. Darah'),
                    items: AppConstants.bloodTypes.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (v) => setState(() => _bloodType = v),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: DropdownButtonFormField<String>(
                    value: _maritalStatus,
                    decoration: const InputDecoration(labelText: 'Status Nikah'),
                    items: AppConstants.maritalStatus.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (v) => setState(() => _maritalStatus = v),
                  )),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Data Kepegawaian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: DropdownButtonFormField<String>(
                    value: _departmentId,
                    decoration: const InputDecoration(labelText: 'Departemen'),
                    items: provider.departments.map((d) => DropdownMenuItem(value: d['id'], child: Text(d['name']))).toList(),
                    onChanged: (v) => setState(() => _departmentId = v),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: DropdownButtonFormField<String>(
                    value: _positionId,
                    decoration: const InputDecoration(labelText: 'Jabatan'),
                    items: provider.positions.map((p) => DropdownMenuItem(value: p['id'], child: Text(p['name']))).toList(),
                    onChanged: (v) => setState(() => _positionId = v),
                  )),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status Karyawan'),
                items: AppConstants.employeeStatus.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _status = v),
              ),
              const SizedBox(height: 24),
              const SizedBox(width: double.infinity, child: ElevatedButton(onPressed: null, child: Text('Simpan'))),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _save,
          child: Text(isEdit ? 'Update' : 'Simpan'),
        ),
      ),
    );
  }
}
