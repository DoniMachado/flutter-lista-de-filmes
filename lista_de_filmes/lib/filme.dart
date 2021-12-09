
// Classe utilizada como model para as informações gerais obtidas através da api


class Filme {

final int _id;
final double _vote_average;
final String _title;
final String _poster_url;
final String _release_date;
final List <dynamic> _genres;


//Construtor
Filme(this._id,this._vote_average,this._title,this._poster_url,this._genres,this._release_date);


//Getters
int get id => _id;

double get vote_average => _vote_average;

String get title => _title;

String get poster_url => _poster_url;

String get release_date => _release_date;

List <dynamic> get genres => _genres;




}