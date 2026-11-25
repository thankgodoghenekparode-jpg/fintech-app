import 'package:developer_2_mobile/features/agent_network/presentation/agent_home_demo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows supplied sample data and lets the viewer hide balance',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AgentHomeDemoScreen()),
    );

    expect(find.text('Alaba Express Pay'), findsOneWidget);
    expect(
        find.text(
            'Design sample - not live account data. Money actions are disabled in this demo.'),
        findsOneWidget);
    expect(find.text('₦485,250.00'), findsOneWidget);

    await tester.tap(find.byTooltip('Hide balance'));
    await tester.pump();

    expect(find.text('₦485,250.00'), findsNothing);
    expect(find.text('₦••••••••'), findsOneWidget);
  });
  testWidgets('Contact opens the supplied field rep contact options',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AgentHomeDemoScreen()),
    );

    await tester.scrollUntilVisible(
      find.text('Contact'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Contact'));
    await tester.pumpAndSettle();

    expect(find.text('Field operator support'), findsOneWidget);
    expect(find.text('Lagos Field Rep'), findsOneWidget);
    expect(find.text('0800-YOURAPP-AGN'), findsOneWidget);
    expect(find.text('Copy contact'), findsOneWidget);
    expect(
      find.text(
          'Supplied sample contact. Calls are not placed from this demo.'),
      findsOneWidget,
    );
  });
}
