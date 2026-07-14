import 'package:flutter_test/flutter_test.dart';
import 'package:sistem_manajemen_perusahaan/main.dart';

void main() {
  testWidgets('App should build', (WidgetTester tester) async {
    await tester.pumpWidget(const SistemManajemenPerusahaanApp());
    expect(find.text('Sistem Manajemen Perusahaan'), findsOneWidget);
  });
}
