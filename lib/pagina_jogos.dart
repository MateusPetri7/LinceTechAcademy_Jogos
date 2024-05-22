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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Página de Jogos'),
          ),
        ),
        body: Center(
          child: MyWidget(),
        ),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JogoVelha(),
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: _buildImageButton(
                              'assets/images/termo.png',
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => JogoTermo(),
                                      ),
                                    );
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JogoForca(),
                                  ),
                                );
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
