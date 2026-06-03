import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class EditMovimientoScreen extends StatefulWidget {
  final Map<String, dynamic> movimiento;

  const EditMovimientoScreen({super.key, required this.movimiento});

  @override
  State<EditMovimientoScreen> createState() => _EditMovimientoScreenState();
}

class _EditMovimientoScreenState extends State<EditMovimientoScreen> {
  late TextEditingController montoController;
  late TextEditingController descripcionController;

  late String tipo;
  late String categoria;

  final categorias = [
    'Alimentación',
    'Transporte',
    'Salud',
    'Educación',
    'Servicios',
    'Entretenimiento',
    'Compras',
    'Otros'
  ];

  @override
  void initState() {
    super.initState();

    montoController =
        TextEditingController(text: widget.movimiento['monto'].toString());
    descripcionController =
        TextEditingController(text: widget.movimiento['descripcion']);

    tipo = widget.movimiento['tipo'];
    categoria = widget.movimiento['categoria'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Movimiento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: montoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monto'),
            ),

            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),

            DropdownButton<String>(
              value: tipo,
              items: const [
                DropdownMenuItem(value: 'Ingreso', child: Text('Ingreso')),
                DropdownMenuItem(value: 'Gasto', child: Text('Gasto')),
              ],
              onChanged: (value) {
                setState(() {
                  tipo = value!;
                });
              },
            ),

            DropdownButton<String>(
              value: categoria,
              items: categorias
                  .map((c) =>
                      DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  categoria = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.instance.updateMovimiento({
                  'id': widget.movimiento['id'],
                  'tipo': tipo,
                  'monto': double.tryParse(montoController.text) ?? 0,
                  'categoria': categoria,
                  'descripcion': descripcionController.text,
                  'fecha': widget.movimiento['fecha'],
                });

                Navigator.pop(context);
              },
              child: const Text('Actualizar'),
            )
          ],
        ),
      ),
    );
  }
}