import '../core/database/database_helper.dart';
import '../models/models.dart';

class CocinaRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Receta>> obtenerRecetas({String filtro = ''}) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'receta',
      where: filtro.isEmpty ? null : 'LOWER(nombre) LIKE ?',
      whereArgs: filtro.isEmpty ? null : ['%${filtro.toLowerCase()}%'],
      orderBy: 'id DESC',
    );
    return rows.map(Receta.fromMap).toList();
  }

  Future<int> guardarReceta(Receta receta) async {
    final db = await _dbHelper.database;
    if (receta.id == null) {
      return await db.insert('receta', receta.toMap());
    }
    return await db.update(
      'receta',
      receta.toMap(),
      where: 'id = ?',
      whereArgs: [receta.id],
    );
  }

  Future<void> eliminarReceta(int id) async {
    final db = await _dbHelper.database;
    await db.delete('receta', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Paso>> obtenerPasosDeReceta(int recetaId) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'paso',
      where: 'receta_id = ?',
      whereArgs: [recetaId],
      orderBy: 'orden ASC',
    );
    return rows.map(Paso.fromMap).toList();
  }

  Future<void> insertarPaso(Paso paso) async {
    final db = await _dbHelper.database;
    await db.insert('paso', paso.toMap());
  }

  Future<List<Map<String, dynamic>>> obtenerIngredientesJoin(int recetaId) async {
    final db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT i.id, i.nombre, i.unidad, ri.cantidad
      FROM receta_ingrediente ri
      INNER JOIN ingrediente i ON ri.ingrediente_id = i.id
      WHERE ri.receta_id = ?
      ORDER BY i.nombre ASC
    ''', [recetaId]);
  }

  Future<List<Map<String, dynamic>>> obtenerListaCompraAgregada() async {
    final db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT i.id AS ingrediente_id,
             i.nombre,
             i.unidad,
             SUM(lc.cantidad) AS cantidad_total,
             COUNT(lc.id) AS lotes_anadidos
      FROM lista_compra lc
      INNER JOIN ingrediente i ON lc.ingrediente_id = i.id
      WHERE lc.comprado = ?
      GROUP BY i.id, i.nombre, i.unidad
      ORDER BY i.nombre ASC
    ''', [0]);
  }

  Future<void> anadirACompraPorNombre(String nombre, double cantidad, String unidad) async {
    final db = await _dbHelper.database;
    final existentes = await db.query(
      'ingrediente',
      where: 'LOWER(nombre) = LOWER(?)',
      whereArgs: [nombre.trim()],
    );

    int ingId;
    if (existentes.isNotEmpty) {
      ingId = existentes.first['id'] as int;
    } else {
      ingId = await db.insert('ingrediente', {
        'nombre': nombre.trim(),
        'unidad': unidad,
      });
    }

    await db.insert('lista_compra', {
      'ingrediente_id': ingId,
      'cantidad': cantidad,
      'comprado': 0,
    });
  }

  Future<void> limpiarListaCompra() async {
    final db = await _dbHelper.database;
    await db.delete('lista_compra', where: 'comprado = ?', whereArgs: [0]);
  }

  Future<void> registrarEventoNui(String tipo, String comando, String accion) async {
    final db = await _dbHelper.database;
    await db.insert('registro_nui', {
      'tipo': tipo,
      'comando': comando,
      'accion': accion,
      'fecha_hora': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> obtenerHistorialNui() async {
    final db = await _dbHelper.database;
    return await db.query('registro_nui', orderBy: 'id DESC', limit: 15);
  }
}
