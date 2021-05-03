import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_series_app/models/serie.dart';
import '../DataBaseHelper/databasehelper.dart';

class SeriesDetails extends StatefulWidget {
  final Serie serie;
  SeriesDetails(this.serie);

  @override
  _SeriesDetailsState createState() => _SeriesDetailsState();
}

class _SeriesDetailsState extends State<SeriesDetails> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            onPressed: () {
              setState(() {
                databaseHelper.toggleFav(widget.serie);
              });
            },
            child: widget.serie.seriefev == 0
                ? Icon(Icons.favorite_border)
                : Icon(Icons.favorite),
          )
        ],
        title: Text(widget.serie.serieName + ' Details'),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.redAccent),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Image.network(widget.serie.serieImage),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Name: ' + widget.serie.serieName,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'You gonna watch: ' +
                          [widget.serie.serieEps + 1].toString(),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Year: ' + widget.serie.serieYear,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Genre: ' + widget.serie.serieGenre,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Plot: ' + widget.serie.seriePlot,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'IMDB Rate: ' + widget.serie.serieIMDBRate,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                          child: Text('Finished'),
                          onPressed: () {
                            databaseHelper.toggleFinished(widget.serie);
                            print(widget.serie.serieDone);
                            navigator.pop();
                          },
                        ),
                        RaisedButton(
                            child: Text('Back'),
                            onPressed: () {
                              Get.back();
                            }),
                        RaisedButton(
                          child: Text('Delete'),
                          onPressed: () {
                            databaseHelper.deleteNote(widget.serie.id);
                            navigator.pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
