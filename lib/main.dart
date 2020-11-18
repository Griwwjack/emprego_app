import 'package:emprego_app/provider/vagas_provider.dart';
import 'package:emprego_app/rotas/app_rotas.dart';
import 'package:emprego_app/views/Home.dart';
//import 'package:emprego_app/views/vagas_lista.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/vaga_form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Vagas(),
        ),
      ],
      child: MaterialApp(
        title: 'Emprego por perto',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
//        home: VagasLista(),
        home: PaginaInicial(),
        routes: {AppRotas.VAGA_FORM: (ctx) => VagaForm()},
      ),
    );
  }
}
