import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;
  static const int _version = 2;
  static const String _dbName = 'cocina_sin_tocar.db';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final Directory dir = await getApplicationDocumentsDirectory();
    final String path = join(dir.path, _dbName);

    return await openDatabase(
      path,
      version: _version,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE receta (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        raciones INTEGER NOT NULL,
        minutos INTEGER NOT NULL,
        fecha_creacion TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ingrediente (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL UNIQUE,
        unidad TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE receta_ingrediente (
        receta_id INTEGER NOT NULL,
        ingrediente_id INTEGER NOT NULL,
        cantidad REAL NOT NULL,
        PRIMARY KEY (receta_id, ingrediente_id),
        FOREIGN KEY (receta_id) REFERENCES receta(id) ON DELETE CASCADE,
        FOREIGN KEY (ingrediente_id) REFERENCES ingrediente(id) ON DELETE RESTRICT
      )
    ''');

    await db.execute('''
      CREATE TABLE paso (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        receta_id INTEGER NOT NULL,
        orden INTEGER NOT NULL,
        texto TEXT NOT NULL,
        segundos INTEGER NOT NULL,
        FOREIGN KEY (receta_id) REFERENCES receta(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE lista_compra (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ingrediente_id INTEGER NOT NULL,
        cantidad REAL NOT NULL,
        comprado INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (ingrediente_id) REFERENCES ingrediente(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE registro_nui (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT NOT NULL,
        comando TEXT NOT NULL,
        accion TEXT NOT NULL,
        fecha_hora TEXT NOT NULL
      )
    ''');

    await _seedData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // v2: completa ingredientes y pasos de las recetas de ejemplo.
    if (oldVersion < 2) await _seedDetalleRecetas(db);
  }

  Future<void> _seedData(Database db) async {
    final now = DateTime.now().toIso8601String();
    final recetas = [
      {'nombre': 'Tortilla de patatas clásica', 'raciones': 4, 'minutos': 35, 'fecha_creacion': now},
      {'nombre': 'Salmorejo cordobés', 'raciones': 4, 'minutos': 15, 'fecha_creacion': now},
      {'nombre': 'Arroz caldero del Mar Menor', 'raciones': 4, 'minutos': 50, 'fecha_creacion': now},
      {'nombre': 'Zarangollo murciano', 'raciones': 2, 'minutos': 30, 'fecha_creacion': now},
      {'nombre': 'Lentejas estofadas con verduras', 'raciones': 6, 'minutos': 45, 'fecha_creacion': now},
      {'nombre': 'Pollo al ajillo dorado', 'raciones': 4, 'minutos': 40, 'fecha_creacion': now},
      {'nombre': 'Merluza en salsa verde', 'raciones': 2, 'minutos': 25, 'fecha_creacion': now},
      {'nombre': 'Pisto tradicional con huevo', 'raciones': 4, 'minutos': 35, 'fecha_creacion': now},
      {'nombre': 'Crema suave de calabaza', 'raciones': 4, 'minutos': 30, 'fecha_creacion': now},
      {'nombre': 'Arroz con leche cremoso', 'raciones': 6, 'minutos': 55, 'fecha_creacion': now},
    ];

    for (final r in recetas) {
      await db.insert('receta', r);
    }

    await _seedDetalleRecetas(db);

    await db.insert('lista_compra', {'ingrediente_id': 1, 'cantidad': 6.0, 'comprado': 0});
    await db.insert('lista_compra', {'ingrediente_id': 2, 'cantidad': 700.0, 'comprado': 0});
  }

  /// Ingredientes (nombre, cantidad, unidad) y pasos (texto, segundos)
  /// de las 10 recetas de ejemplo. Es idempotente: solo rellena las
  /// recetas que aún no tienen ingredientes / pasos.
  static const Map<String, List<List<Object>>> _ingredientesSeed = {
    'Tortilla de patatas clásica': [['Huevos', 6, 'ud'], ['Patatas', 700, 'g'], ['Cebolla', 150, 'g'], ['Aceite de oliva', 150, 'ml'], ['Sal', 5, 'g']],
    'Salmorejo cordobés': [['Tomates maduros', 1000, 'g'], ['Pan', 200, 'g'], ['Ajo', 1, 'diente'], ['Aceite de oliva', 100, 'ml'], ['Vinagre de Jerez', 20, 'ml'], ['Huevos', 2, 'ud'], ['Jamón serrano', 60, 'g']],
    'Arroz caldero del Mar Menor': [['Arroz', 320, 'g'], ['Pescado de roca', 600, 'g'], ['Ñora', 2, 'ud'], ['Tomate', 200, 'g'], ['Ajo', 4, 'diente'], ['Aceite de oliva', 80, 'ml'], ['Caldo de pescado', 900, 'ml']],
    'Zarangollo murciano': [['Calabacín', 600, 'g'], ['Cebolla', 200, 'g'], ['Huevos', 4, 'ud'], ['Aceite de oliva', 60, 'ml'], ['Sal', 4, 'g']],
    'Lentejas estofadas con verduras': [['Lentejas', 400, 'g'], ['Zanahoria', 200, 'g'], ['Cebolla', 150, 'g'], ['Pimiento verde', 100, 'g'], ['Patatas', 300, 'g'], ['Ajo', 2, 'diente'], ['Pimentón dulce', 5, 'g'], ['Aceite de oliva', 50, 'ml']],
    'Pollo al ajillo dorado': [['Pollo troceado', 1000, 'g'], ['Ajo', 8, 'diente'], ['Vino blanco', 100, 'ml'], ['Aceite de oliva', 80, 'ml'], ['Perejil', 10, 'g'], ['Sal', 5, 'g']],
    'Merluza en salsa verde': [['Merluza', 500, 'g'], ['Ajo', 3, 'diente'], ['Perejil', 20, 'g'], ['Harina', 20, 'g'], ['Caldo de pescado', 250, 'ml'], ['Almejas', 150, 'g'], ['Aceite de oliva', 50, 'ml']],
    'Pisto tradicional con huevo': [['Tomate triturado', 500, 'g'], ['Calabacín', 300, 'g'], ['Pimiento rojo', 200, 'g'], ['Cebolla', 150, 'g'], ['Huevos', 4, 'ud'], ['Aceite de oliva', 60, 'ml']],
    'Crema suave de calabaza': [['Calabaza', 800, 'g'], ['Cebolla', 150, 'g'], ['Patatas', 200, 'g'], ['Caldo de verduras', 700, 'ml'], ['Nata', 100, 'ml'], ['Aceite de oliva', 30, 'ml']],
    'Arroz con leche cremoso': [['Arroz', 200, 'g'], ['Leche entera', 1500, 'ml'], ['Azúcar', 120, 'g'], ['Canela en rama', 1, 'ud'], ['Piel de limón', 1, 'ud']],
  };

  static const Map<String, List<List<Object>>> _pasosSeed = {
    'Tortilla de patatas clásica': [['Pelar y cortar las patatas en láminas finas.', 120], ['Freír las patatas a fuego medio en aceite de oliva.', 300], ['Batir los huevos, mezclar y cuajar en la sartén.', 180]],
    'Salmorejo cordobés': [['Triturar los tomates con el ajo y el pan remojado.', 120], ['Añadir el aceite poco a poco y el vinagre; triturar hasta emulsionar.', 90], ['Enfriar en la nevera y servir con huevo cocido y jamón.', 1800]],
    'Arroz caldero del Mar Menor': [['Sofreír el ajo, la ñora y el tomate en el caldero.', 300], ['Añadir el arroz y el caldo de pescado caliente.', 120], ['Cocer a fuego fuerte y luego suave hasta que el arroz esté en su punto.', 1080], ['Reposar el arroz tapado.', 300]],
    'Zarangollo murciano': [['Cortar el calabacín y la cebolla en láminas finas.', 180], ['Pochar las verduras a fuego lento hasta que estén tiernas.', 900], ['Añadir los huevos batidos y remover hasta cuajar.', 180]],
    'Lentejas estofadas con verduras': [['Sofreír la cebolla, el pimiento y la zanahoria.', 420], ['Añadir lentejas, patata, pimentón y cubrir con agua.', 120], ['Cocer a fuego medio hasta que las lentejas estén tiernas.', 1800]],
    'Pollo al ajillo dorado': [['Salar el pollo y dorarlo en aceite caliente.', 480], ['Añadir los ajos laminados y dorar sin que se quemen.', 120], ['Verter el vino y cocer hasta que se reduzca.', 600], ['Espolvorear perejil y servir.', 30]],
    'Merluza en salsa verde': [['Dorar el ajo en aceite y añadir la harina.', 90], ['Incorporar el caldo y el perejil; cocer la salsa.', 300], ['Añadir la merluza y las almejas y cocinar suavemente.', 480]],
    'Pisto tradicional con huevo': [['Pochar la cebolla y el pimiento en aceite.', 480], ['Añadir el calabacín y cocinar a fuego medio.', 600], ['Incorporar el tomate y cocer hasta reducir.', 900], ['Servir con un huevo frito encima.', 180]],
    'Crema suave de calabaza': [['Pochar la cebolla y añadir la calabaza y la patata en dados.', 420], ['Cubrir con caldo y cocer hasta que todo esté blando.', 1200], ['Triturar con la nata hasta obtener una crema fina.', 120]],
    'Arroz con leche cremoso': [['Hervir el arroz en agua unos minutos y escurrir.', 300], ['Cocer el arroz en la leche con canela y limón, removiendo.', 2400], ['Añadir el azúcar y cocer unos minutos más.', 300]],
  };

  Future<void> _seedDetalleRecetas(Database db) async {
    for (final nombre in _ingredientesSeed.keys) {
      final rec = await db.query('receta', where: 'nombre = ?', whereArgs: [nombre]);
      if (rec.isEmpty) continue;
      final recetaId = rec.first['id'] as int;

      final tieneIng = await db.query('receta_ingrediente',
          where: 'receta_id = ?', whereArgs: [recetaId], limit: 1);
      if (tieneIng.isEmpty) {
        for (final ing in _ingredientesSeed[nombre]!) {
          final nom = ing[0] as String;
          final ex = await db.query('ingrediente',
              where: 'LOWER(nombre) = LOWER(?)', whereArgs: [nom]);
          final ingId = ex.isNotEmpty
              ? ex.first['id'] as int
              : await db.insert('ingrediente', {'nombre': nom, 'unidad': ing[2] as String});
          await db.insert('receta_ingrediente', {
            'receta_id': recetaId,
            'ingrediente_id': ingId,
            'cantidad': (ing[1] as num).toDouble(),
          });
        }
      }

      final tienePasos = await db.query('paso',
          where: 'receta_id = ?', whereArgs: [recetaId], limit: 1);
      if (tienePasos.isEmpty) {
        var orden = 1;
        for (final p in _pasosSeed[nombre]!) {
          await db.insert('paso', {
            'receta_id': recetaId,
            'orden': orden++,
            'texto': p[0] as String,
            'segundos': p[1] as int,
          });
        }
      }
    }
  }
}
