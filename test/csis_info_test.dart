import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:csis_info/csis_info.dart';

void main() {
  // test des models
  group('CSIS Models Tests', () {
    test('CsisContact should be created correctly', () {
      const contact = CsisContact(
        type: 'phone',
        value: '+1(240) 425-6583',
        displayName: 'Téléphone',
      );

      expect(contact.type, 'phone');
      expect(contact.value, '+1(240) 425-6583');
      expect(contact.displayName, 'Téléphone');
    });

    test('CsisService should be created correctly', () {
      const service = CsisService(
        name: 'Test Service',
        description: 'Test Description',
      );

      expect(service.name, 'Test Service');
      expect(service.description, 'Test Description');
    });

    test('CsisConstants should have correct company info', () {
      expect(CsisConstants.companyName, 'CSIS');
      expect(CsisConstants.contacts.isNotEmpty, true);
      expect(CsisConstants.services.isNotEmpty, true);
    });
  });

  // test des widgets
  group('CSIS Widgets Tests', () {
    testWidgets('CsisLogoWidget should display correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CsisLogoWidget(width: 100, height: 100)),
        ),
      );

      expect(find.byType(CsisLogoWidget), findsOneWidget);
    });

    testWidgets('CsisInfoCard should display company name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CsisInfoCard())),
      );

      expect(find.text(CsisConstants.companyFullName), findsOneWidget);
    });

    testWidgets('CsisContactWidget should display contact title', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CsisContactWidget())),
      );

      expect(find.text('Contactez-nous'), findsOneWidget);
    });

    testWidgets('CsisServicesList should display services title', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(height: 400, child: CsisServicesList()),
          ),
        ),
      );

      expect(find.text('Nos Services'), findsOneWidget);
    });

    testWidgets('CsisServicesList should display services title (shrinkWrap)', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CsisServicesList(shrinkWrap: true, maxServices: 2),
          ),
        ),
      );

      expect(find.text('Nos Services'), findsOneWidget);
    });
  });

  // test d'intégration
  group('CSIS Integration Tests', () {
    testWidgets('All widgets should work together', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: const [
                  CsisInfoCard(),
                  CsisContactWidget(),
                  SizedBox(height: 300, child: CsisServicesList()),
                ],
              ),
            ),
          ),
        ),
      );

      // vérification que tous les widgets sont présents
      expect(find.byType(CsisInfoCard), findsOneWidget);
      expect(find.byType(CsisContactWidget), findsOneWidget);
      expect(find.byType(CsisServicesList), findsOneWidget);

      // vérification le contenu
      expect(find.text(CsisConstants.companyFullName), findsOneWidget);
      expect(find.text('Contactez-nous'), findsOneWidget);
      expect(find.text('Nos Services'), findsOneWidget);
    });

    testWidgets('Logo widget should handle errors gracefully', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CsisLogoWidget())),
      );

      expect(find.byType(CsisLogoWidget), findsOneWidget);
    });

    // Test spécifique pour les services avec défilement
    testWidgets('CsisServicesList should be scrollable with all services', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(height: 200, child: CsisServicesList()),
          ),
        ),
      );

      expect(find.text('Nos Services'), findsOneWidget);

      // Vérifier qu'on peut faire défiler
      await tester.drag(find.byType(CsisServicesList), const Offset(0, -100));
      await tester.pumpAndSettle();

      expect(find.text('Nos Services'), findsOneWidget);
    });
  });
}
