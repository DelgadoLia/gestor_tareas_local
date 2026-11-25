import 'package:flutter/material.dart';
import '../data/database.dart';

class TareasPage extends StatefulWidget {
  final AppDatabase db;
  const TareasPage({super.key, required this.db});

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _mostrarError(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  Future<void> _agregar() async {
    final titulo = controller.text.trim();
    if (titulo.isEmpty) {
      _mostrarError('El título no puede estar vacío');
      return;
    }
    try {
      await widget.db.agregarTarea(titulo);
      controller.clear();
    } catch (e) {
      _mostrarError('No se pudo guardar la tarea: $e');
    }
  }

  Future<void> _alternar(TareaRegistro t, bool v) async {
    try {
      await widget.db.alternarCompletada(t.id, v);
    } catch (e) {
      _mostrarError('No se pudo actualizar el estado: $e');
    }
  }

  Future<void> _eliminar(TareaRegistro t) async {
    try {
      await widget.db.eliminarTarea(t.id);
    } catch (e) {
      _mostrarError('No se pudo eliminar la tarea: $e');
    }
  }

  Future<void> _editarTitulo(TareaRegistro t) async {
    final editController = TextEditingController(text: t.titulo);
    final nuevo = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar título'),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(hintText: 'Nuevo título'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, editController.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    editController.dispose();

    if (nuevo == null) return;
    if (nuevo.isEmpty) {
      _mostrarError('El título no puede estar vacío');
      return;
    }
    try {
      await widget.db.actualizarTitulo(t.id, nuevo);
    } catch (e) {
      _mostrarError('No se pudo actualizar el título: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestor de tareas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Nueva tarea',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: _agregar,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<TareaRegistro>>(
              stream: widget.db.observarTareas(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error al cargar tareas: ${snapshot.error}'),
                  );
                }
                final tareas = snapshot.data ?? [];
                if (tareas.isEmpty) {
                  return const Center(child: Text('No hay tareas todavía'));
                }
                return ListView.builder(
                  itemCount: tareas.length,
                  itemBuilder: (context, index) {
                    final t = tareas[index];
                    return ListTile(
                      leading: Checkbox(
                        value: t.completada,
                        onChanged: (v) => _alternar(t, v ?? false),
                      ),
                      title: Text(
                        t.titulo,
                        style: TextStyle(
                          decoration: t.completada
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Text(
                        t.completada ? 'Completada' : 'Pendiente',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editarTitulo(t),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _eliminar(t),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}