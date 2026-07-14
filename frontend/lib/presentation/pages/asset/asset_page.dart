import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/asset_provider.dart';
import '../../../core/theme/app_theme.dart';

class AssetPage extends StatefulWidget {
  const AssetPage({super.key});

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final provider = context.read<AssetProvider>();
    provider.loadAssets();
    provider.loadCategories();
    provider.loadLoans();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssetProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Semua Aset (${provider.assets.length})'),
              Tab(text: 'Dipinjam (${provider.loans.where((l) => l['status'] == 'Dipinjam').length})'),
              Tab(text: 'Kategori'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAssetList(provider, theme),
                _buildLoanList(provider, theme),
                _buildCategoryList(provider, theme),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAssetDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAssetList(AssetProvider provider, ThemeData theme) {
    final assets = provider.assets;
    if (assets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: AppTheme.textHint(context)),
            const SizedBox(height: 16),
            Text('Belum ada aset', style: TextStyle(color: AppTheme.textSecondary(context))),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final asset = assets[index];
        final status = asset['status'] ?? 'Tersedia';
        final isAvailable = status == 'Tersedia';
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isAvailable ? AppTheme.statusApproved(context).withOpacity(0.1) : AppTheme.statusPending(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isAvailable ? Icons.check_circle : Icons.person,
                color: isAvailable ? AppTheme.statusApproved(context) : AppTheme.statusPending(context),
              ),
            ),
            title: Text(asset['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('${asset['code'] ?? '-'} | ${asset['category'] ?? '-'}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: status == 'Tersedia' ? AppTheme.statusApproved(context).withOpacity(0.1) : AppTheme.statusPending(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(status, style: TextStyle(color: status == 'Tersedia' ? AppTheme.statusApproved(context) : AppTheme.statusPending(context), fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoanList(AssetProvider provider, ThemeData theme) {
    final loans = provider.loans.where((l) => l['status'] == 'Dipinjam').toList();
    if (loans.isEmpty) {
      return Center(child: Text('Tidak ada peminjaman aktif', style: TextStyle(color: AppTheme.textSecondary(context))));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: loans.length,
      itemBuilder: (context, index) {
        final loan = loans[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(loan['employeeName'] ?? '-', style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('Aset: ${loan['assetId'] ?? '-'}'),
            trailing: ElevatedButton(
              onPressed: () {
                provider.returnAsset(loan['id'], loan['assetId']);
              },
              child: const Text('Kembali'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryList(AssetProvider provider, ThemeData theme) {
    final categories = provider.categories;
    if (categories.isEmpty) {
      return Center(child: Text('Belum ada kategori', style: TextStyle(color: AppTheme.textSecondary(context))));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.category, color: theme.colorScheme.primary),
            ),
            title: Text(cat['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        );
      },
    );
  }

  void _showAddAssetDialog() {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Aset'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama Aset')),
            const SizedBox(height: 12),
            TextField(controller: codeController, decoration: const InputDecoration(labelText: 'Kode Aset')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                context.read<AssetProvider>().addAsset({
                  'name': nameController.text,
                  'code': codeController.text,
                });
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
