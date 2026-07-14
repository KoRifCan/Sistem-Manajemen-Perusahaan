import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/theme/app_theme.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      context.read<AttendanceProvider>().loadEmployeeAttendance(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttendanceProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(Helpers.formatDate(DateTime.now()), style: TextStyle(color: AppTheme.textSecondary(context))),
                    const SizedBox(height: 8),
                    Text(Helpers.formatTime(DateTime.now()), style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTimeBlock(context, 'Masuk', provider.employeeAttendance.isNotEmpty ? Helpers.formatTime(provider.employeeAttendance.first.checkIn ?? DateTime.now()) : '--:--'),
                        const SizedBox(width: 32),
                        _buildTimeBlock(context, 'Pulang', provider.employeeAttendance.isNotEmpty && provider.employeeAttendance.first.checkOut != null ? Helpers.formatTime(provider.employeeAttendance.first.checkOut!) : '--:--'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: Material(
                        color: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(80),
                          onTap: () => _handleCheckInOut(context, provider),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  provider.isCheckedIn ? Icons.fingerprint : Icons.fingerprint,
                                  color: Colors.white,
                                  size: 48,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  provider.isCheckedIn ? 'CHECK-OUT' : 'CHECK-IN',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(provider.isCheckedIn ? 'Tekan untuk check-out' : 'Tekan untuk check-in', style: TextStyle(color: AppTheme.textSecondary(context), fontSize: 13)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Riwayat Absensi', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ...provider.employeeAttendance.take(10).map((att) => Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: att.status == 'Hadir' ? AppTheme.statusApproved(context).withOpacity(0.1) : AppTheme.statusPending(context).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    att.status == 'Hadir' ? Icons.check_circle : Icons.warning,
                    color: att.status == 'Hadir' ? AppTheme.statusApproved(context) : AppTheme.statusPending(context),
                  ),
                ),
                title: Text(Helpers.formatDate(att.date)),
                subtitle: Text('${att.checkIn != null ? Helpers.formatTime(att.checkIn!) : '--:--'} - ${att.checkOut != null ? Helpers.formatTime(att.checkOut!) : '--:--'}'),
                trailing: Text(att.status ?? '-', style: TextStyle(
                  color: att.status == 'Hadir' ? AppTheme.statusApproved(context) : AppTheme.statusPending(context),
                  fontWeight: FontWeight.w600,
                )),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBlock(BuildContext context, String label, String time) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: AppTheme.textSecondary(context), fontSize: 13)),
        const SizedBox(height: 4),
        Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ],
    );
  }

  Future<void> _handleCheckInOut(BuildContext context, AttendanceProvider provider) async {
    if (!provider.isCheckedIn) {
      // Check-in logic
      // In production: get GPS + take photo
      final user = context.read<AuthProvider>().user;
      if (user == null) return;
      await provider.checkIn(
        employeeId: user.uid,
        photoUrl: 'https://via.placeholder.com/150',
        lat: -6.2088,
        lng: 106.8456,
      );
    } else {
      // Check-out logic
      if (provider.currentAttendanceId != null) {
        await provider.checkOut(
          provider.currentAttendanceId!,
          'https://via.placeholder.com/150',
          -6.2088,
          106.8456,
        );
      }
    }
  }
}
