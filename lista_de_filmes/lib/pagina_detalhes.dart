import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:lista_de_filmes/filme_detalhes.dart';

class PagDetalhes extends StatefulWidget {
  final String ID;
  const PagDetalhes({ Key? key, required this.ID}) : super(key: key);

  @override
  _PagDetalhesState createState() => _PagDetalhesState();
}

class _PagDetalhesState extends State<PagDetalhes> {

  late Future<FilmeDetalhes> filmeDetalhado;
  TextStyle textEstilo = TextStyle(color: Colors.black, fontSize: 15);
  TextStyle titulosEstilo = TextStyle( color: Colors.indigo.shade900, fontSize: 30,fontStyle: FontStyle.italic , fontWeight: FontWeight.bold, decoration: TextDecoration.underline, decorationStyle: TextDecorationStyle.double );

  Future<FilmeDetalhes> _recuperaDetalhes () async{
    
      String url = "https://desafio-mobile.nyc3.digitaloceanspaces.com/movies/" +widget.ID;

      //Gera a uri de conexão através de uma string de url
      Uri uri = Uri.parse(url);
      print(uri.toString());

      //Fazendo a requisição HTTP GET e esperando uma resposta
    late http.Response response;
    try{
    response  = await http.get(uri);
    } on SocketException{ // Em caso de erro de conexão devido a internet
       return Future.error("Erro de conexão com servidor, verifique a conexão de internet");
    }

     print("Codigo de Retorno: "+response.statusCode.toString());
     print("Corpo da Mensagem:\n"+response.body);



      

      FilmeDetalhes fDetalhado;

     if(response.statusCode == 200){ //Resposta esperada

       //Decodificando a String de resposta em um JSON Object
       var dadosJSON = json.decode(response.body);

       fDetalhado = FilmeDetalhes(dadosJSON["adult"], dadosJSON["backdrop_url"], dadosJSON["belongs_to_collection"], dadosJSON["budget"], dadosJSON["genres"], 
       dadosJSON["homepage"], dadosJSON["id"], dadosJSON["imdb_id"], dadosJSON["original_language"], dadosJSON["original_title"], dadosJSON["overview"], dadosJSON["popularity"], 
       dadosJSON["poster_url"], dadosJSON["production_companies"], dadosJSON["production_countries"], dadosJSON["release_date"], dadosJSON["revenue"], dadosJSON["runtime"], 
       dadosJSON["spoken_languages"], dadosJSON["status"], dadosJSON["tagline"], dadosJSON["title"], dadosJSON["video"], dadosJSON["vote_average"], dadosJSON["vote_count"]);

     }else{ //Resposta inesperada, ocorreu algum erro

      //Gera um erro com o código obtido
       return Future.error("Problemas na obtenção dos detalhes do filme\nErro obtido: "+response.statusCode.toString());
     }

    

    return fDetalhado;
    
  }


  String _retornaGeneros (List<dynamic> l){

    String temp = "Gêneros: ";

    for (String G in l){
      temp += G + " ";
    }

    return temp;
  }

  

   @override
  void initState() {
    super.initState();

    filmeDetalhado = _recuperaDetalhes().timeout(const Duration(seconds: 10),onTimeout: (){
             return Future.error("Erro de conexão, ocorreu um timeout, tente novamente mais tarde");});
             
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              leading: const  Icon(Icons.slow_motion_video) ,
              title: const Text("Página de Detalhes"),
              centerTitle: true,
              backgroundColor: Colors.indigo.shade900,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.home),
        onPressed: (){
          Navigator.pop(context,"Retornei com sucesso");
        },
      ),
      body: FutureBuilder<FilmeDetalhes>(
        future: filmeDetalhado ,
        builder: (context,snapshot){
              print("Inside builder");

              switch(snapshot.connectionState){
                      case ConnectionState.none:
                                                print("None");
                                                break;
                      case ConnectionState.active: 
                                                print("Active");
                                                break;
                      case ConnectionState.waiting: //Processando a requisição HTTP
                                                print("Waiting");
                                                return const Center(
                                                    child: CircularProgressIndicator(),
                                                );
                                                
                      case ConnectionState.done:
                                                print("Done");
                                                 
                                                if(snapshot.hasError){ // Houve uma resposta, porém com erro
                                                      print("Erro: "+snapshot.error.toString());

                                                      return Center(
                                                          child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(20),
                                                              child: Text("Erro, tente novamente.",style: textEstilo,)),
                                                            Padding(
                                                              padding: const EdgeInsets.all(20),
                                                              child: Text(snapshot.error.toString(), textAlign: TextAlign.justify, overflow: TextOverflow.ellipsis,maxLines: 7, style: textEstilo,), )
                                                            
                                                            
                                                          ],
                                                        ),
                                                      );

                                                }else if(snapshot.hasData){ //Houve uma resposta válida
                                                  FilmeDetalhes f = snapshot.data!;

                                                  return Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,                                                    
                                                      children: [                                                       
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [ 
                                                            Expanded(
                                                              child: Text(f.title!, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,maxLines: 3, style: titulosEstilo,),
                                                            ),                                               
                                                           
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [ 
                                                            Icon(Icons.star_border,color: Colors.amber[400], size: 50,),                                                            
                                                            Text(f.vote_average.toString(), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,maxLines: 1, style: const TextStyle(color: Colors.black,fontSize: 30),),
                                                                                                          
                                                           
                                                          ],
                                                        ),
                                                         Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [ 
                                                            Expanded(
                                                              child: Text(_retornaGeneros(f.genres!), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,maxLines: 1, style: textEstilo,),
                                                            ),                                               
                                                           
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [ 
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 20, right: 20),
                                                              child: Image.network(f.poster_url!,filterQuality: FilterQuality.high,scale: 2.5, errorBuilder: (context,exception,stacktrace){
                                                                            Widget temp;
                                                                            temp = f.belongs_to_collections != null?                                                                            
                                                                             Image.network(f.belongs_to_collections!["poster_url"].toString(),filterQuality: FilterQuality.high,scale: 2.5, errorBuilder: (context,exception,stacktrace){
                                                                                      return const Icon (Icons.error_outline_rounded);
                                                                                      },):
                                                                             const Icon (Icons.error_outline_rounded, size: 50,);
                                                                             return temp;
                                                                    },),
                                                            ),
                                                            Expanded(child: Padding(
                                                              padding: const EdgeInsets.only(right: 20),
                                                              child: GestureDetector(
                                                                      child: Text(f.overview!, textAlign: TextAlign.justify, overflow: TextOverflow.ellipsis,maxLines: 7,style: textEstilo,),
                                                                      onTap: (){

                                                                        showDialog(
                                                                                  context: context, 
                                                                                  builder: (context){

                                                                                    return AlertDialog(
                                                                                              title:  Text("Sinopse do filme "+f.title!,style: const TextStyle(color: Colors.white),),
                                                                                              content:  Text(f.overview!,style: const TextStyle(color: Colors.white),),
                                                                                              actions: [
                                                                                                TextButton(
                                                                                                              child: const Text('OK', textAlign: TextAlign.justify, overflow: TextOverflow.ellipsis,maxLines: 12 ,style: TextStyle(color: Colors.white),),
                                                                                                              onPressed: () {
                                                                                                                Navigator.of(context).pop();
                                                                                                              },
                                                                                                            ),
                                                                                              ],
                                                                                              elevation: 12.0,
                                                                                              backgroundColor: Colors.indigo[900],
                                                                                              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0)),

                                                                                            );

                                                                                      }
                                                                                  );

                                                                      },

                                                                  ),
                                                                )
                                                              ),
                                                          ],
                                                        ),

                                                      ],
                                                  );

                                                }
                                                break;
                    }


                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Text("Sem dados", style: textEstilo,),
                        ],
                      ),
                    );
            },
        ),
    );
  }
}