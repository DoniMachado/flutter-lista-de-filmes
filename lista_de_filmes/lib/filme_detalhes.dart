
//Classe usada como model para as informações especificas e detalhadas dos filmes, obtidas através da api. 

class FilmeDetalhes {

 final bool? _adult;
 final String? _backdrop_url;
 final Map <String,dynamic>? _belongs_to_collection;
 final int? _budget;
 final List <dynamic>? _genres;
 final String? _homepage;
 final int? _id;
 final String? _imdb_id;
 final String? _original_language;
 final String? _original_title;
 final String? _overview;
 final double? _popularity;
 final String? _poster_url;
 final List<dynamic>? _production_companies;
 final List<dynamic>? _production_countries;
 final String? _release_date;
 final int? _revenue;
 final int? _runtime;
 final List<dynamic>? _spoken_languages;
 final String? _status;
 final String? _tagline;
 final String? _title;
 final bool? _video;
 final double? _vote_average;
 final int? _vote_count;


  FilmeDetalhes(this._adult,this._backdrop_url,this._belongs_to_collection,this._budget,this._genres,this._homepage,
  this._id,this._imdb_id,this._original_language,this._original_title,this._overview,this._popularity,this._poster_url,
  this._production_companies,this._production_countries,this._release_date,this._revenue,this._runtime,this._spoken_languages,
  this._status,this._tagline,this._title,this._video,this._vote_average,this._vote_count);



  //Getters
  bool? get adult => _adult;

  String? get backdrop_url => _backdrop_url;

  Map<String,dynamic>? get  belongs_to_collections=> _belongs_to_collection;

  int? get budget => _budget;

  List<dynamic>? get genres => _genres;

  String? get homepage => _homepage;

  int? get id => _id;

  String? get imdb_id => _imdb_id;

  String? get original_language => _original_language;

  String? get original_title => _original_title;

  String? get overview => _overview;

  double? get popularity => _popularity;

  String? get poster_url => _poster_url;

  List<dynamic>? get production_companies => _production_companies;

  List<dynamic>? get production_countries => _production_countries;

  String? get release_date => _release_date;

  int? get revenue => _revenue;

  int? get runtime => _runtime;

  List<dynamic>? get spoken_languages => _spoken_languages;

  String? get status => _status;

  String? get tagline => _tagline;

  String? get title => _title;

  bool? get video => _video;

  double? get vote_average => _vote_average;

  int? get vote_count => _vote_count;



}