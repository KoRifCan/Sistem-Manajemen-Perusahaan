import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/organization_provider.dart';

class OrganizationPage extends StatefulWidget {
  const OrganizationPage({super.key});

  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<OrganizationProvider>().loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrganizationProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Departemen'),
              Tab(text: 'Jabatan'),
              Tab(text: 'Grade'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDepartmentTree(context, provider, theme),
                _buildPositionList(context, provider, theme),
                _buildGradeList(context, provider, theme),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDepartmentTree(BuildContext context, OrganizationProvider provider, ThemeData theme) {
    final depts = provider.departments;
    if (depts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_tree, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('Belum ada departemen', style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _showAddDialog, child: const Text('Tambah Departemen')),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: depts.length,
      itemBuilder: (context, index) {
        final dept = depts[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getDeptColor(index).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.folder, color: _getDeptColor(index)),
            ),
            title: Text(dept['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(dept['code'] ?? 'Kode: -'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${dept['employeeCount'] ?? 0} karyawan', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPositionList(BuildContext context, OrganizationProvider provider, ThemeData theme) {
    final positions = provider.positions;
    if (positions.isEmpty) {
      return Center(child: Text('Belum ada jabatan', style: TextStyle(color: Colors.grey.shade600)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: positions.length,
      itemBuilder: (context, index) {
        final pos = positions[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(pos['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('Level: ${pos['level'] ?? '-'}'),
          ),
        );
      },
    );
  }

  Widget _buildGradeList(BuildContext context, OrganizationProvider provider, ThemeData theme) {
    final grades = provider.grades;
    if (grades.isEmpty) {
      return Center(child: Text('Belum ada grade', style: TextStyle(color: Colors.grey.shade600)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: grades.length,
      itemBuilder: (context, index) {
        final grade = grades[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(grade['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('Level ${grade['level']} | Range Gaji: Rp ${grade['minSalary'] ?? 0} - Rp ${grade['maxSalary'] ?? 0}'),
          ),
        );
      },
    );
  }

  Color _getDeptColor(int index) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.purple, Colors.teal];
    return colors[index % colors.length];
  }

  void _showAddDialog() {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Departemen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama Departemen')),
            const SizedBox(height: 12),
            TextField(controller: codeController, decoration: const InputDecoration(labelText: 'Kode (opsional)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                context.read<OrganizationProvider>().addDepartment(nameController.text, null, code: codeController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
