//importamos las librerias necesarias
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//creamos la clase Conexion
class Conexion {
  //creamos el metodo que nos permitira abrir la base de datos
  Future<Database> abrir() async {
    //obtenemos la ruta de la base de datos
    String ruta = join(await getDatabasesPath(), 'bd_tareas.db');
    //abrimos la base de datos
    return openDatabase(ruta, version: 1, onCreate: _crearTabla);
  }

  //creamos el metodo que nos permitira crear la tabla login y products
  Future<void> _crearTabla(Database db, int version) async {
    //creamos la tabla login
    await db.execute(
        'CREATE TABLE login (id INTEGER PRIMARY KEY, name TEXT, last_name TEXT, email TEXT, password TEXT)');
    //creamos la tabla products
    await db.execute(
        'CREATE TABLE customer (id INTEGER PRIMARY KEY, name TEXT, last_name TEXT,  address TEXT, phone TEXT, email TEXT)');
  }

  //creamos el metodo que nos permitira cerrar la base de datos
  Future<void> cerrar() async {
    final Database db = await abrir();
    db.close();
  }

//----------------------------------------------------------------------------------------------------------
//metodo para nuevo registro check_in de la tabla login
  Future<void> nuevoRegistro(String name, String last_name, String email,
      String password) async {
    final Database db = await abrir();
    await db.insert(
      'login',
      {
        'name': name,
        'last_name': last_name,
        'email': email,
        'password': password
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //metodo de validacion de usuario de la tabla login
  Future<List<Map<String, dynamic>>> validarUsuario(String email, String password) async {
    final Database db = await abrir();
    return db.query('login', where: 'email = ? and password = ?', whereArgs: [email, password]);
  }

//----------------------------------------------------------------------------------------------------------
//metodo para nuevo registro de la tabla customer
  Future<void> addCustomer(String name, String last_name, String address, String phone, String email) async {
    final Database db = await abrir();
    await db.insert(
      'customer',
      {
        'name': name,
        'last_name': last_name,
        'address': address,
        'phone': phone,
        'email': email
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //metodo para obtener los registros de la tabla customer
  Future<List<Map<String, dynamic>>> obtenerCustomer() async {
    final Database db = await abrir();
    return db.query('customer');
  }

  //metodo para editar un registro de la tabla customer
  Future<void> editCustomer(int id, String name, String last_name, String address, String phone, String email) async {
    final Database db = await abrir();
    await db.update(
      'customer',
      {
        'name': name,
        'last_name': last_name,
        'address': address,
        'phone': phone,
        'email': email
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //metodo para eliminar un registro de la tabla customer
  Future<void> deleteCustomer(int id) async {
    final Database db = await abrir();
    await db.delete(
      'customer',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

} //fin de la clase Conexion
//fin del archivo Conexion.dart

