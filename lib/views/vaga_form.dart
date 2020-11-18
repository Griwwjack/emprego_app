import 'package:emprego_app/modelos/vaga.dart';
import 'package:emprego_app/provider/vagas_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VagaForm extends StatefulWidget {
  @override
  _VagaFormState createState() => _VagaFormState();
}

class _VagaFormState extends State<VagaForm> {
  final _form = GlobalKey<FormState>();

  bool _isLoading = false;

  final Map<String, String> _formData = {};

  void _loadFormData(Vaga vaga) {
    if (vaga != null) {
      _formData['id'] = vaga.id;
      _formData['empresa'] = vaga.empresa;
      _formData['local'] = vaga.local;
      _formData['vaga'] = vaga.vaga;
      _formData['email'] = vaga.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Vaga vaga = ModalRoute.of(context).settings.arguments;

    _loadFormData(vaga);

    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Vaga'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
//              onPressed: () {
            onPressed: () async {
              // Alterado para o database.
              final isValid = _form.currentState.validate();

              if (isValid) {
                _form.currentState.save();

                setState(() {
                  _isLoading = true;
                });

                await Provider.of<Vagas>(context, listen: false).put(Vaga(
                  id: _formData['id'],
                  empresa: _formData['empresa'],
                  local: _formData['local'],
                  vaga: _formData['vaga'],
                  email: _formData['email'],
                ));

                setState(() {
                  _isLoading = false;
                });

                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
//        body: Padding(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _formData['empresa'],
                      decoration: InputDecoration(labelText: 'Empresa'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Texto inválido.';
                        }
                        return null;
                      },
                      onSaved: (value) => _formData['empresa'] = value,
                    ),
                    TextFormField(
                      initialValue: _formData['local'],
                      decoration: InputDecoration(labelText: 'Região'),
                      onSaved: (value) => _formData['local'] = value,
                    ),
                    TextFormField(
                      initialValue: _formData['vaga'],
                      decoration: InputDecoration(labelText: 'Vaga'),
                      onSaved: (value) => _formData['vaga'] = value,
                    ),
                    TextFormField(
                      initialValue: _formData['email'],
                      decoration: InputDecoration(labelText: 'Email'),
                      onSaved: (value) => _formData['email'] = value,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
