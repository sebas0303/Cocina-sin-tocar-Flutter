import 'package:cocina_ui/cocina_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controllers.dart';
import '../models/models.dart';

class _DrawerItem {
  final String title;
  final String route;
  final IconData icon;
  const _DrawerItem(this.title, this.route, this.icon);
}

/// Drawer común para navegar entre las 10 pantallas (RA1.h)
class CocinaDrawer extends StatelessWidget {
  const CocinaDrawer({super.key});

  static const List<_DrawerItem> _items = [
    _DrawerItem('1. Inicio', '/', Icons.home),
    _DrawerItem('2. Recetas', '/recetas', Icons.menu_book),
    _DrawerItem('3. Detalle e ingredientes', '/detalle', Icons.restaurant_menu),
    _DrawerItem('4. Alta y edición de receta', '/alta-receta', Icons.edit_note),
    _DrawerItem('5. Editor de pasos', '/editor-pasos', Icons.format_list_numbered),
    _DrawerItem('6. Modo cocina (NUI)', '/modo-cocina', Icons.mic),
    _DrawerItem('7. Temporizadores', '/temporizadores', Icons.timer),
    _DrawerItem('8. Lista de la compra (SUM)', '/compra', Icons.shopping_cart),
    _DrawerItem('9. Vista AR del plato', '/ar-plato', Icons.view_in_ar),
    _DrawerItem('10. Ajustes y permisos', '/ajustes', Icons.settings),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFD84315)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.soup_kitchen, color: Colors.white, size: 42),
                SizedBox(height: 8),
                Text(
                  'CocinaSinTocar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Recetario Guiado NUI · 2.º DAM',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          for (final item in _items)
            ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              onTap: () {
                Navigator.pop(context);
                context.go(item.route);
              },
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// PANTALLA 1: INICIO
// ============================================================================
class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AppStateController>();
    return Scaffold(
      appBar: AppBar(title: const Text('1. CocinaSinTocar · Inicio')),
      drawer: const CocinaDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cocina con las manos ocupadas',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Controla pasos y temporizadores con comandos de voz, levantando el brazo o mostrando la palma abierta.',
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: () => context.go('/recetas'),
                        icon: const Icon(Icons.menu_book),
                        label: Text('Ver Recetario (${ctrl.recetas.length})'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => context.go('/modo-cocina'),
                        icon: const Icon(Icons.play_circle),
                        label: const Text('Abrir Modo Cocina NUI'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Accesos directos a las 10 pantallas (RA1.h)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: const [
              _NavCard(title: 'Recetas', route: '/recetas', icon: Icons.list),
              _NavCard(title: 'Modo Cocina NUI', route: '/modo-cocina', icon: Icons.mic),
              _NavCard(title: 'Temporizadores', route: '/temporizadores', icon: Icons.timer),
              _NavCard(title: 'Compra (SUM)', route: '/compra', icon: Icons.shopping_bag),
              _NavCard(title: 'Vista AR Plato', route: '/ar-plato', icon: Icons.view_in_ar),
              _NavCard(title: 'Ajustes y Permisos', route: '/ajustes', icon: Icons.security),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  final String title;
  final String route;
  final IconData icon;
  const _NavCard({required this.title, required this.route, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.go(route),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 8),
              Expanded(child: Text(title, overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PANTALLA 2: RECETAS (Con onChanged + GestureDetector / Dismissible RA1.g)
// ============================================================================
class RecetasScreen extends StatelessWidget {
  const RecetasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AppStateController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('2. Recetas (SQLite)'),
        actions: [
          IconButton(
            onPressed: () => context.go('/alta-receta'),
            icon: const Icon(Icons.add),
            tooltip: 'Nueva Receta',
          ),
        ],
      ),
      drawer: const CocinaDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Filtrar recetas (Evento onChanged - RA1.g)',
                border: OutlineInputBorder(),
              ),
              onChanged: (valor) => ctrl.cargarTodo(filtro: valor),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: ctrl.recetas.length,
              itemBuilder: (context, index) {
                final r = ctrl.recetas[index];
                return Dismissible(
                  key: ValueKey(r.id ?? index),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => ctrl.borrarReceta(r.id!),
                  child: GestureDetector(
                    onLongPress: () => context.go('/alta-receta', extra: r),
                    child: Card(
                      child: ListTile(
                        title: Text(r.nombre),
                        subtitle: Text('${r.raciones} raciones · ${r.minutos} min'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          await ctrl.seleccionarReceta(r);
                          if (context.mounted) context.go('/detalle', extra: r);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PANTALLA 3: DETALLE E INGREDIENTES (Usa IngredientChip + Consulta JOIN RA3.h)
// ============================================================================
class DetalleRecetaScreen extends StatelessWidget {
  final Receta? receta;
  const DetalleRecetaScreen({super.key, this.receta});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AppStateController>();
    final r = receta ??
        (ctrl.recetas.isNotEmpty
            ? ctrl.recetas.first
            : const Receta(
                id: 1,
                nombre: 'Tortilla de patatas',
                raciones: 4,
                minutos: 35,
                fechaCreacion: '2026-10-22',
              ));

    return Scaffold(
      appBar: AppBar(title: Text('3. Detalle: ${r.nombre}')),
      drawer: const CocinaDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Raciones deseadas: ${ctrl.racionesSeleccionadas}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => ctrl.cambiarRaciones(ctrl.racionesSeleccionadas - 1),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  IconButton(
                    onPressed: () => ctrl.cambiarRaciones(ctrl.racionesSeleccionadas + 1),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          Text(
            'Ingredientes escalados (Componente propio IngredientChip + SQLite JOIN):',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (ctrl.ingredientesActuales.isEmpty)
                IngredientChip(
                  name: 'Huevos camperos',
                  baseQuantity: 6,
                  unit: 'ud',
                  baseServings: r.raciones,
                  targetServings: ctrl.racionesSeleccionadas,
                  onAddToCart: (name, qty, unit) {
                    ctrl.anadirIngredienteCompra(name, qty, unit);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Añadido $qty $unit de $name')),
                    );
                  },
                ),
              for (final ing in ctrl.ingredientesActuales)
                IngredientChip(
                  name: ing['nombre'] as String,
                  baseQuantity: (ing['cantidad'] as num).toDouble(),
                  unit: ing['unidad'] as String,
                  baseServings: r.raciones,
                  targetServings: ctrl.racionesSeleccionadas,
                  onAddToCart: (name, qty, unit) {
                    ctrl.anadirIngredienteCompra(name, qty, unit);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Añadido $qty $unit de $name')),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: () => context.go('/modo-cocina'),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Iniciar Modo Cocina Manos Libres'),
              ),
              OutlinedButton.icon(
                onPressed: () => context.go('/editor-pasos', extra: r),
                icon: const Icon(Icons.list_alt),
                label: const Text('Editar Pasos'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PANTALLA 4: ALTA Y EDICIÓN DE RECETA
// ============================================================================
class AltaEdicionRecetaScreen extends StatefulWidget {
  final Receta? receta;
  const AltaEdicionRecetaScreen({super.key, this.receta});

  @override
  State<AltaEdicionRecetaScreen> createState() => _AltaEdicionRecetaScreenState();
}

class _AltaEdicionRecetaScreenState extends State<AltaEdicionRecetaScreen> {
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _racionesCtrl;
  late final TextEditingController _minutosCtrl;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.receta?.nombre ?? '');
    _racionesCtrl = TextEditingController(text: (widget.receta?.raciones ?? 4).toString());
    _minutosCtrl = TextEditingController(text: (widget.receta?.minutos ?? 30).toString());
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _racionesCtrl.dispose();
    _minutosCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receta == null ? '4. Nueva Receta' : '4. Editar Receta'),
      ),
      drawer: const CocinaDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre de la receta'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _racionesCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Raciones'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _minutosCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Tiempo total (minutos)'),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () async {
                final nombre = _nombreCtrl.text.trim().isEmpty
                    ? 'Receta sin título'
                    : _nombreCtrl.text.trim();
                final raciones = int.tryParse(_racionesCtrl.text) ?? 4;
                final minutos = int.tryParse(_minutosCtrl.text) ?? 30;
                await context.read<AppStateController>().crearOEditarReceta(
                      nombre,
                      raciones,
                      minutos,
                      id: widget.receta?.id,
                    );
                if (context.mounted) context.go('/recetas');
              },
              icon: const Icon(Icons.save),
              label: const Text('Guardar en SQLite'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// PANTALLA 5: EDITOR DE PASOS
// ============================================================================
class EditorPasosScreen extends StatefulWidget {
  final Receta? receta;
  const EditorPasosScreen({super.key, this.receta});

  @override
  State<EditorPasosScreen> createState() => _EditorPasosScreenState();
}

class _EditorPasosScreenState extends State<EditorPasosScreen> {
  final _textoCtrl = TextEditingController();
  final _segCtrl = TextEditingController(text: '60');

  @override
  void dispose() {
    _textoCtrl.dispose();
    _segCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AppStateController>();
    final recetaId = widget.receta?.id ?? 1;

    return Scaffold(
      appBar: AppBar(title: const Text('5. Editor de Pasos')),
      drawer: const CocinaDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _textoCtrl,
              decoration: const InputDecoration(labelText: 'Instrucción del paso'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _segCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Duración del temporizador (segundos)',
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () {
                final seg = int.tryParse(_segCtrl.text) ?? 60;
                ctrl.anadirPaso(
                  recetaId,
                  ctrl.pasosActuales.length + 1,
                  _textoCtrl.text.isEmpty ? 'Remover suavemente' : _textoCtrl.text,
                  seg > 0 ? seg : 60,
                );
                _textoCtrl.clear();
              },
              icon: const Icon(Icons.add_task),
              label: const Text('Añadir Paso a SQLite'),
            ),
            const Divider(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: ctrl.pasosActuales.length,
                itemBuilder: (context, idx) {
                  final p = ctrl.pasosActuales[idx];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${p.orden}')),
                    title: Text(p.texto),
                    subtitle: Text('${p.segundos} seg'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// PANTALLA 6: MODO COCINA (Voz, Pose, Palma Abierta, StepTimer y Atajos RA1.g, RA2)
// ============================================================================
class ModoCocinaScreen extends StatefulWidget {
  const ModoCocinaScreen({super.key});

  @override
  State<ModoCocinaScreen> createState() => _ModoCocinaScreenState();
}

class _ModoCocinaScreenState extends State<ModoCocinaScreen> {
  final GlobalKey<StepTimerState> _timerKey = GlobalKey<StepTimerState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ctrl = context.read<AppStateController>();
    ctrl.onToggleStepTimer = () => _timerKey.currentState?.togglePause();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AppStateController>();
    final paso = ctrl.pasosActuales.isNotEmpty
        ? ctrl.pasosActuales[ctrl.indicePaso]
        : const Paso(
            recetaId: 1,
            orden: 1,
            texto: 'Pelar y cortar las patatas en láminas finas.',
            segundos: 120,
          );

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.space): () =>
            _timerKey.currentState?.togglePause(),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () =>
            ctrl.siguientePaso(origen: 'Atajo Teclado'),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(title: const Text('6. Modo Cocina Manos Libres (NUI)')),
          drawer: const CocinaDrawer(),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(ctrl.escuchandoVoz ? Icons.mic : Icons.sensors),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        ctrl.feedbackNui,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PASO ${paso.orden}',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        paso.texto,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      StepTimer(
                        key: _timerKey,
                        duration: Duration(seconds: paso.segundos > 0 ? paso.segundos : 60),
                        autoStart: false,
                        onFinished: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('¡Tiempo del paso finalizado!')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Controles Naturales (NUI) y Alternativa Táctil (RA2.b–e):',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: ctrl.alternarReconocimientoVoz,
                    icon: Icon(ctrl.escuchandoVoz ? Icons.mic_off : Icons.mic),
                    label: Text(
                      ctrl.escuchandoVoz ? 'Detener Voz' : 'Comando por Voz (RA2.c)',
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => ctrl.leerPasoActual(),
                    icon: const Icon(Icons.volume_up),
                    label: const Text('Repetir Paso (TTS)'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => ctrl.siguientePaso(origen: 'Botón Táctil'),
                    icon: const Icon(Icons.skip_next),
                    label: const Text('Siguiente Paso'),
                  ),
                  OutlinedButton.icon(
                    onPressed: ctrl.dispararPoseBrazoLevantado,
                    icon: const Icon(Icons.accessibility_new),
                    label: const Text('Pose: Levantar Brazo = Pausa Timer (RA2.d)'),
                  ),
                  OutlinedButton.icon(
                    onPressed: ctrl.dispararGestoPalmaAbierta,
                    icon: const Icon(Icons.pan_tool),
                    label: const Text('Cámara: Palma Abierta = Siguiente (RA2.e)'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => ctrl.procesarComandoVoz('añade huevos a la compra'),
                    icon: const Icon(Icons.record_voice_over),
                    label: const Text('Voz SQL: «Añade huevos a la compra»'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PANTALLA 7: TEMPORIZADORES ACTIVOS (Usa StepTimer - RA3.h)
// ============================================================================
class TemporizadoresScreen extends StatelessWidget {
  const TemporizadoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AppStateController>();
    return Scaffold(
      appBar: AppBar(title: const Text('7. Temporizadores por Paso')),
      drawer: const CocinaDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Temporizadores simultáneos generados desde los pasos de SQLite (RA3.h):',
          ),
          const SizedBox(height: 12),
          for (final p in ctrl.pasosActuales)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paso ${p.orden}: ${p.texto}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  StepTimer(
                    duration: Duration(seconds: p.segundos > 0 ? p.segundos : 60),
                    autoStart: false,
                    onFinished: () {},
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// PANTALLA 8: LISTA DE LA COMPRA (Consulta Agregada SUM y COUNT - Bloque C.5)
// ============================================================================
class ListaCompraScreen extends StatelessWidget {
  const ListaCompraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AppStateController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('8. Lista de la Compra (SUM SQLite)'),
        actions: [
          IconButton(
            onPressed: ctrl.vaciarCompra,
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Vaciar lista',
          ),
        ],
      ),
      drawer: const CocinaDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Consulta SQL con agregado SUM(cantidad) y COUNT(id)'),
              subtitle: Text(
                'Total de ingredientes distintos agrupados: ${ctrl.listaCompraAgregada.length}',
              ),
            ),
          ),
          const SizedBox(height: 8),
          for (final item in ctrl.listaCompraAgregada)
            Card(
              child: ListTile(
                leading: const Icon(Icons.check_box_outline_blank),
                title: Text('${item['nombre']}'),
                subtitle: Text('Añadido ${item['lotes_anadidos']} vez/veces'),
                trailing: Text(
                  '${item['cantidad_total']} ${item['unidad']}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// PANTALLA 9: VISTA AR DEL PLATO (Prototipo AR / Maqueta 2D a escala - RA2.f)
// ============================================================================
class VistaArPlatoScreen extends StatefulWidget {
  const VistaArPlatoScreen({super.key});

  @override
  State<VistaArPlatoScreen> createState() => _VistaArPlatoScreenState();
}

class _VistaArPlatoScreenState extends State<VistaArPlatoScreen> {
  double _escalaRacion = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('9. Vista AR del Plato (Tamaño Real)')),
      drawer: const CocinaDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.black87,
                  child: const Center(
                    child: Text(
                      'Vista de Cámara / Superficie de Mesa Detectada (ARCore / ARKit + Superposición 2D RA2.f)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                Transform.scale(
                  scale: _escalaRacion,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange.shade200,
                      border: Border.all(color: Colors.white, width: 8),
                      boxShadow: const [
                        BoxShadow(color: Colors.black54, blurRadius: 24),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.restaurant, size: 54, color: Colors.brown),
                        Text(
                          'Ración Ø 22 cm',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('Escala de ración AR:'),
                Expanded(
                  child: Slider(
                    value: _escalaRacion,
                    min: 0.6,
                    max: 1.5,
                    onChanged: (v) => setState(() => _escalaRacion = v),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PANTALLA 10: AJUSTES, PERMISOS Y AVISO DE PRIVACIDAD + LOG NUI (Bloque B.7, C.6)
// ============================================================================
class AjustesPermisosScreen extends StatelessWidget {
  const AjustesPermisosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AppStateController>();
    return Scaffold(
      appBar: AppBar(title: const Text('10. Ajustes, Permisos y Privacidad')),
      drawer: const CocinaDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Modo Oscuro (Material 3 ThemeData - RA1.d)'),
            value: ctrl.themeMode == ThemeMode.dark,
            onChanged: ctrl.toggleTheme,
          ),
          const Divider(),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.privacy_tip),
                      SizedBox(width: 8),
                      Text(
                        'Aviso de Privacidad y Permisos NUI (Bloque B.7)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'CocinaSinTocar procesa las imágenes de cámara (ML Kit Pose Detection) y la voz 100 % en local dentro del dispositivo. Ninguna imagen ni grabación de audio se envía a servidores externos. Los recursos de cámara y micrófono se liberan automáticamente en el método dispose().',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Registro SQLite de interacciones NUI (Bloque C.6):',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final log in ctrl.historialNui)
            ListTile(
              dense: true,
              leading: const Icon(Icons.history),
              title: Text('[${log['tipo']}] ${log['comando']} -> ${log['accion']}'),
              subtitle: Text('${log['fecha_hora']}'),
            ),
        ],
      ),
    );
  }
}