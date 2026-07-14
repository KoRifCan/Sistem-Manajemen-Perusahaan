import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/employee/employee_list_page.dart';
import '../pages/employee/employee_detail_page.dart';
import '../pages/employee/employee_form_page.dart';
import '../pages/attendance/attendance_page.dart';
import '../pages/leave/leave_page.dart';
import '../pages/leave/leave_form_page.dart';
import '../pages/payroll/payroll_page.dart';
import '../pages/payroll/payslip_detail_page.dart';
import '../pages/approval/approval_page.dart';
import '../pages/organization/organization_page.dart';
import '../pages/asset/asset_page.dart';
import '../pages/document/document_page.dart';
import '../pages/report/report_page.dart';
import '../pages/notification/notification_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/profile/profile_page.dart';
import '../widgets/main_scaffold.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final auth = context.read<AuthProvider>();
      if (!auth.isInitialized) return null;
      final isLoggedIn = auth.isAuthenticated;
      final isLoginRoute = state.matchedLocation == '/login';
      final isRegisterRoute = state.matchedLocation == '/register';
      if (isLoggedIn && (isLoginRoute || isRegisterRoute)) return '/dashboard';
      if (!isLoggedIn && !isLoginRoute && !isRegisterRoute) return '/login';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/employees',
            builder: (context, state) => const EmployeeListPage(),
          ),
          GoRoute(
            path: '/employees/add',
            builder: (context, state) => const EmployeeFormPage(),
          ),
          GoRoute(
            path: '/employees/:id',
            builder: (context, state) => EmployeeDetailPage(id: state.pathParameters['id'] ?? ''),
          ),
          GoRoute(
            path: '/employees/:id/edit',
            builder: (context, state) => EmployeeFormPage(id: state.pathParameters['id']),
          ),
          GoRoute(
            path: '/attendance',
            builder: (context, state) => const AttendancePage(),
          ),
          GoRoute(
            path: '/leaves',
            builder: (context, state) => const LeavePage(),
          ),
          GoRoute(
            path: '/leaves/add',
            builder: (context, state) => const LeaveFormPage(),
          ),
          GoRoute(
            path: '/payroll',
            builder: (context, state) => const PayrollPage(),
          ),
          GoRoute(
            path: '/payroll/:id',
            builder: (context, state) => PayslipDetailPage(id: state.pathParameters['id'] ?? ''),
          ),
          GoRoute(
            path: '/approvals',
            builder: (context, state) => const ApprovalPage(),
          ),
          GoRoute(
            path: '/organization',
            builder: (context, state) => const OrganizationPage(),
          ),
          GoRoute(
            path: '/assets',
            builder: (context, state) => const AssetPage(),
          ),
          GoRoute(
            path: '/documents',
            builder: (context, state) => const DocumentPage(),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportPage(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationPage(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
}
