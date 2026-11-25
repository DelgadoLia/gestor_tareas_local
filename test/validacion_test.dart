import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/main.dart';
import 'package:gestor_tareas_local/data/database.dart';
void main() {
  testWidgets('No agrega tarea con título vacío', (tester) async {
    final db = AppDatabase.enMemoria();
    await tester.pumpWidget(MyApp(db: db));

    // Tocar el botón "+" sin escribir nada
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Debe aparecer el SnackBar de error
    expect(find.text('El título no puede estar vacío'), findsOneWidget);

    // La lista sigue vacía
    expect(find.text('No hay tareas todavía'), findsOneWidget);

    await db.close();
  });

  testWidgets('Agrega una tarea y la muestra en la lista', (tester) async {
    final db = AppDatabase.enMemoria();
    await tester.pumpWidget(MyApp(db: db));

    await tester.enterText(find.byType(TextField), 'Estudiar Drift');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Estudiar Drift'), findsOneWidget);

    await db.close();
  });
}