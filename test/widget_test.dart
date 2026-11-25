import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/main.dart';
import 'package:gestor_tareas_local/data/database.dart';

void main() {
  testWidgets('La pantalla de tareas se abre correctamente', (tester) async {
    final db = AppDatabase.enMemoria();  // no uses .abrir()
    await tester.pumpWidget(MyApp(db: db));
    expect(find.text('Gestor de tareas'), findsOneWidget);
    await db.close();  // limpieza
  });
}