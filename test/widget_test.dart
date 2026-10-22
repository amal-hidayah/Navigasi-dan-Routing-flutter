import 'package:flutter_test/flutter_test.dart';

import 'package:nusa_travel/main.dart';

void main() {
  testWidgets('Splash membuka daftar paket setelah tombol ditekan', (
    tester,
  ) async {
    await tester.pumpWidget(const NusaTravelApp());

    expect(find.text('Mulai Eksplorasi'), findsOneWidget);
    expect(find.text('NusaTravel'), findsOneWidget);

    await tester.tap(find.text('Mulai Eksplorasi'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Paket wisata Nusantara'), findsOneWidget);
  });
}
