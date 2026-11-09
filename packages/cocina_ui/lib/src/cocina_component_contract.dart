/// Contrato abstracto compartido por los componentes visuales de CocinaSinTocar (RA3.b).
abstract class CocinaInteractiveComponent {
  /// Descripción semántica accesible para síntesis de voz y lectores de pantalla.
  String get semanticDescription;

  /// Indica si el componente soporta interacción manos libres (NUI).
  bool get supportsHandsFree;
}
