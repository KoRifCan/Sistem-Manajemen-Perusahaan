import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/approval_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../data/models/approval_model.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/theme/app_theme.dart';

class ApprovalPage extends StatefulWidget {
  const ApprovalPage({super.key});

  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      context.read<ApprovalProvider>().loadPendingApprovals(user.uid);
      context.read<ApprovalProvider>().loadMyRequests(user.uid);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ApprovalProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Pending (${provider.pendingApprovals.length})'),
              const Tab(text: 'History'),
              Tab(text: 'Pengajuan Saya (${provider.myRequests.length})'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(context, provider.pendingApprovals, theme, isPending: true),
                _buildList(context, [], theme),
                _buildList(context, provider.myRequests, theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<ApprovalRequestModel> list, ThemeData theme, {bool isPending = false}) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.checklist, size: 64, color: AppTheme.textHint(context)),
            const SizedBox(height: 16),
            Text('Tidak ada data', style: TextStyle(color: AppTheme.textSecondary(context))),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(item.type.toUpperCase(), style: TextStyle(color: theme.colorScheme.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    const Spacer(),
                    Text(Helpers.formatDate(item.createdAt), style: TextStyle(color: AppTheme.textHint(context), fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 4),
                Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppTheme.textSecondary(context))),
                const SizedBox(height: 4),
                Text('Diajukan oleh: ${item.requesterName}', style: TextStyle(color: AppTheme.textHint(context), fontSize: 12)),
                if (isPending) ...[
                  const Divider(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showRejectDialog(context, item.id),
                          icon: Icon(Icons.close, color: AppTheme.statusRejected(context)),
                          label: Text('Tolak', style: TextStyle(color: AppTheme.statusRejected(context))),
                          style: OutlinedButton.styleFrom(side: BorderSide(color: AppTheme.statusRejected(context))),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final user = context.read<AuthProvider>().user;
                            if (user != null) {
                              await context.read<ApprovalProvider>().approve(item.id, user.uid);
                            }
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('Setujui'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRejectDialog(BuildContext context, String id) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tolak Pengajuan'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Alasan penolakan', hintText: 'Wajib diisi'),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final uid = context.read<AuthProvider>().user?.uid;
                if (uid != null) {
                  context.read<ApprovalProvider>().reject(id, uid, controller.text);
                }
                Navigator.pop(context);
              }
            },
            child: const Text('Tolak'),
          ),
        ],
      ),
    );
  }
}
