import 'package:flutter/material.dart';

/// Solo cambian los COLORES (paleta crema + naranja terracota).
/// La forma de botones, tarjetas, etc. se queda como en el proyecto original.
class AppTheme {
  static const Color _seedColor = Color(0xFFD95C38); // naranja de los botones
  static const Color _cream = Color(0xFFFFF8F2); // fondo de la app
  static const Color _card = Color(0xFFFFFFFF); // tarjetas / listas
  static const Color _peach = Color(0xFFFDE7DD); // chips, contenedores suaves
  static const Color _brown = Color(0xFF3B2A22); // texto principal

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ).copyWith(
      primary: _seedColor,
      onPrimary: Colors.white,
      primaryContainer: _peach,
      onPrimaryContainer: const Color(0xFF5A2A18),
      secondaryContainer: _peach,
      onSecondaryContainer: const Color(0xFF5A2A18),
      surface: _cream,
      onSurface: _brown,
      surfaceContainerLowest: _card,
      surfaceContainerLow: _card,
      surfaceContainer: const Color(0xFFFFF1E8),
      surfaceContainerHigh: _peach,
      surfaceContainerHighest: _peach,
      outline: const Color(0xFF8C7A70),
      outlineVariant: const Color(0xFFEADFD6),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: _cream,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
    );
  }

  // Modo oscuro: igual que el original.
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
    );
  }
}
