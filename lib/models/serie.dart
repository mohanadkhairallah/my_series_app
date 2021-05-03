class Serie {
  int id;
  String serieName;
  String serieImage;
  int serieEps;
  String serieYear;
  String serieGenre;
  String seriePlot;
  String serieIMDBRate;
  int seriefev;
  int serieDone;

  Serie(
      {this.id,
      this.serieName,
      this.serieImage,
      this.serieEps,
      this.serieGenre,
      this.serieIMDBRate,
      this.seriePlot,
      this.serieYear,
      this.seriefev,
      this.serieDone});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = serieName;
    map['image'] = serieImage;
    map['eps'] = serieEps;
    map['genre'] = serieGenre;
    map['rate'] = serieIMDBRate;
    map['plot'] = seriePlot;
    map['year'] = serieYear;
    map['fev'] = seriefev;
    map['done'] = serieDone;

    return map;
  }

  Serie.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.serieName = map['name'];
    this.serieImage = map['image'];
    this.serieEps = map['eps'];
    this.serieGenre = map['genre'];
    this.serieIMDBRate = map['rate'];
    this.seriePlot = map['plot'];
    this.serieYear = map['year'];
    this.seriefev = map['fev'];
    this.serieDone = map['done'];
  }
}
