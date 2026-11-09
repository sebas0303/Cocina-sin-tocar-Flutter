import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;
  static const int _version = 1;
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

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

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

    await db.insert('ingrediente', {'nombre': 'Huevos', 'unidad': 'ud'});
    await db.insert('ingrediente', {'nombre': 'Patatas', 'unidad': 'g'});
    await db.insert('ingrediente', {'nombre': 'Aceite de oliva', 'unidad': 'ml'});
    await db.insert('ingrediente', {'nombre': 'Calabacín', 'unidad': 'g'});
    await db.insert('ingrediente', {'nombre': 'Cebolla', 'unidad': 'g'});

    await db.insert('receta_ingrediente', {'receta_id': 1, 'ingrediente_id': 1, 'cantidad': 6.0});
    await db.insert('receta_ingrediente', {'receta_id': 1, 'ingrediente_id': 2, 'cantidad': 700.0});
    await db.insert('receta_ingrediente', {'receta_id': 1, 'ingrediente_id': 3, 'cantidad': 150.0});

    await db.insert('paso', {'receta_id': 1, 'orden': 1, 'texto': 'Pelar y cortar las patatas en láminas finas.', 'segundos': 120});
    await db.insert('paso', {'receta_id': 1, 'orden': 2, 'texto': 'Freír las patatas a fuego medio en aceite de oliva.', 'segundos': 300});
    await db.insert('paso', {'receta_id': 1, 'orden': 3, 'texto': 'Batir los huevos, mezclar y cuajar en la sartén.', 'segundos': 180});

    await db.insert('lista_compra', {'ingrediente_id': 1, 'cantidad': 6.0, 'comprado': 0});
    await db.insert('lista_compra', {'ingrediente_id': 2, 'cantidad': 700.0, 'comprado': 0});
  }
}
