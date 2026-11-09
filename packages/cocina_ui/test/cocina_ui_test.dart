import 'package:cocina_ui/cocina_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Pruebas Unitarias y de Widget - IngredientChip (RA3.e)', () {
    test('Escala correctamente la cantidad según las raciones y cumple contrato', () {
      final chip = IngredientChip(
        name: 'Huevos',
        baseQuantity: 4,
        baseServings: 4,
        targetServings: 6,
        onAddToCart: (_, __, ___) {},
      );
      expect(chip.scaledQuantity, 6.0);
      expect(chip.supportsHandsFree, isTrue);
      expect(chip.semanticDescription, contains('Huevos'));
    });

    testWidgets('Dispara onAddToCart al pulsar el chip', (tester) async {
      String? addedName;
      double? addedQty;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IngredientChip(
              name: 'Patatas',
              baseQuantity: 400,
              unit: 'g',
              baseServings: 4,
              targetServings: 2,
              onAddToCart: (n, q, u) {
                addedName = n;
                addedQty = q;
              },
            ),
          ),
        ),
      );

      expect(find.text('Patatas (200 g)'), findsOneWidget);
      await tester.tap(find.byType(ActionChip));
      expect(addedName, 'Patatas');
      expect(addedQty, 200.0);
    });
  });

  group('Pruebas de Widget - StepTimer (RA3.e)', () {
    testWidgets('Inicia, pausa, reinicia y dispara onFinished', (tester) async {
      bool finished = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepTimer(
              duration: const Duration(seconds: 2),
              autoStart: false,
              onFinished: () => finished = true,
            ),
          ),
        ),
      );

      expect(find.text('00:02'), findsOneWidget);
      await tester.tap(find.byKey(const Key('timer_toggle_btn')));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('00:01'), findsOneWidget);

      await tester.tap(find.byKey(const Key('timer_reset_btn')));
      await tester.pump();
      expect(find.text('00:02'), findsOneWidget);

      await tester.tap(find.byKey(const Key('timer_toggle_btn')));
      await tester.pump(const Duration(seconds: 2));
      expect(finished, isTrue);
    });
  });
}
