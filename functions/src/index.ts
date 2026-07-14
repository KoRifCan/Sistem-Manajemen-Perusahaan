import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();
const db = admin.firestore();

// ── PAYROLL ─────────────────────────────────────

export const calculatePayroll = functions.firestore
  .document('payroll_periods/{periodId}')
  .onUpdate(async (change, context) => {
    const { periodId } = context.params;
    const period = change.after.data();
    if (period.status !== 'processing') return;

    try {
      const employees = await db.collection('employees')
        .where('isActive', '==', true)
        .get();

      const batch = db.batch();
      let totalSalary = 0;
      let totalDeductions = 0;

      for (const empDoc of employees.docs) {
        const emp = empDoc.data();
        const baseSalary = emp.baseSalary || 0;
        const allowances = {
          'Tunjangan Jabatan': baseSalary * 0.1,
          'Tunjangan Transport': 500000,
          'Tunjangan Makan': 450000,
        };
        const grossSalary = baseSalary + Object.values(allowances as any).reduce((a: number, b: number) => a + b, 0);
        const pph21 = calculatePPH21(grossSalary, emp.taxStatus || 'TK/0');
        const bpjsKes = baseSalary * 0.01;
        const bpjsTK = baseSalary * 0.02;
        const netSalary = grossSalary - pph21 - bpjsKes - bpjsTK;

        const payslipRef = db.collection('payslips').doc();
        batch.set(payslipRef, {
          employeeId: empDoc.id,
          periodId,
          baseSalary,
          overtimePay: 0,
          allowances,
          deductions: {},
          grossSalary,
          pph21,
          bpjsKesehatan: bpjsKes,
          bpjsKetenagakerjaan: bpjsTK,
          loanDeduction: 0,
          netSalary,
          status: 'approved',
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        totalSalary += grossSalary;
        totalDeductions += pph21 + bpjsKes + bpjsTK;
      }

      await batch.commit();

      await db.collection('payroll_periods').doc(periodId).update({
        status: 'completed',
        totalSalary,
        totalDeductions,
        totalNetSalary: totalSalary - totalDeductions,
        employeeCount: employees.size,
      });

      await db.collection('audit_logs').add({
        action: 'PROCESS_PAYROLL',
        module: 'payroll',
        description: `Payroll processed for period ${periodId}`,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });
    } catch (error) {
      await db.collection('payroll_periods').doc(periodId).update({ status: 'error' });
      functions.logger.error('Payroll processing failed:', error);
    }
  });

function calculatePPH21(grossSalary: number, taxStatus: string): number {
  const annualGross = grossSalary * 12;
  const ptkp: Record<string, number> = {
    'TK/0': 54000000, 'TK/1': 58500000, 'TK/2': 63000000, 'TK/3': 67500000,
    'K/0': 58500000, 'K/1': 63000000, 'K/2': 67500000, 'K/3': 72000000,
  };
  const pkp = annualGross - (ptkp[taxStatus] || 54000000);
  if (pkp <= 0) return 0;

  let tax = 0;
  if (pkp <= 60000000) tax = pkp * 0.05;
  else if (pkp <= 250000000) tax = 60000000 * 0.05 + (pkp - 60000000) * 0.15;
  else if (pkp <= 500000000) tax = 60000000 * 0.05 + 190000000 * 0.15 + (pkp - 250000000) * 0.25;
  else tax = 60000000 * 0.05 + 190000000 * 0.15 + 250000000 * 0.25 + (pkp - 500000000) * 0.30;

  return Math.round(tax / 12);
}

// ── APPROVAL ────────────────────────────────────

export const processApproval = functions.firestore
  .document('approvals/{approvalId}')
  .onWrite(async (change, context) => {
    const { approvalId } = context.params;
    const doc = change.after.exists ? change.after : change.before;
    const data = doc.data();
    if (!data || data.status !== 'approved') return;

    const type = data.type;
    const referenceId = data.referenceId;
    const approverId = data.approvedBy;

    if (type === 'leave' && referenceId) {
      await db.collection('leaves').doc(referenceId).update({
        status: 'approved',
        approvedBy: approverId,
        approvedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      // Send notification
      await sendNotification(data.requesterId, 'Cuti Disetujui', `Pengajuan cuti Anda telah disetujui.`);
    }
  });

// ── NOTIFICATIONS ───────────────────────────────

async function sendNotification(userId: string, title: string, body: string) {
  await db.collection('notifications').add({
    userId,
    title,
    body,
    type: 'approval',
    isRead: false,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  // Send FCM push notification
  try {
    const userDoc = await db.collection('users').doc(userId).get();
    const fcmToken = userDoc.data()?.fcmToken;
    if (fcmToken) {
      await admin.messaging().send({
        token: fcmToken,
        notification: { title, body },
        data: { type: 'approval' },
      });
    }
  } catch (error) {
    functions.logger.warn('FCM send failed:', error);
  }
}

// ── LEAVE BALANCE ───────────────────────────────

export const updateLeaveBalance = functions.firestore
  .document('leaves/{leaveId}')
  .onWrite(async (change, context) => {
    const data = change.after.data();
    if (!data || data.status !== 'approved') return;

    const employeeId = data.employeeId;
    const type = data.type;
    const days = data.totalDays || 0;

    const balanceRef = db.collection('leave_balances')
      .where('employeeId', '==', employeeId)
      .where('type', '==', type);

    const snapshot = await balanceRef.get();
    if (snapshot.empty) {
      await db.collection('leave_balances').add({
        employeeId,
        type,
        balance: 12 - days,
        year: new Date().getFullYear(),
      });
    } else {
      const doc = snapshot.docs[0];
      const currentBalance = doc.data().balance || 12;
      await doc.ref.update({ balance: currentBalance - days });
    }
  });

// ── ATTENDANCE REKAP ────────────────────────────

export const calculateAttendanceSummary = functions.pubsub
  .schedule('0 20 * * *')
  .timeZone('Asia/Jakarta')
  .onRun(async () => {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const logs = await db.collection('attendance')
      .where('date', '>=', today)
      .where('date', '<', tomorrow)
      .get();

    const summary: Record<string, { present: number; late: number; absent: number; total: number }> = {};

    for (const doc of logs.docs) {
      const data = doc.data();
      const deptId = data.departmentId || 'unknown';
      if (!summary[deptId]) {
        summary[deptId] = { present: 0, late: 0, absent: 0, total: 0 };
      }
      if (data.checkIn) {
        summary[deptId].present++;
        if (data.isLate) summary[deptId].late++;
      } else {
        summary[deptId].absent++;
      }
      summary[deptId].total++;
    }

    await db.collection('attendance_summary').doc(admin.firestore.Timestamp.now().toDate().toISOString().split('T')[0]).set({ summary, date: today });
  });

// ── USER ONBOARDING ──────────────────────────────

export const createUserProfile = functions.auth.user().onCreate(async (user) => {
  await db.collection('users').doc(user.uid).set({
    email: user.email,
    name: user.displayName || 'Pengguna Baru',
    role: 'staff',
    isActive: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });
});
