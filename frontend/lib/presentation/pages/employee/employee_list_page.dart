import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/employee_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/employee_model.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  String _searchQuery = '';
  String? _selectedDepartment;

  @override
  void initState() {
    super.initState();
    context.read<EmployeeProvider>().loadEmployees();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EmployeeProvider>();
    final employees = provider.employees;
    final theme = Theme.of(context);

    final filteredEmployees = employees.where((e) {
      if (_searchQuery.isNotEmpty && !e.name.toLowerCase().contains(_searchQuery.toLowerCase())) return false;
      if (_selectedDepartment != null && e.departmentId != _selectedDepartment) return false;
      return true;
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari karyawan...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      isDense: true,
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => _showFilterDialog(context, provider),
                ),
              ],
            ),
          ),
          if (_selectedDepartment != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Chip(
                label: Text(provider.departments.firstWhere((d) => d['id'] == _selectedDepartment, orElse: () => {'name': _selectedDepartment})['name']),
                onDeleted: () => setState(() => _selectedDepartment = null),
              ),
            ),
          Expanded(
            child: filteredEmployees.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text('Tidak ada karyawan', style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredEmployees.length,
                    itemBuilder: (context, index) {
                      final employee = filteredEmployees[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                            child: Text(Helpers.getInitials(employee.name), style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                          ),
                          title: Text(employee.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text('${employee.nip} - ${employee.positionId ?? '-'}'),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: employee.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              employee.isActive ? 'Aktif' : 'Nonaktif',
                              style: TextStyle(
                                color: employee.isActive ? Colors.green : Colors.red,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          onTap: () => context.go('/employees/${employee.id}'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/employees/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterDialog(BuildContext context, EmployeeProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Departemen', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...provider.departments.map((dept) => ListTile(
              title: Text(dept['name']),
              leading: Radio<String?>(
                value: dept['id'],
                groupValue: _selectedDepartment,
                onChanged: (v) {
                  setState(() => _selectedDepartment = v);
                  Navigator.pop(context);
                },
              ),
            )),
            if (provider.departments.isNotEmpty) const Divider(),
            ListTile(
              title: const Text('Semua Departemen'),
              leading: Radio<String?>(
                value: null,
                groupValue: _selectedDepartment,
                onChanged: (v) {
                  setState(() => _selectedDepartment = v);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
