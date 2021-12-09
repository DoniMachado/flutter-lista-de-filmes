import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:lista_de_filmes/filme.dart';
import 'package:lista_de_filmes/pagina_detalhes.dart';

class Principal extends StatefulWidget {
  const Principal({ Key? key }) : super(key: key);

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {


   String URL = "https://desafio-mobile.nyc3.digitaloceanspaces.com/movies";   
   TextStyle textEstilo = TextStyle( color: Colors.indigo.shade900, fontSize: 20, fontWeight: FontWeight.bold  );
   TextStyle titulosEstilo = TextStyle(color: Colors.black, fontSize: 15);

   Future<List<Filme>> _recuperaDados() async
   {

     //Gera a uri de conexão através de uma string de url
     Uri uri = Uri.parse(URL);
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

    List<Filme> lista = [];

    

    if (response.statusCode == 200){ //Resposta esperada

            //Decodificando a String de resposta em um JSON Object
            var dadosJSON = json.decode(response.body);       

            for ( var item in dadosJSON ){
              Filme f = Filme (item["id"],item["vote_average"],item["title"],item["poster_url"],item["genres"], item["release_date"]);
              lista.add(f);
            }

    }else{ //Respostas inesperadas, ocorreu algum erro

      //Gera um erro com o código obtido
       return Future.error("Problemas na obtenção da lista de filmes, erro obtido: "+response.statusCode.toString());
    }
      

   

     return lista;

   }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              leading: const  Icon(Icons.slow_motion_video) ,
              title: const Text("Lista de Filmes"),
              centerTitle: true,
              backgroundColor: Colors.indigo.shade900,
      ),
      body:  FutureBuilder<List<Filme>>(
                  future: _recuperaDados().timeout(const Duration(seconds: 10),onTimeout: (){
                            return Future.error("Erro de conexão, ocorreu um timeout, tente novamente mais tarde");
                            }
                        ),
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
                                                 
                                                if(snapshot.hasError){ //Houve uma resposta, porém com erro
                                                      print("Erro: "+snapshot.error.toString());

                                                      return Center(
                                                          child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(20),
                                                              child: Text("Erro, tente novamente.",style: textEstilo,)
                                                              ),
                                                            Padding(
                                                              padding: const EdgeInsets.all(20),
                                                              child: Text(snapshot.error.toString(), textAlign: TextAlign.justify, overflow: TextOverflow.ellipsis,maxLines: 7, style: textEstilo,), 
                                                              )
                                                          ],
                                                        ),
                                                      );

                                                }else if(snapshot.hasData){ // Houve uma resposta válida
                                                  List<Filme> listaF = snapshot.data!;

                                                  return Container(                                                    
                                                    child: ListView.builder(
                                                        itemCount: listaF.length,
                                                        itemBuilder: (context,indice){

                                                          Filme f = listaF[indice];
                                                          String generos = "";

                                                          for (String gen in f.genres){
                                                            generos += gen + ", ";
                                                          }


                                                          return ListTile(                                                             
                                                                    leading: Image.network(f.poster_url, errorBuilder: (context,exception,stacktrace){
                                                                            return const Icon (Icons.error_outline_rounded);
                                                                    },),
                                                                    title: Text(f.title, style: titulosEstilo,),
                                                                    subtitle: Text("Gêneros: "+generos,style: titulosEstilo,),  
                                                                    minVerticalPadding: 20,                                                            
                                                                    onTap: (){

                                                                      awaitRetornoDaTela(f.id);

                                                                  },
                                                                );

                                                                                                              

                                                          }                                                        
                                                        ),

                                                    );

                                                }
                                                
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

  void awaitRetornoDaTela (int id) async{

    //Função utilizada para navegação entre páginas
    //feita com async para atualização dessa página quando houver um Navigator.pop()

    String? resultado = await Navigator.push(context, MaterialPageRoute(builder: (context)=> PagDetalhes(ID: id.toString(),)   ));

    if (resultado== null) resultado = "Veio nulo";

    setState(() { //Garante que a página é atualizada depois do Navigator.pop()
      print("Reescreveu");
      print(resultado);

    });
  }


}