import 'dart:async';
import "dart:convert";
import "package:stuffinfrontofme/MapObject.dart";
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  var x = await getDatabasesPath();
 return openDatabase(
    // Set the path to the database.
    join(x, 'database.db'),
// When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      debugPrint("on create db");
// Run the CREATE TABLE statement on the database.
      return db.execute(
        "CREATE TABLE favorites(id UNSIGNED BIG INT PRIMARY KEY, lat DOUBLE, lon DOUBLE, data TEXT)",
      );
    },
// Set the version. This executes the onCreate function and provides a
// path to perform database upgrades and downgrades.
    version: 1,
  );
}
Future<void> deleteAll() async{
  // Get a reference to the database.
  final db = await getDatabase();

  // Remove the Dog from the Database.
  await db.delete(
    'favorites',

  );
}
Future<void> deleteOne(id) async{
  // Get a reference to the database.
  final db = await getDatabase();

  // Remove the Dog from the Database.
  await db.delete(
    'favorites',
    where: "id=?",
    whereArgs: [id]

  );
}
Future<List<MapObject>> getFavorites() async {
  // Get a reference to the database.
  final Database db = await getDatabase();

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('favorites');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return MapObject(
      jsonDecode(maps[i]["data"])
    );
  });
}

Future<void> insertObject(MapObject mapObject) async{
  final Database db = await getDatabase();
  await db.insert("favorites", mapObject.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
}



