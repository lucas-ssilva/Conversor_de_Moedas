import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=ccd16ef5";

void main () async {
  
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
    ),
  ));
}

Future<Map> GetData() async {
http.Response response = await http.get(request);
return json.decode(response.body); // pega o dado futuro que vem da API e converte e devolve como json 
}


class Home extends StatefulWidget {
  @override 
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home>{

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

double dolar;
double euro;

void _realChange(String text){
  if(text.isEmpty) {
      _limparCampos();
      return;
    }
  double real = double.parse(text);
    if(text.isEmpty) {
      _limparCampos();
      return;
    }
  dolarController.text = (real/dolar).toStringAsFixed(2);
  euroController.text = (real/euro).toStringAsFixed(2);
}

void _dolarChange(String text){
    if(text.isEmpty) {
      _limparCampos();
      return;
    }
double dolar = double.parse(text);
realController.text = (dolar * this.dolar).toStringAsFixed(2);
euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
}

void _euroChange(String text){
double euro = double.parse(text);
realController.text = (euro * this.euro).toStringAsFixed(2);
dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);

}

void _limparCampos(){
  realController.clear();
  dolarController.clear();
  euroController.clear();
}

  @override 
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("\$ Conversor \$", style: TextStyle(color: Colors.black)),
    backgroundColor: Colors.amber,centerTitle: true,
    actions: <Widget>[
      IconButton(icon: Icon(Icons.refresh,color: Colors.black,), onPressed: () {_limparCampos();},)
    ],),

    backgroundColor: Colors.black,
    body: 
    FutureBuilder<Map>(future: GetData(),  builder: (context, snapshot) {
      switch(snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.waiting:
        return Center(child: Text("Carregando Dados...", style: TextStyle(color: Colors.amber, fontSize: 25),textAlign: TextAlign.center,)
        ,);
        default: if(snapshot.hasError){
          return Center(child: Text("Erro ao Carregar Dados :*(", style: TextStyle(color: Colors.amber, fontSize: 25),textAlign: TextAlign.center,)
        ,);
        }
        else{
          dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
          euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];


          return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),


        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(Icons.monetization_on,size: 120, color: Colors.amber,),
          Divider(),
          buildTextField("Reais", "R\$", realController, _realChange),

            Divider(),
            buildTextField("Dólares", "US\$", dolarController, _dolarChange),
            
            Divider(),
            buildTextField("Euros", "€ ", euroController, _euroChange),
          ],
        )


      );
        }
        }
    }
    )
    );
  }}

  Widget buildTextField(String label, String prefix, TextEditingController c, Function f ) {
   return TextField( controller: c,keyboardType: TextInputType.number, 

            decoration: InputDecoration(labelText: label,labelStyle: TextStyle(color: Colors.amber),
            border: OutlineInputBorder(),
            prefixText: prefix, prefixStyle: TextStyle(color: Colors.amber),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),  ),
            style: TextStyle(color: Colors.amber, fontSize: 25
            ),
            onChanged: f,
            );
  }