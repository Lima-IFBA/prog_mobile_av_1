// ignore_for_file: unnecessary_getters_setters

import 'package:aula/autenticador.dart';
import 'package:flutter/material.dart';

enum Situacao { mostrandoBuildsDestiny, mostrandoDetalhes }

class EstadoApp extends ChangeNotifier {
  Situacao _situacao = Situacao.mostrandoBuildsDestiny;
  Situacao get situacao => _situacao;

  late int _idBuildDestiny;
  int get idBuildDestiny => _idBuildDestiny;

  Usuario? _usuario;
  Usuario? get usuario => _usuario;
  set usuario(Usuario? usuario) {
    _usuario = usuario;
  }

  void mostrarBuildsDestiny() {
    _situacao = Situacao.mostrandoBuildsDestiny;

    notifyListeners();
  }

  void mostrarDetalhes(int idBuildDestiny) {
    _situacao = Situacao.mostrandoDetalhes;
    _idBuildDestiny = idBuildDestiny;

    notifyListeners();
  }

  void onLogin(Usuario usuario) {
    _usuario = usuario;

    notifyListeners();
  }

  void onLogout() {
    _usuario = null;

    notifyListeners();
  }
}

late EstadoApp estadoApp;
