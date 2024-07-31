import 'dart:convert';

import 'package:aula/autenticador.dart';
import 'package:aula/componentes/buildsDestinycard.dart';
import 'package:aula/estado.dart';
import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class BuildsDestiny extends StatefulWidget {
  const BuildsDestiny({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BuildsDestinyState();
  }
}

const int tamanhoPagina = 4;

class _BuildsDestinyState extends State<BuildsDestiny> {
  late dynamic _feedEstatico;
  List<dynamic> _buildsDestiny = [];

  int _proximaPagina = 1;
  bool _carregando = false;

  late TextEditingController _controladorFiltragem;
  String _filtro = "";

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);

    _controladorFiltragem = TextEditingController();
    _lerFeedEstatico();
  }

  Future<void> _lerFeedEstatico() async {
    final String conteudoJson =
        await rootBundle.loadString("lib/recursos/json/feed.json");
    _feedEstatico = await json.decode(conteudoJson);

    _carregarBuildsDestiny();
  }

  void _carregarBuildsDestiny() {
    setState(() {
      _carregando = true;
    });

    var maisBuildsDestiny = [];
    if (_filtro.isNotEmpty) {
      _feedEstatico["buildsDestiny"].where((item) {
        String nome = item["buildDestiny"]["name"];

        return nome.toLowerCase().contains(_filtro.toLowerCase());
      }).forEach((item) {
        maisBuildsDestiny.add(item);
      });
    } else {
      maisBuildsDestiny = _buildsDestiny;

      final totalBuildsDestinyParaCarregar = _proximaPagina * tamanhoPagina;
      if (_feedEstatico["buildsDestiny"].length >=
          totalBuildsDestinyParaCarregar) {
        maisBuildsDestiny = _feedEstatico["buildsDestiny"]
            .sublist(0, totalBuildsDestinyParaCarregar);
      }
    }

    setState(() {
      _buildsDestiny = maisBuildsDestiny;
      _proximaPagina = _proximaPagina + 1;

      _carregando = false;
    });
  }

  Future<void> _atualizarBuildsDestiny() async {
    _buildsDestiny = [];
    _proximaPagina = 1;

    _carregarBuildsDestiny();
  }

  @override
  Widget build(BuildContext context) {
    bool usuarioLogado = estadoApp.usuario != null;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 60, right: 20),
                    child: TextField(
                      controller: _controladorFiltragem,
                      onSubmitted: (descricao) {
                        _filtro = descricao;

                        _atualizarBuildsDestiny();
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search)),
                    ))),
            usuarioLogado
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        estadoApp.onLogout();
                      });

                      Toast.show("Você não está mais conectado",
                          duration: Toast.lengthLong, gravity: Toast.bottom);
                    },
                    icon: const Icon(Icons.logout))
                : IconButton(
                    onPressed: () {
                      Usuario usuario = Usuario(
                          "Gustavo Lima Cabral", "202021190003@ifba.edu.br");

                      setState(() {
                        estadoApp.onLogin(usuario);
                      });

                      Toast.show("Você foi conectado com sucesso",
                          duration: Toast.lengthLong, gravity: Toast.bottom);
                    },
                    icon: const Icon(Icons.login))
          ],
        ),
        body: FlatList(
            data: _buildsDestiny,
            numColumns: 2,
            loading: _carregando,
            onRefresh: () {
              _filtro = "";
              _controladorFiltragem.clear();

              return _atualizarBuildsDestiny();
            },
            onEndReached: () => _carregarBuildsDestiny(),
            buildItem: (item, int indice) {
              return SizedBox(
                  height: 400, child: BuildsDestinyCard(buildDestiny: item));
            }));
  }
}
