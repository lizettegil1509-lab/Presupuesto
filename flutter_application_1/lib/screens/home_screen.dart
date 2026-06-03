import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'add_movimiento_screen.dart';
import 'edit_movimiento_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> movimientos = [];
  List<Map<String, dynamic>> movimientosFiltrados = [];

  String filtro = 'Todos';

  double totalIngresos = 0;
  double totalGastos = 0;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final data = await DatabaseHelper.instance.getMovimientos();

    double ingresos = 0;
    double gastos = 0;

    for (var item in data) {
      double monto = item['monto'];

      if (item['tipo'] == 'Ingreso') {
        ingresos += monto;
      } else {
        gastos += monto;
      }
    }

    setState(() {
      movimientos = data;

      if (filtro == 'Todos') {
        movimientosFiltrados = data;
      } else {
        movimientosFiltrados =
            data.where((m) => m['tipo'] == filtro).toList();
      }

      totalIngresos = ingresos;
      totalGastos = gastos;
    });
  }

  void aplicarFiltro(String valor) {
    setState(() {
      filtro = valor;

      if (filtro == 'Todos') {
        movimientosFiltrados = movimientos;
      } else {
        movimientosFiltrados =
            movimientos.where((m) => m['tipo'] == filtro).toList();
      }
    });
  }

  Future<void> eliminarMovimiento(int id) async {
    await DatabaseHelper.instance.deleteMovimiento(id);

    await cargarDatos();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Movimiento eliminado'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double saldo = totalIngresos - totalGastos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Presupuesto'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('Total Ingresos'),
                trailing: Text('B/. ${totalIngresos.toStringAsFixed(2)}'),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text('Total Gastos'),
                trailing: Text('B/. ${totalGastos.toStringAsFixed(2)}'),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text('Saldo Disponible'),
                trailing: Text('B/. ${saldo.toStringAsFixed(2)}'),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Movimientos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => aplicarFiltro('Todos'),
                  child: const Text('Todos'),
                ),
                ElevatedButton(
                  onPressed: () => aplicarFiltro('Ingreso'),
                  child: const Text('Ingresos'),
                ),
                ElevatedButton(
                  onPressed: () => aplicarFiltro('Gasto'),
                  child: const Text('Gastos'),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Expanded(
              child: movimientosFiltrados.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay movimientos registrados',
                      ),
                    )
                  : ListView.builder(
                      itemCount: movimientosFiltrados.length,
                      itemBuilder: (context, index) {
                        final item = movimientosFiltrados[index];

                        return Dismissible(
                          key: Key(item['id'].toString()),
                          direction: DismissDirection.endToStart,

                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),

                          onDismissed: (direction) {
                            eliminarMovimiento(item['id']);
                          },

                          child: Card(
                            child: ListTile(
                              title: Text(item['categoria']),

                              subtitle: Text(
                                item['descripcion'] ?? '',
                              ),

                              trailing: Text(
                                '${item['tipo']}  B/. ${item['monto']}',
                              ),

                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditMovimientoScreen(
                                      movimiento: item,
                                    ),
                                  ),
                                );

                                cargarDatos();
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddMovimientoScreen(),
            ),
          );

          cargarDatos();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}