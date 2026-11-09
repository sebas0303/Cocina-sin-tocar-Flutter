class Receta {
  final int? id;
  final String nombre;
  final int raciones;
  final int minutos;
  final String fechaCreacion;

  const Receta({
    this.id,
    required this.nombre,
    required this.raciones,
    required this.minutos,
    required this.fechaCreacion,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'nombre': nombre,
        'raciones': raciones,
        'minutos': minutos,
        'fecha_creacion': fechaCreacion,
      };

  factory Receta.fromMap(Map<String, dynamic> map) => Receta(
        id: map['id'] as int?,
        nombre: map['nombre'] as String,
        raciones: map['raciones'] as int,
        minutos: map['minutos'] as int,
        fechaCreacion: map['fecha_creacion'] as String,
      );
}

class Ingrediente {
  final int? id;
  final String nombre;
  final String unidad;

  const Ingrediente({this.id, required this.nombre, required this.unidad});

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'nombre': nombre,
        'unidad': unidad,
      };

  factory Ingrediente.fromMap(Map<String, dynamic> map) => Ingrediente(
        id: map['id'] as int?,
        nombre: map['nombre'] as String,
        unidad: map['unidad'] as String,
      );
}

class Paso {
  final int? id;
  final int recetaId;
  final int orden;
  final String texto;
  final int segundos;

  const Paso({
    this.id,
    required this.recetaId,
    required this.orden,
    required this.texto,
    required this.segundos,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'receta_id': recetaId,
        'orden': orden,
        'texto': texto,
        'segundos': segundos,
      };

  factory Paso.fromMap(Map<String, dynamic> map) => Paso(
        id: map['id'] as int?,
        recetaId: map['receta_id'] as int,
        orden: map['orden'] as int,
        texto: map['texto'] as String,
        segundos: map['segundos'] as int,
      );
}
