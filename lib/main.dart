import 'package:flutter/material.dart';
import 'data/database.dart';
import 'screens/tareas_page.dart';

void main() {
  final db = AppDatabase.abrir();
  runApp(MyApp(db: db));
}

class MyApp extends StatelessWidget {
  final AppDatabase db;
  const MyApp({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de tareas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TareasPage(db: db),
    );
  }
}