import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class AddMovimientoScreen extends StatefulWidget {
  const AddMovimientoScreen({super.key});

  @override
  State<AddMovimientoScreen> createState() => _AddMovimientoScreenState();
}

class _AddMovimientoScreenState extends State<AddMovimientoScreen> {
  final _formKey = GlobalKey<FormState>();

  String tipo = 'Gasto';
  String categoria = 'Alimentación';

  final montoController = TextEditingController();
  final descripcionController = TextEditingController();

  final List<String> categorias = [
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
  void dispose() {
    montoController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Movimiento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: tipo,
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Ingreso',
                    child: Text('Ingreso'),
                  ),
                  DropdownMenuItem(
                    value: 'Gasto',
                    child: Text('Gasto'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    tipo = value!;
                  });
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: montoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monto',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: categoria,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: categorias.map((cat) {
                  return DropdownMenuItem<String>(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    categoria = value!;
                  });
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              

ElevatedButton(
  onPressed: () async {
  try {
    await DatabaseHelper.instance.insertMovimiento({
      'tipo': tipo,
      'monto': double.tryParse(montoController.text) ?? 0,
      'categoria': categoria,
      'descripcion': descripcionController.text,
      'fecha': DateTime.now().toString(),
    });

    final datos =
        await DatabaseHelper.instance.getMovimientos();

    print(datos);

    if (mounted) {
      Navigator.pop(context);
    }
  } catch (e) {
    print("ERROR: $e");
  }
},
  child: const Text('Guardar'),
)




            ],
          ),
        ),
      ),
    );
  }
}