# Gestor de tareas con SQLite (Drift)

Práctica de Programación de Dispositivos Móviles — 7.º semestre
Universidad Autónoma de Aguascalientes — Ingeniería en Sistemas Computacionales

Aplicación Flutter que administra tareas con persistencia local en SQLite.
Sin servidor, sin MySQL, sin API REST. La misma base de código está diseñada
para Android, iOS, Windows, Linux, macOS y web.

---

## 1. Tecnología de persistencia elegida

**Drift + drift_flutter** (SQLite tipado y reactivo para Dart/Flutter).

### Justificación

- Una sola base de código para móvil, escritorio y web.
- Consultas type-safe generadas con `build_runner` (menos errores en tiempo de ejecución).
- Soporte reactivo nativo mediante `Stream`, ideal para actualizar la UI tras cada escritura.
- `drift_flutter` abstrae la apertura de la base en cada plataforma (incluido web con WebAssembly).
- Alternativas descartadas: `sqflite` (no soporta escritorio ni web de forma uniforme),
  `shared_preferences` con JSON (no es SQLite real y no cumple la consigna).

---

## 2. Diseño de la tabla `tareas`

| Columna     | Tipo    | Restricciones                  |
|-------------|---------|--------------------------------|
| `id`        | INTEGER | PRIMARY KEY AUTOINCREMENT      |
| `titulo`    | TEXT    | NOT NULL, longitud entre 1 y 200 |
| `completada`| BOOLEAN | NOT NULL, valor por defecto `false` |

**Identificación de registros:** cada tarea se identifica por su `id` autoincremental,
que se usa en las operaciones de actualización y eliminación.

Definición en Drift (`lib/data/database.dart`):

```dart
@DataClassName('TareaRegistro')
class Tareas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get titulo => text().withLength(min: 1, max: 200)();
  BoolColumn get completada => boolean().withDefault(const Constant(false))();
}