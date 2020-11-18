import 'dart:convert';
//import 'dart:math';
import 'package:emprego_app/data/vaga_modelo.dart';
import 'package:emprego_app/modelos/vaga.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Vagas with ChangeNotifier {
  static const _dataBaseUrl = 'https://emprego-app.firebaseio.com/';
  final Map<String, Vaga> _items = {...VAGA_MODELO};

  List<Vaga> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  Vaga byIndex(int i) {
    return _items.values.elementAt(i);
  }

// ****************************************************************************
// Método para inserir ou alterar vagas de emprego.

//  void put(Vaga vaga) {
  Future<void> put(Vaga vaga) async {
    // Alterado para dar suporte ao Database.
    if (vaga == null) {
      return;
    }

    if (vaga.id != null &&
        vaga.id.trim().isNotEmpty &&
        _items.containsKey(vaga.id)) {
      // Altera uma vaga existente.

//  Exclui, com base no id, vaga anterior antes de salvar alteração para evitar
//  duplicata em listas diferentes.
      await http.delete('$_dataBaseUrl/norte/${vaga.id}.json');
      await http.delete('$_dataBaseUrl/sul/${vaga.id}.json');
      await http.delete('$_dataBaseUrl/leste/${vaga.id}.json');
      await http.delete('$_dataBaseUrl/oeste/${vaga.id}.json');
      await http.delete('$_dataBaseUrl/centro/${vaga.id}.json');

      await http.patch(
//        '$_dataBaseUrl/vagas/${vaga.id}.json',
        '$_dataBaseUrl/${vaga.local}/${vaga.id}.json',
        body: json.encode({
          'empresa': vaga.empresa,
          'local': vaga.local,
          'vaga': vaga.vaga,
          'email': vaga.email,
        }),
      );

      _items.update(
        vaga.id,
        (_) => Vaga(
          id: vaga.id,
          empresa: vaga.empresa,
          local: vaga.local,
          vaga: vaga.vaga,
          email: vaga.email,
          //icone: vaga.icone,
        ),
      );
    } else {
      // Adicionar nova vaga.
//      final response = await http.post('$_dataBaseUrl/vagas.json',
      final response = await http.post(
        '$_dataBaseUrl/${vaga.local}.json',
        body: json.encode({
          'empresa': vaga.empresa,
          'local': vaga.local,
          'vaga': vaga.vaga,
          'email': vaga.email,
        }),
      );

      final id =
          json.decode(response.body)['name']; // Pega o id gerado pelo servidor.
      print(json.decode(response.body));

//      Removido pois o "id" agora é gerado pelo servidor database.
//      final id = Random().nextDouble().toString();
      _items.putIfAbsent(
        id,
        () => Vaga(
          id: id,
          empresa: vaga.empresa,
          local: vaga.local,
          vaga: vaga.vaga,
          email: vaga.email,
          //icone: vaga.icone,
        ),
      );
    }
    notifyListeners();
  }

// ****************************************************************************
// Método para excluir uma vagas de emprego existente.

  void remove(Vaga vaga) async {
//      await http.delete('$_dataBaseUrl/vagas/${vaga.id}.json');
    if (vaga != null && vaga.id != null) {
      await http.delete('$_dataBaseUrl/${vaga.local}/${vaga.id}.json');
      _items.remove(vaga.id);
      notifyListeners();
    }
  }

// ****************************************************************************
// Método para pegar a lista de vagas no servidor.

  Future<void> load(Vaga vaga) async {
    await http.read('$_dataBaseUrl/vagas/${vaga.id}.json');
    final response = await http.get('$_dataBaseUrl/vagas.json');
    final id = json.decode(response.body)['name'];
    print(json.decode(response.body));
    print(id);
    notifyListeners();
  }
}
