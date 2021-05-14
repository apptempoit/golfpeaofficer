import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper2 {
  final String nameDatabase = 'type2.db';
  final String nameTable = 'tableType2';
  final int version = 1;

  final String columnId = 'id';
  final String columnIdDoc = 'iddoc';
  final String columnNameJob = 'namejob';
  final String columnImage = 'image';

  SQLiteHelper2() {
    initialDatabase();
  }

  Future<Null> initialDatabase() async {
    await openDatabase(
      join(await getDatabasesPath(), nameDatabase),
      version: version,
      onCreate: (db, version) => db.execute(
          'CREATE TABLE $nameTable ($columnId INTEGER PRIMARY KEY, $columnIdDoc TEXT, $columnNameJob TEXT, $columnImage TEXT)'),
    );
  }

  Future<Database> connectedDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), nameDatabase));

  }



Future<Null> insertDatabase()async{

  
}



}
