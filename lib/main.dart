import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'MDM',
                    style: GoogleFonts.montserrat(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Todos os seus mangas aqui',
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BlankPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  ),
                  child: Text(
                    'Vamos começar',
                    style: GoogleFonts.montserrat(),
                  ),
                ),
              ),
            ),
          ],
        ),
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
          style: GoogleFonts.montserrat(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Pesquisar Mangás',
            hintStyle: GoogleFonts.montserrat(color: Colors.white54),
            border: InputBorder.none,
          ),
        ),
        backgroundColor: Colors.blue,
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
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Mangas', style: GoogleFonts.montserrat()),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Minha lista', style: GoogleFonts.montserrat()),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyListPage(savedMangas: savedMangas)),
                );
              },
            ),
            ListTile(
              title: Text('Sobre', style: GoogleFonts.montserrat()),
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
                  MaterialPageRoute(
                    builder: (context) => MangaDetailPage(manga: manga),
                  ),
                );
              },
            );
          } else if (index == mangas.length) {
            return TextButton(
              onPressed: loadMore,
              child: Text('Carregar mais'),
            );
          }
          return SizedBox.shrink();
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
      appBar: AppBar(
        title: Text(manga['title']),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(
              manga['images']['jpg']['image_url'],
              height: 200,
            ),
            SizedBox(height: 16),
            Text(
              manga['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              manga['synopsis'] ?? 'Sinopse não disponível',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
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
      appBar: AppBar(
        title: Text('Minha Lista'),
        backgroundColor: Colors.blue,
      ),
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
                MaterialPageRoute(
                  builder: (context) => MangaDetailPage(manga: manga),
                ),
              );
            },
          );
        },
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
        backgroundColor: Colors.blue,
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
                  backgroundImage: NetworkImage('URL_DA_SUA_FOTO'), // Adicione sua URL
                ),
                SizedBox(width: 10),
                Text('Matheus Stolf', style: TextStyle(fontSize: 20)),
              ],
            ),
            SizedBox(height: 16),

            // Membro 1
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('URL_DO_MEMBRO_1'), // Adicione a URL do membro 1
                ),
                SizedBox(width: 10),
                Text('Mateus Barros', style: TextStyle(fontSize: 20)),
              ],
            ),
            SizedBox(height: 16),

            // Membro 2
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('URL_DO_MEMBRO_2'), // Adicione a URL do membro 2
                ),
                SizedBox(width: 10),
                Text('Juliano Alessandro', style: TextStyle(fontSize: 20)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

