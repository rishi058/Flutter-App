import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sqflite/sqflite.dart' as sql;

var Color = [
  ColorToHex(Colors.lightBlue).toString(),
  ColorToHex(Colors.red.shade300).toString(),
  ColorToHex(Colors.purple.shade200).toString(),
  ColorToHex(Colors.greenAccent).toString(),
  ColorToHex(Colors.lightBlueAccent).toString(),
  ColorToHex(Colors.pinkAccent).toString(),
  ColorToHex(Colors.orange.shade300).toString(),
  ColorToHex(Colors.limeAccent.shade200).toString(),
  ColorToHex(Colors.purpleAccent).toString(),
  ColorToHex(Colors.tealAccent).toString(),
];

Random random = new Random();

int changeIndex() {
  var index = random.nextInt(10);
  return index;
}

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        color TEXT,
        date TEXT
      )
      """);
  }

  // OPENING DATABASE using inbuilt function sql.openDatabase

  static Future<sql.Database> db() async {
    return sql.openDatabase('myNotes3.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  // CREATE A NEW NOTE -->
  static Future<int> createItem(String TITLE, String? DESCRIPTION) async {
    final db = await SQLHelper.db();

    final data = {
      'title': TITLE,
      'description': DESCRIPTION,
      'color': Color[changeIndex()],
      'date ': DateFormat.yMEd().add_jms().format(DateTime.now()),
    };

    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  //READ ALL NOTE -->
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();

    return db.query('items', orderBy: "id");
  }

  // Update an item by id -->

  static Future<int> updateItem(
      int id, String title, String? descrption) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'date ': DateFormat.yMEd().add_jms().format(DateTime.now()),
      // 'color' : Color[changeIndex()].toString(),
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);

    return result;
  }

  // Delete -->

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
