import 'package:go_router/go_router.dart';
import '../../models/models.dart';
import '../../views/screens.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const InicioScreen()),
    GoRoute(path: '/recetas', builder: (context, state) => const RecetasScreen()),
    GoRoute(
      path: '/detalle',
      builder: (context, state) {
        final receta = state.extra as Receta?;
        return DetalleRecetaScreen(receta: receta);
      },
    ),
    GoRoute(
      path: '/alta-receta',
      builder: (context, state) {
        final receta = state.extra as Receta?;
        return AltaEdicionRecetaScreen(receta: receta);
      },
    ),
    GoRoute(
      path: '/editor-pasos',
      builder: (context, state) {
        final receta = state.extra as Receta?;
        return EditorPasosScreen(receta: receta);
      },
    ),
    GoRoute(path: '/modo-cocina', builder: (context, state) => const ModoCocinaScreen()),
    GoRoute(path: '/temporizadores', builder: (context, state) => const TemporizadoresScreen()),
    GoRoute(path: '/compra', builder: (context, state) => const ListaCompraScreen()),
    GoRoute(path: '/ar-plato', builder: (context, state) => const VistaArPlatoScreen()),
    GoRoute(path: '/ajustes', builder: (context, state) => const AjustesPermisosScreen()),
  ],
);
