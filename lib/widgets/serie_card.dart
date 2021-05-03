import 'package:flutter/material.dart';
import 'package:my_series_app/DataBaseHelper/databasehelper.dart';
import 'package:my_series_app/Pages/finished_serie_details.dart';
import '../Pages/serie_details_design.dart';
import 'package:my_series_app/models/serie.dart';

Widget serieCard(Serie serie, context) {
  DatabaseHelper databaseHelper = DatabaseHelper();

  return Padding(
    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
    child: InkWell(
      onTap: () {
        if (serie.serieDone == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DetailsPage(
                  serie: serie,
                );
              },
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return FinishedDetailsPage(
                  serie: serie,
                );
              },
            ),
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Row(
              children: [
                Hero(
                    tag: serie.serieImage,
                    child: Image(
                        image: NetworkImage(serie.serieImage),
                        fit: BoxFit.contain,
                        height: 75.0,
                        width: 75.0)),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serie.serieName,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Your are on Eps :' + serie.serieEps.toString(),
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    )
                  ],
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                color: Colors.black,
                onPressed: () {
                  databaseHelper.epsDecress(serie);
                },
              ),
              IconButton(
                icon: Icon(Icons.add),
                color: Colors.black,
                onPressed: () {
                  databaseHelper.epsEncress(serie);
                },
              )
            ],
          ),
        ],
      ),
    ),
  );
}
