import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import '../models/serie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String seriestable = 'serie_table';
  String colId = 'id';
  String colName = 'name';
  String colImage = 'image';
  String colEps = 'eps';
  String colYear = 'year';
  String colGenre = 'genre';
  String colPlot = 'plot';
  String colIMDBRate = 'rate';
  String colfev = 'fev';
  String coldone = 'done';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'series3.db';

    var seriesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return seriesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $seriestable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, '
        '$colImage TEXT, $colEps INTEGER, $colYear INTEGER, $colGenre TEXT, $colPlot TEXT, $colIMDBRate TEXT, '
        '$colfev INTEGER, $coldone INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getSerieMapList() async {
    Database db = await this.database;

    var result = await db.query(seriestable, orderBy: '$colId ASC');
    return result;
  }

  Future<int> insertNote(Serie serie) async {
    Database db = await this.database;
    var result = await db.insert(seriestable, serie.toMap());
    return result;
  }

  Future<int> updateNote(Serie serie) async {
    var db = await this.database;
    var result = await db.update(seriestable, serie.toMap(),
        where: '$colId = ?', whereArgs: [serie.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result =
        await db.rawUpdate('DELETE FROM $seriestable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $seriestable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Serie>> getSerieList() async {
    var serieMapList = await getSerieMapList();
    int count = serieMapList.length;

    List<Serie> serieList = List<Serie>();
    for (int i = 0; i < count; i++) {
      serieList.add(Serie.fromMapObject(serieMapList[i]));
    }

    return serieList;
  }

  void addNewSerie(String serieName) {
    String myAPI = _fixAPILink(serieName);
    http.get(myAPI).then((http.Response response) async {
      final Map<String, dynamic> serieData = json.decode(response.body);
      if (serieData['Response'] == 'True' && serieData['Type'] == 'series') {
        final Serie newSerieData = Serie(
          serieName: serieData['Title'],
          serieImage: serieData['Poster'],
          serieEps: 1,
          serieGenre: serieData['Genre'],
          serieIMDBRate: serieData['imdbRating'],
          seriePlot: serieData['Plot'],
          serieYear: serieData['Year'],
          seriefev: 0,
          serieDone: 0,
        );
        if (await _checkIfAlreadyHave(serieName)) {
          await insertNote(newSerieData);
        } else {
          Get.snackbar('Alert !', 'You have this serie 🙄');
          print('You have this serie');
        }
      } else if (serieData['Response'] == 'True' &&
          serieData['Type'] == 'movies') {
        Get.snackbar('Alert !', 'This is a movie 📽');
      } else {
        Get.snackbar('Alert !', 'You got wrong name 😢');
      }
    });
  }

  String _fixAPILink(String name) {
    // ' ' >>>>>> '+'
    String serieName = name.replaceAll(new RegExp(r"\s+\b|\b\s"), "+");
    String myAPI = 'https://www.omdbapi.com/?apikey=7803d84a&t=';
    String myNamedAPI = myAPI + serieName;
    print(myNamedAPI);
    return myNamedAPI;
  }

  void updateListView() {
    final Future<Database> dbFuture = initializeDatabase();
    dbFuture.then((database) {});
  }

  void epsEncress(Serie serie) {
    serie.serieEps += 1;
    updateNote(serie);
    updateListView();
  }

  void epsDecress(Serie serie) {
    if (serie.serieEps > 1) {
      serie.serieEps -= 1;
      updateNote(serie);
      updateListView();
    }
  }

  Future<bool> _checkIfAlreadyHave(String name) async {
    List<Serie> serielist = await getSerieList();
    for (Serie serie in serielist) {
      if (serie.serieName.toUpperCase() == name.toUpperCase()) {
        return false;
      }
    }
    return true;
  }

  void toggleFinished(Serie serie) {
    //0 not Done , 1 Done
    if (serie.serieDone == 1) {
      serie.serieDone = 0;
      updateNote(serie);
    } else {
      serie.serieDone = 1;
      updateNote(serie);
    }
  }

  void toggleFav(Serie serie) {
    //0 not fav , 1 fav
    if (serie.seriefev == 1) {
      serie.seriefev = 0;
      updateNote(serie);
    } else {
      serie.seriefev = 1;
      updateNote(serie);
    }
  }

  void resetEps(Serie serie) {
    serie.serieEps = 0;
    updateNote(serie);
  }
}
