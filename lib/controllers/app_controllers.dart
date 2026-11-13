import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../models/models.dart';
import '../repositories/cocina_repository.dart';

class AppStateController extends ChangeNotifier {
  final CocinaRepository repository = CocinaRepository();
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  final PoseDetector _poseDetector = PoseDetector(
    options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
  );

  ThemeMode themeMode = ThemeMode.light;
  Locale locale = const Locale('es');

  List<Receta> recetas = [];
  List<Paso> pasosActuales = [];
  List<Map<String, dynamic>> ingredientesActuales = [];
  List<Map<String, dynamic>> listaCompraAgregada = [];
  List<Map<String, dynamic>> historialNui = [];

  int? recetaActualId;
  int indicePaso = 0;
  int racionesSeleccionadas = 4;
  bool escuchandoVoz = false;
  String feedbackNui = 'NUI lista: Usa voz, gestos o botones táctiles.';

  VoidCallback? onToggleStepTimer;

  AppStateController() {
    _initTts();
    cargarTodo();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('es-ES');
    await _tts.setSpeechRate(0.5);
  }

  Future<void> cargarTodo({String filtro = ''}) async {
    recetas = await repository.obtenerRecetas(filtro: filtro);
    listaCompraAgregada = await repository.obtenerListaCompraAgregada();
    historialNui = await repository.obtenerHistorialNui();
    notifyListeners();
  }

  Future<void> seleccionarReceta(Receta receta) async {
    recetaActualId = receta.id;
    racionesSeleccionadas = receta.raciones;
    pasosActuales = await repository.obtenerPasosDeReceta(receta.id ?? 1);
    if (pasosActuales.isEmpty) {
      pasosActuales = [
        Paso(recetaId: receta.id ?? 1, orden: 1, texto: 'Preparar los ingredientes en la encimera.', segundos: 90),
        Paso(recetaId: receta.id ?? 1, orden: 2, texto: 'Cocinar a fuego medio y emplatar.', segundos: 180),
      ];
    }
    ingredientesActuales = await repository.obtenerIngredientesJoin(receta.id ?? 1);
    indicePaso = 0;
    notifyListeners();
  }

  void cambiarRaciones(int nuevasRaciones) {
    if (nuevasRaciones > 0) {
      racionesSeleccionadas = nuevasRaciones;
      notifyListeners();
    }
  }

  void toggleTheme(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> crearOEditarReceta(String nombre, int raciones, int minutos,
      {int? id, String ingredientesTexto = ''}) async {
    final recetaId = await repository.guardarReceta(Receta(
      id: id,
      nombre: nombre,
      raciones: raciones,
      minutos: minutos,
      fechaCreacion: DateTime.now().toIso8601String(),
    ));
    await repository.guardarIngredientesReceta(recetaId, ingredientesTexto);
    recetaActualId = null; // fuerza recarga de ingredientes en el detalle
    await cargarTodo();
  }

  /// Añade todos los ingredientes de la receta actual a la compra,
  /// escalados a las raciones seleccionadas.
  Future<void> anadirTodosALaCompra(int racionesBase) async {
    final factor = racionesSeleccionadas / racionesBase;
    for (final ing in ingredientesActuales) {
      await repository.anadirACompraPorNombre(
        ing['nombre'] as String,
        (ing['cantidad'] as num).toDouble() * factor,
        ing['unidad'] as String,
      );
    }
    await repository.registrarEventoNui(
        'Táctil', 'Añadir todo', 'INSERT lista_compra (${ingredientesActuales.length} ingredientes)');
    await cargarTodo();
  }

  Future<void> borrarReceta(int id) async {
    await repository.eliminarReceta(id);
    await cargarTodo();
  }

  Future<void> anadirPaso(int recetaId, int orden, String texto, int segundos) async {
    await repository.insertarPaso(Paso(
      recetaId: recetaId,
      orden: orden,
      texto: texto,
      segundos: segundos,
    ));
    pasosActuales = await repository.obtenerPasosDeReceta(recetaId);
    notifyListeners();
  }

  Future<void> anadirIngredienteCompra(String nombre, double cantidad, String unidad, {String origen = 'Táctil'}) async {
    await repository.anadirACompraPorNombre(nombre, cantidad, unidad);
    await repository.registrarEventoNui(origen, 'Añadir $nombre', 'INSERT lista_compra ($cantidad $unidad)');
    await cargarTodo();
  }

  Future<void> vaciarCompra() async {
    await repository.limpiarListaCompra();
    await cargarTodo();
  }

  Future<void> leerPasoActual({String origen = 'TTS'}) async {
    if (pasosActuales.isEmpty) return;
    final p = pasosActuales[indicePaso];
    feedbackNui = '[$origen] Leyendo paso ${p.orden}: "${p.texto}"';
    notifyListeners();
    await _tts.speak('Paso ${p.orden}. ${p.texto}');
    await repository.registrarEventoNui(origen, 'repite', 'Lectura TTS paso ${p.orden}');
    historialNui = await repository.obtenerHistorialNui();
    notifyListeners();
  }

  Future<void> siguientePaso({String origen = 'Táctil'}) async {
    if (pasosActuales.isEmpty) return;
    if (indicePaso < pasosActuales.length - 1) {
      indicePaso++;
      feedbackNui = '[$origen] Avanzado al paso ${indicePaso + 1}';
      await repository.registrarEventoNui(origen, 'siguiente paso', 'Avanzar a paso ${indicePaso + 1}');
      await leerPasoActual(origen: origen);
    } else {
      feedbackNui = '[$origen] ¡Receta finalizada!';
      await _tts.speak('Has completado todos los pasos de la receta.');
    }
    historialNui = await repository.obtenerHistorialNui();
    notifyListeners();
  }

  Future<void> dispararPoseBrazoLevantado() async {
    onToggleStepTimer?.call();
    feedbackNui = '[Pose RA2.d] Brazo levantado detectado -> Pausa/Reanuda StepTimer';
    await repository.registrarEventoNui('Pose ML Kit', 'Brazo levantado', 'Pausar/Reanudar StepTimer');
    historialNui = await repository.obtenerHistorialNui();
    notifyListeners();
  }

  Future<void> dispararGestoPalmaAbierta() async {
    await siguientePaso(origen: 'Cámara RA2.e (Palma Abierta)');
  }

  Future<void> alternarReconocimientoVoz() async {
    if (escuchandoVoz) {
      await _speech.stop();
      escuchandoVoz = false;
      notifyListeners();
      return;
    }

    final ok = await _speech.initialize();
    if (!ok) {
      feedbackNui = 'Micrófono no disponible en este entorno. Usa los botones de acción NUI.';
      notifyListeners();
      return;
    }

    escuchandoVoz = true;
    feedbackNui = 'Escuchando («siguiente paso», «repite», «añade huevos a la compra»)...';
    notifyListeners();

    await _speech.listen(
      localeId: 'es_ES',
      onResult: (res) async {
        if (!res.finalResult) return;
        await procesarComandoVoz(res.recognizedWords.toLowerCase());
      },
    );
  }

  Future<void> procesarComandoVoz(String comando) async {
    escuchandoVoz = false;
    if (comando.contains('siguiente')) {
      await siguientePaso(origen: 'Voz (speech_to_text)');
    } else if (comando.contains('repite')) {
      await leerPasoActual(origen: 'Voz (speech_to_text)');
    } else if (comando.contains('añade') && comando.contains('compra')) {
      final regex = RegExp(r'añade\s+(.+?)\s+a la compra');
      final match = regex.firstMatch(comando);
      final ingrediente = match?.group(1) ?? 'Huevos';
      await anadirIngredienteCompra(ingrediente, 2, 'ud', origen: 'Voz (speech_to_text)');
      feedbackNui = '[Voz -> SQLite] Añadido "$ingrediente" a la lista de la compra';
      await _tts.speak('Añadido $ingrediente a la lista de la compra');
    } else {
      feedbackNui = 'Comando de voz no reconocido: "$comando"';
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _speech.stop();
    _tts.stop();
    _poseDetector.close();
    super.dispose();
  }
}
