import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'kodiak_home.dart'; // Importa a tela KodiakHome

class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  void dispose() {
    _cnpjController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 80),
            Text(
              'SOPHOS KODIAK',
              style: GoogleFonts.anton(
                color: Colors.white,
                fontSize: 36,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/cat-cat.png',
                height: 280,
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    'Logo aqui',
                    style: TextStyle(color: Colors.grey),
                  );
                },
              ),
            ),
            SizedBox(height: 20),

            // Container com bordas arredondadas e cor de fundo
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF171717), // Cor de fundo
                borderRadius: BorderRadius.circular(20.0), // Bordas arredondadas
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Bem-vindo de volta!',
                    style: TextStyle(
                      fontSize: 32, // Aumenta o tamanho do texto
                      color: Color(0xFFF6790F),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Acesse sua conta',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  TextFormField(
                    controller: _cnpjController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF45545),
                      hintText: 'Digite o seu CNPJ',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o CNPJ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF45545),
                      hintText: 'Digite a sua senha',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a senha';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 40),

                  // Botão Entrar
                  Container(
                    width: double.infinity, // Define a largura como a mesma do campo
                    child: ElevatedButton(
                      onPressed: () {
                        // Redireciona para a tela KodiakHome independentemente da validação
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => KodiakHome()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF6790F),
                        padding: EdgeInsets.symmetric(vertical: 16), // Mantém o padding vertical
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'ENTRAR',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Recuperação de senha acionada')),
                        );
                      },
                      child: Text(
                        'Esqueci a minha senha',
                        style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
