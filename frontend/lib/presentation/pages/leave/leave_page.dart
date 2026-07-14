import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/leave_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/theme/app_theme.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      context.read<LeaveProvider>().loadEmployeeLeaves(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LeaveProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(child: _buildLeaveType(context, 'Cuti Tahunan', '8', '12', AppTheme.statusDefault(context))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildLeaveType(context, 'Cuti Sakit', '3', '5', AppTheme.statusRejected(context))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildLeaveType(context, 'Cuti Besar', '0', '1', AppTheme.statusPending(context))),
                ],
              ),
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.leaves.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.beach_access, size: 64, color: AppTheme.textHint(context)),
                            const SizedBox(height: 16),
                            Text('Belum ada pengajuan cuti', style: TextStyle(color: AppTheme.textSecondary(context))),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: provider.leaves.length,
                        itemBuilder: (context, index) {
                          final leave = provider.leaves[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(context, leave.status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(_getStatusIcon(leave.status), color: _getStatusColor(context, leave.status)),
                              ),
                              title: Text(leave.type, style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${Helpers.formatDate(leave.startDate)} - ${Helpers.formatDate(leave.endDate)}'),
                                  Text('${leave.totalDays} hari - ${leave.reason}'),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(context, leave.status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  leave.status.toUpperCase(),
                                  style: TextStyle(color: _getStatusColor(context, leave.status), fontWeight: FontWeight.bold, fontSize: 11),
                                ),
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/leaves/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildLeaveType(BuildContext context, String label, String used, String total, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: AppTheme.textSecondary(context), fontSize: 12)),
        const SizedBox(height: 4),
        Text(used, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: color)),
        Text('/ $total hari', style: TextStyle(color: AppTheme.textHint(context), fontSize: 12)),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: int.tryParse(used) != null && int.tryParse(total) != null ? int.parse(used) / int.parse(total) : 0,
          backgroundColor: color.withOpacity(0.1),
          color: color,
        ),
      ],
    );
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status) {
      case 'pending': return AppTheme.statusPending(context);
      case 'approved': return AppTheme.statusApproved(context);
      case 'rejected': return AppTheme.statusRejected(context);
      case 'cancelled': return AppTheme.textSecondary(context);
      default: return AppTheme.textSecondary(context);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending': return Icons.hourglass_empty;
      case 'approved': return Icons.check_circle;
      case 'rejected': return Icons.cancel;
      case 'cancelled': return Icons.cancel_outlined;
      default: return Icons.help;
    }
  }
}
