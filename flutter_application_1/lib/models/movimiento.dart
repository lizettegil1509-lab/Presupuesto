class Movimiento {
  int? id;
  String tipo;
  double monto;
  String categoria;
  String descripcion;
  String fecha;

  Movimiento({
    this.id,
    required this.tipo,
    required this.monto,
    required this.categoria,
    required this.descripcion,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo,
      'monto': monto,
      'categoria': categoria,
      'descripcion': descripcion,
      'fecha': fecha,
    };
  }
}