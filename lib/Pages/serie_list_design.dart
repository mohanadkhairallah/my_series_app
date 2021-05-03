import 'package:flutter/material.dart';
import 'package:my_series_app/DataBaseHelper/databasehelper.dart';
import 'package:my_series_app/models/serie.dart';
import 'package:my_series_app/widgets/serie_card.dart';
import 'package:sqflite/sqflite.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Serie> serielist = [];
  List<Serie> finishedlist = [];
  bool togglefinished = false;
  bool togglefav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF21BFBD),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                    width: 125.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: togglefav
                              ? Icon(Icons.favorite)
                              : Icon(Icons.favorite_border),
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              print(finishedlist);
                              if (togglefav) {
                                togglefav = false;
                                updateListView();
                              } else {
                                togglefav = true;
                                updatefinishedListView();
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: togglefinished
                              ? Icon(Icons.done)
                              : Icon(Icons.done_outline),
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              print(finishedlist);
                              if (togglefinished) {
                                togglefinished = false;
                                updateListView();
                              } else {
                                togglefinished = true;
                                updatefinishedListView();
                              }
                            });
                          },
                        )
                      ],
                    ))
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
              padding: EdgeInsets.only(left: 40.0, right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: <Widget>[
                      Text('My',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0)),
                      SizedBox(width: 10.0),
                      Text(appTitle(),
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: 25.0))
                    ],
                  ),
                  Container(
                    height: 35.0,
                    width: 35.0,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.transparent,
                            style: BorderStyle.none,
                            width: 1.0),
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.transparent),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildAddpop(context),
                        );
                      },
                      child: Center(
                          child: Text('🔍',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                  fontSize: 20.0))),
                    ),
                  )
                ],
              )),
          SizedBox(height: 20.0),
          Container(
            height: MediaQuery.of(context).size.height - 1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(75.0),
              ),
            ),
            child: ListView(
              primary: false,
              padding: EdgeInsets.only(left: 25.0, right: 20.0),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 45.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 190,
                    child: togglefinished
                        ? getFinishedNoteListView()
                        : getNoteListView(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  ListView getNoteListView() {
    updateListView();
    return ListView.builder(
      itemCount: serielist.length,
      itemBuilder: (BuildContext context, int position) {
        return serieCard(serielist[position], context);
      },
    );
  }

  ListView getFinishedNoteListView() {
    updatefinishedListView();
    return ListView.builder(
      itemCount: finishedlist.length,
      itemBuilder: (BuildContext context, int position) {
        return serieCard(finishedlist[position], context);
      },
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Serie>> serieListFuture = databaseHelper.getSerieList();
      serieListFuture.then((serieList) {
        setState(() {
          List<Serie> addToFinished = [];
          for (Serie serie in serieList) {
            if (serie.serieDone == 0) {
              addToFinished.add(serie);
            }
          }
          serielist = addToFinished;
          if (togglefav) {
            addToFinished = [];
            for (Serie serie in serielist) {
              if (serie.seriefev == 1) {
                addToFinished.add(serie);
              }
            }
            serielist = addToFinished;
          }
        });
      });
    });
  }

  void updatefinishedListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Serie>> serieListFuture = databaseHelper.getSerieList();
      serieListFuture.then((finishedList) {
        setState(() {
          List<Serie> addToFinished = [];
          for (Serie serie in finishedList) {
            if (serie.serieDone == 1) {
              addToFinished.add(serie);
            }
          }
          finishedlist = addToFinished;
          if (togglefav) {
            addToFinished = [];
            for (Serie serie in finishedlist) {
              if (serie.seriefev == 1) {
                addToFinished.add(serie);
              }
            }
            finishedlist = addToFinished;
          }
        });
      });
    });
  }

  String appTitle() {
    if (togglefinished) {
      if (togglefav) {
        return '❤️ ✔️ Series';
      } else {
        return '✔️ Series';
      }
    } else {
      if (togglefav) {
        return '❤️ Series';
      } else {
        return 'Series';
      }
    }
  }

  Widget _buildAddpop(context) {
    String seriename;
    return AlertDialog(
      title: const Text('Add New Serie',
          style: TextStyle(
              fontFamily: 'Montserrat', color: Colors.blue, fontSize: 20.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            enableSuggestions: false,
            autofocus: false,
            decoration: InputDecoration(hintText: 'Enter The SHOW name'),
            onChanged: (String value) {
              seriename = value;
            },
          ),
        ],
      ),
      actions: <Widget>[
        Container(
          height: 35.0,
          width: 35.0,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.transparent,
                  style: BorderStyle.none,
                  width: 1.0),
              borderRadius: BorderRadius.circular(100),
              color: Colors.transparent),
          child: GestureDetector(
            onTap: () {
              databaseHelper.addNewSerie(seriename);
              Navigator.of(context).pop();
            },
            child: Center(
              child: Text(
                '▶️',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
