import 'package:emprego_app/componentes/vaga_ficha.dart';
import 'package:emprego_app/provider/vagas_provider.dart';
import 'package:emprego_app/rotas/app_rotas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaginaInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Vagas vagas = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Vagas'),
        actions: <Widget>[
//*******************************************************************
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              await Provider.of<Vagas>(context, listen: false)
                  .load(vagas.byIndex(0));
              print(vagas.byIndex(0));
            },
          ),
//*******************************************************************
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRotas.VAGA_FORM);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: vagas.count,
        itemBuilder: (ctx, i) => VagaFicha(vagas.byIndex(i)),
      ),
    );
  }
}
