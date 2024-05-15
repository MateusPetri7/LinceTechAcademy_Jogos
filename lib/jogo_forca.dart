import 'dart:math';
import 'package:flutter/material.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class JogoForca extends StatelessWidget {
  const JogoForca({super.key});

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
            child: Text('Jogo da Forca'),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: TelaForca(),
      ),
    );
  }
}

class TelaForca extends StatefulWidget {
  const TelaForca({Key? key}) : super(key: key);

  @override
  State<TelaForca> createState() => _TelaForcaState();
}

class _TelaForcaState extends State<TelaForca> {
  final List<Map<String, String>> palavras = [
    {
      'palavra': 'FLUTTER',
      'dica': 'Framework de desenvolvimento de aplicativos'
    },
    {'palavra': 'DESENVOLVIMENTO', 'dica': 'Processo de criar software'},
    {'palavra': 'ESCOLA', 'dica': 'Se preparar para o futuro'},
    {
      'palavra': 'HAMBURGUER',
      'dica': 'Um dos alimentos rápidos mais populares do mundo'
    },
    {'palavra': 'APLICATIVO', 'dica': 'Programa para dispositivos móveis'},
    {'palavra': 'GIRASSOL', 'dica': 'Uma planta que segue o movimento do sol'},
    {
      'palavra': 'OPENAI',
      'dica': 'Empresa de pesquisa em inteligência artificial'
    },
    {'palavra': 'GIRAFA', 'dica': 'Se alimenta das folhas das árvores'},
    {'palavra': 'SAPO', 'dica': 'Vive em ambientes úmidos'},
    {'palavra': 'SAL', 'dica': 'Utilizado para temperar alimentos'},
    {'palavra': 'PALAVRA', 'dica': 'Uma unidade de linguagem com significado'},
    {'palavra': 'MONTANHA', 'dica': 'Elevação natural da superfície terrestre'},
  ];

  late Map<String, String> palavraAtual;
  late List<String> letrasSelecionadas;
  int erros = 0;
  bool jogoEncerrado = false;

  @override
  void initState() {
    super.initState();
    iniciarJogo();
  }

  void iniciarJogo() {
    setState(() {
      final Random random = Random();
      palavraAtual = palavras[random.nextInt(palavras.length)];
      letrasSelecionadas = [];
      erros = 0;
      jogoEncerrado = false;
    });
  }

  bool letraSelecionada(String letra) {
    return letrasSelecionadas.contains(letra);
  }

  bool letraNaPalavra(String letra) {
    return palavraAtual['palavra']!.contains(letra);
  }

  void selecionarLetra(String letra) {
    setState(() {
      letrasSelecionadas.add(letra);
      if (!letraNaPalavra(letra)) {
        erros++;
        if (erros >= 6) {
          jogoEncerrado = true;
        }
      }
    });
  }

  bool ganhouJogo() {
    for (int i = 0; i < palavraAtual['palavra']!.length; i++) {
      if (!letrasSelecionadas.contains(palavraAtual['palavra']![i])) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Image.asset(
            'assets/images/forca$erros.png',
            height: 200,
          ),
          SizedBox(height: 20),
          Text(
            palavraAtual['dica']!,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          Text(
            palavraAtual['palavra']!
                .split('')
                .map((letra) => letraSelecionada(letra) ? letra : '_')
                .join(' '),
            style: TextStyle(fontSize: 32),
          ),
          SizedBox(height: 20),
          Teclado(
            palavraAtual: palavraAtual['palavra']!,
            letrasSelecionadas: letrasSelecionadas,
            letraNaPalavra: letraNaPalavra,
            jogoEncerrado: jogoEncerrado,
            onKeyPressed: (String letra) {
              selecionarLetra(letra);
              if (ganhouJogo()) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Parabéns!'),
                      content: Text('Você ganhou o jogo!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            iniciarJogo();
                          },
                          child: Text('Jogar Novamente'),
                        ),
                      ],
                    );
                  },
                );
              }
              if (erros >= 6) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Tentativas esgotadas!'),
                      content: Text('Você perdeu o jogo!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            iniciarJogo();
                          },
                          child: Text('Jogar Novamente'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class Teclado extends StatelessWidget {
  final Function(String) onKeyPressed;
  final String palavraAtual;
  final List<String> letrasSelecionadas;
  final Function(String) letraNaPalavra;
  final bool jogoEncerrado;

  const Teclado({
    Key? key,
    required this.onKeyPressed,
    required this.palavraAtual,
    required this.letrasSelecionadas,
    required this.letraNaPalavra,
    required this.jogoEncerrado,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> alfabeto = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');

    return Container(
      color: darkBlue,
      child: GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: alfabeto
            .map((letra) => GestureDetector(
          onTap: () {
            if (!letrasSelecionadas.contains(letra) && !jogoEncerrado) {
              onKeyPressed(letra);
            }
          },
          child: Container(
            margin: EdgeInsets.all(2),
            color: letrasSelecionadas.contains(letra)
                ? letraNaPalavra(letra)
                ? Colors.green
                : Colors.red
                : Colors.white,
            child: Center(
              child: Text(
                letra,
                style: TextStyle(color: Colors.black), // Letras pretas
              ),
            ),
          ),
        ))
            .toList(),
      ),
    );
  }
}
