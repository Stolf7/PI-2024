import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Deep Manga',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: GoogleFonts.montserrat(color: Colors.white, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.white), // Ícones do AppBar em branco
        ),
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.montserrat(color: Colors.black),
          bodyMedium: GoogleFonts.montserrat(color: Colors.black),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo foto moe
          FadeTransition(
            opacity: _opacityAnimation,
            child: Container(
              color: Colors.transparent, // Mantém a cor de fundo transparente
            ),
          ),
          // Conteúdo principal da tela
          Container(
            width: double.infinity,
            color: Colors.black, // Definindo o fundo como preto
            child: Stack(
              children: [
                Center(
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'MDM',
                          style: GoogleFonts.montserrat(
                            fontSize: 52,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 4.0,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Crie e organize sua lista de animes e mangas preferidos com o MyDeepManga',
                          style: GoogleFonts.montserrat(
                            fontSize: 22,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                            shadows: [
                              Shadow(
                                blurRadius: 8.0,
                                color: Colors.black26,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 100, // Altura Matheus
                  left: 20,
                  right: 20,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Image.asset(
                      "assets/images/cat-cat.png", // Caminho da sua imagem
                      fit: BoxFit.contain, // Mantenha a proporção da imagem
                      width: 250, // Defina uma largura específica
                      height: 250, // Defina uma altura específica
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50, // Deixe esse valor para o botão
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BlankPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Fundo do botão
                      foregroundColor: Colors.black, // Cor do texto do botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      elevation: 6.0,
                    ),
                    child: Text(
                      'My Deep',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class BlankPage extends StatefulWidget {
  @override
  _BlankPageState createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  List<dynamic> mangas = [];
  List<dynamic> savedMangas = [];
  int offset = 0;
  final int limit = 15; // Altere para 15
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchMangas();
  }

  Future<void> fetchMangas({int offset = 0}) async {
    final response = await http.get(Uri.parse('https://api.jikan.moe/v4/top/anime?type=ona&offset=$offset&limit=$limit'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        mangas.addAll(data['data']); // Adiciona novos mangas à lista
      });
    } else {
      print('Failed to load mangas: ${response.statusCode}');
    }
  }

  Future<void> loadMore() async {
    // Incrementa o offset
    offset += limit;
    await fetchMangas(offset: offset);
  }

  Future<void> searchMangas(String query) async {
    if (query.isEmpty) {
      mangas.clear(); // Limpa a lista antes de recarregar
      offset = 0; // Reinicia o offset
      fetchMangas();
      return;
    }

    final response = await http.get(Uri.parse('https://api.jikan.moe/v4/anime?q=$query&type=ona'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        mangas = data['data']; // Atualiza a lista com base na pesquisa
        offset = 0; // Reinicia o offset para a nova pesquisa
      });
    } else {
      print('Failed to search mangas: ${response.statusCode}');
    }
  }

  void toggleSaveManga(dynamic manga) {
    setState(() {
      if (savedMangas.contains(manga)) {
        savedMangas.remove(manga);
      } else {
        savedMangas.add(manga);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: searchMangas,
          style: GoogleFonts.montserrat(color: Colors.white), // Texto da pesquisa em branco
          decoration: InputDecoration(
            hintText: 'Pesquisar Mangás',
            hintStyle: GoogleFonts.montserrat(color: Colors.white54), // Dica em branco
            border: InputBorder.none,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'My Deep Manga',
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            ListTile(
              title: Text('Mangas', style: GoogleFonts.montserrat(color: Colors.black)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Minha lista', style: GoogleFonts.montserrat(color: Colors.black)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyListPage(savedMangas: savedMangas)),
                );
              },
            ),
            ListTile(
              title: Text('Sobre', style: GoogleFonts.montserrat(color: Colors.black)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: mangas.length + (offset < mangas.length ? 1 : 0), // Exibe o botão 'Carregar mais' se houver mais mangas
        itemBuilder: (context, index) {
          if (index < mangas.length) {
            final manga = mangas[index];
            bool isSaved = savedMangas.contains(manga);

            return ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(manga['title']),
                  ),
                  IconButton(
                    icon: Icon(
                      isSaved ? Icons.favorite : Icons.favorite_border,
                      color: isSaved ? Colors.red : null,
                    ),
                    onPressed: () => toggleSaveManga(manga),
                  ),
                ],
              ),
              leading: Image.network(
                manga['images']['jpg']['image_url'],
                width: 50,
                height: 75,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MangaDetailPage(manga: manga)),
                );
              },
            );
          }

          // Botão "Carregar mais" se houver mais mangas
          return ElevatedButton(
            onPressed: loadMore,
            child: Text('Carregar mais'),
          );
        },
      ),
    );
  }
}

class MyListPage extends StatelessWidget {
  final List<dynamic> savedMangas;

  MyListPage({required this.savedMangas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Minha Lista', style: GoogleFonts.montserrat())),
      body: ListView.builder(
        itemCount: savedMangas.length,
        itemBuilder: (context, index) {
          final manga = savedMangas[index];
          return ListTile(
            title: Text(manga['title']),
            leading: Image.network(
              manga['images']['jpg']['image_url'],
              width: 50,
              height: 75,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MangaDetailPage(manga: manga)),
              );
            },
          );
        },
      ),
    );
  }
}


class MangaDetailPage extends StatelessWidget {
  final dynamic manga;

  MangaDetailPage({required this.manga});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(manga['title'], style: GoogleFonts.montserrat())),
      body: ListView( // Use ListView ao invés de Column
        children: [
          Image.network(manga['images']['jpg']['image_url']),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              manga['synopsis'] ?? 'No synopsis available',
              style: GoogleFonts.montserrat(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}


class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre'),
        backgroundColor: Colors.black, // Cor da barra para preto
        iconTheme: IconThemeData(color: Colors.white), // Cor do ícone do menu hamburguer para branco
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Desenvolvido por', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),

            // Matheus
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/matheus-profile.jpg'), // Use AssetImage
                ),
                SizedBox(width: 10),
                Text('Matheus Stolf', style: TextStyle(fontSize: 24)),
              ],
            ),
            SizedBox(height: 16),

            // Participante 2
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/juliano-profile.jpg'), // Use AssetImage para o membro 2
                ),
                SizedBox(width: 10),
                Text('Juliano Alessandro', style: TextStyle(fontSize: 24)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


