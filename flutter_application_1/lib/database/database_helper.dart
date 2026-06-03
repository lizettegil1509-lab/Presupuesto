import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('gastos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE movimientos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT NOT NULL,
        monto REAL NOT NULL,
        categoria TEXT NOT NULL,
        descripcion TEXT,
        fecha TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertMovimiento(Map<String, dynamic> movimiento) async {
    final db = await instance.database;

    return await db.insert(
      'movimientos',
      movimiento,
    );
  }

  Future<List<Map<String, dynamic>>> getMovimientos() async {
    final db = await instance.database;

    return await db.query(
      'movimientos',
      orderBy: 'id DESC',
    );
  }

  Future<void> mostrarMovimientos() async {
    final db = await instance.database;

    final movimientos = await db.query('movimientos');

    print(movimientos);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<int> deleteMovimiento(int id) async {
  final db = await instance.database;

  return await db.delete(
    'movimientos',
    where: 'id = ?',
    whereArgs: [id],
  );
}

  Future<int> updateMovimiento(Map<String, dynamic> movimiento) async {
  final db = await instance.database;

  return await db.update(
    'movimientos',
    movimiento,
    where: 'id = ?',
    whereArgs: [movimiento['id']],
  );
}
}