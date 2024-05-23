import 'package:flutter/material.dart';
import 'jogo_velha.dart';
import 'jogo_forca.dart';
import 'jogo_termo.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(
    PaginaDeJogos(),
  );
}

class PaginaDeJogos extends StatelessWidget {
  const PaginaDeJogos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => TelaPaginaDeJogos(),
        '/jogovelha': (context) => JogoVelha(),
        '/jogoforca': (context) => JogoForca(),
        '/jogotermo': (context) => JogoTermo(),
      },
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TelaPaginaDeJogos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Página de Jogos'),
          ),
        ),
        body: Center(
          child: HomeJogos(),
        ),
    );
  }
}

class HomeJogos extends StatefulWidget {
  @override
  State<HomeJogos> createState() => _HomeJogosState();
}

class _HomeJogosState extends State<HomeJogos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: _buildImageButton(
                              'assets/images/jogoVelha.png',
                                  () {
                                Navigator.pushNamed(context, '/jogovelha');
                              },
                            ),
                          ),
                          Expanded(
                            child: _buildImageButton(
                              'assets/images/termo.png',
                                  () {
                                    Navigator.pushNamed(context, '/jogotermo');
                                  },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: _buildImageButton(
                              'assets/images/forca0.png',
                                  () {
                                Navigator.pushNamed(context, '/jogoforca');
                              },
                            ),
                          ),
                          Expanded(
                            child: _buildImageButton(
                              'assets/images/batalhaNaval.png',
                                  () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageButton(String imagePath, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: Colors.white, width: 2.0),
        ),
        child: Image.asset(
          imagePath,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
