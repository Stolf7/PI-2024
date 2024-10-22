import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Certifique-se de ter este pacote no seu pubspec.yaml

class KodiakHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: Color(0xFF171717), // Mesma cor da página
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft, color: Colors.white), // Ícone de voltar
            onPressed: () {
              // Redireciona para a página de login
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Conteúdo principal da página
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bem-vindo ao Kodiak!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Comece a gerenciar suas tarefas agora mesmo.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          // Faixa inferior com campo de entrada de mensagem
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Color(0xFF171717),
            height: 70, // Altura da faixa inferior
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 4, bottom: 12), // sobe a barra inferior de mensagem
                    decoration: BoxDecoration(
                      color: Color(0xFF454545),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      maxLines: 1, // Permite apenas uma linha
                      decoration: InputDecoration(
                        hintText: 'Mensagem',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 12), // Espaço entre o campo de mensagem e o ícone
                IconButton(
                  icon: Icon(FontAwesomeIcons.paperPlane, color: Colors.white), // Ícone de envio
                  onPressed: () {
                    // Ação ao clicar no ícone de envio
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: KodiakHome(),
  ));
}
