import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:drift/native.dart';

part 'database.g.dart';

@DataClassName('TareaRegistro')
class Tareas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get titulo => text().withLength(min: 1, max: 200)();
  BoolColumn get completada => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Tareas])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);
  AppDatabase.abrir() : super(_abrirConexion());
  AppDatabase.enMemoria()
    : super(DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,  // clave para pruebas de widget
      ));

// Crear
Future<int> agregarTarea(String titulo) {
  return into(tareas).insert(TareasCompanion.insert(titulo: titulo));
}

// Consultar reactivamente
Stream<List<TareaRegistro>> observarTareas() {
  return select(tareas).watch();
}

// Consultar una vez (útil para pruebas)
Future<List<TareaRegistro>> obtenerTareas() {
  return select(tareas).get();
}

// Actualizar título
Future<int> actualizarTitulo(int id, String nuevoTitulo) {
  return (update(tareas)..where((t) => t.id.equals(id)))
      .write(TareasCompanion(titulo: Value(nuevoTitulo)));
}

// Alternar completada
Future<int> alternarCompletada(int id, bool completada) {
  return (update(tareas)..where((t) => t.id.equals(id)))
      .write(TareasCompanion(completada: Value(completada)));
}

// Eliminar
Future<int> eliminarTarea(int id) {
  return (delete(tareas)..where((t) => t.id.equals(id))).go();
}

  @override
  int get schemaVersion => 1;
}

QueryExecutor _abrirConexion() {
  return driftDatabase(
    name: 'gestor_tareas',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}

