import 'package:flutter/material.dart';
import 'tela_principal.dart'; // Importa a tela principal

void main() {
  runApp(SophosKodiakApp());
}

class SophosKodiakApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sophos Kodiak',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Anton',
      ),
      home: TelaPrincipal(), // Corrigido para TelaPrincipal
    );
  }
}
