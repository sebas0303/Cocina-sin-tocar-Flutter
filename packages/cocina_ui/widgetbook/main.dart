import 'package:cocina_ui/cocina_ui.dart';
import 'package:flutter/material.dart';

void main() => runApp(const CocinaWidgetbookApp());

class CocinaWidgetbookApp extends StatelessWidget {
  const CocinaWidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widgetbook · CocinaUI',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepOrange),
      home: Scaffold(
        appBar: AppBar(title: const Text('Catálogo Widgetbook · cocina_ui (RA3.a)')),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text('1. StepTimer - Estado Inicial (Parado)', style: TextStyle(fontWeight: FontWeight.bold)),
            StepTimer(duration: const Duration(seconds: 90), autoStart: false, onFinished: () {}),
            const SizedBox(height: 16),
            const Text('2. StepTimer - Estado AutoStart (Corriendo)', style: TextStyle(fontWeight: FontWeight.bold)),
            StepTimer(duration: const Duration(seconds: 30), autoStart: true, onFinished: () {}),
            const Divider(height: 32),
            const Text('3. IngredientChip - Raciones Base (4 raciones)', style: TextStyle(fontWeight: FontWeight.bold)),
            IngredientChip(name: 'Huevos', baseQuantity: 4, baseServings: 4, targetServings: 4, onAddToCart: (_, __, ___) {}),
            const SizedBox(height: 16),
            const Text('4. IngredientChip - Raciones Escaladas (8 raciones)', style: TextStyle(fontWeight: FontWeight.bold)),
            IngredientChip(name: 'Huevos', baseQuantity: 4, baseServings: 4, targetServings: 8, onAddToCart: (_, __, ___) {}),
          ],
        ),
      ),
    );
  }
}
