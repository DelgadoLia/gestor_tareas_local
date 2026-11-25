import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/data/database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.enMemoria();
  });

  tearDown(() async {
    await db.close();
  });

  test('Agregar una tarea y consultarla', () async {
    await db.agregarTarea('Comprar leche');
    final tareas = await db.obtenerTareas();
    expect(tareas.length, 1);
    expect(tareas.first.titulo, 'Comprar leche');
    expect(tareas.first.completada, false);
  });

  test('Actualizar título, estado y eliminar', () async {
    final id = await db.agregarTarea('Original');

    await db.actualizarTitulo(id, 'Editado');
    await db.alternarCompletada(id, true);

    var tareas = await db.obtenerTareas();
    expect(tareas.first.titulo, 'Editado');
    expect(tareas.first.completada, true);

    await db.eliminarTarea(id);
    tareas = await db.obtenerTareas();
    expect(tareas, isEmpty);
  });
}