import 'package:emprego_app/modelos/vaga.dart';
import 'package:emprego_app/provider/vagas_provider.dart';
import 'package:emprego_app/rotas/app_rotas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VagaFicha extends StatelessWidget {
  final Vaga vaga;
  const VagaFicha(this.vaga);

  @override
  Widget build(BuildContext context) {
    final icone = CircleAvatar(child: Icon(Icons.person));
    Future<void> load(Vaga vaga) async {
      await Provider.of<Vagas>(context, listen: false);
    }

//    final id = json.decode(response.body)['name'];

    return ListTile(
      leading: icone,
      title: Text(vaga.vaga),
      subtitle: Text(vaga.local),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.orange,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRotas.VAGA_FORM,
                  arguments: vaga,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Excluir'),
                    content: Text('Excluir este anúncio?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Não'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('Sim'),
                        onPressed: () {
                          Provider.of<Vagas>(context, listen: false)
                              .remove(vaga);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
