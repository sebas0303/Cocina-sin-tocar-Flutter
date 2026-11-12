import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'controllers/app_controllers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppStateController(),
      child: const CocinaSinTocarApp(),
    ),
  );
}

class CocinaSinTocarApp extends StatelessWidget {
  const CocinaSinTocarApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AppStateController>();
    return MaterialApp.router(
      title: 'CocinaSinTocar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ctrl.themeMode,
      locale: ctrl.locale,
      supportedLocales: const [Locale('es'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: appRouter,
    );
  }
}
