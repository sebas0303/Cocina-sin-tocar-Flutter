import 'package:flutter/material.dart';
import 'cocina_component_contract.dart';

typedef OnIngredientAddToCart = void Function(String name, double scaledQuantity, String unit);

class IngredientChip extends StatelessWidget implements CocinaInteractiveComponent {
  final String name;
  final double baseQuantity;
  final String unit;
  final int baseServings;
  final int targetServings;
  final OnIngredientAddToCart onAddToCart;

  IngredientChip({
    super.key,
    required this.name,
    required this.baseQuantity,
    this.unit = 'ud',
    this.baseServings = 4,
    this.targetServings = 4,
    required this.onAddToCart,
  })  : assert(baseQuantity > 0, 'baseQuantity debe ser mayor que 0'),
        assert(baseServings > 0, 'baseServings debe ser mayor que 0'),
        assert(targetServings > 0, 'targetServings debe ser mayor que 0');

  double get scaledQuantity => (baseQuantity * targetServings) / baseServings;

  @override
  String get semanticDescription => '$name: $scaledQuantity $unit';

  @override
  bool get supportsHandsFree => true;

  @override
  Widget build(BuildContext context) {
    final textQty = scaledQuantity % 1 == 0
        ? scaledQuantity.toInt().toString()
        : scaledQuantity.toStringAsFixed(1);
    return ActionChip(
      avatar: const Icon(Icons.add_shopping_cart, size: 18),
      label: Text('$name ($textQty $unit)'),
      onPressed: () => onAddToCart(name, scaledQuantity, unit),
    );
  }
}
