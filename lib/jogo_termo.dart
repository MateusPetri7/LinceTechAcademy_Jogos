import 'dart:math';
import 'package:flutter/material.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class JogoTermo extends StatelessWidget {
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
            child: Text('Termo'),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: TelaTermo(),
        ),
      ),
    );
  }
}

class TelaTermo extends StatefulWidget {
  @override
  _TelaTermoState createState() => _TelaTermoState();
}

class _TelaTermoState extends State<TelaTermo> {
  final List<String> palavras = ['CASAS', 'CARRO', 'PLUMA', 'FAROL', 'LIVRO'];
  late String palavraSecreta;
  List<List<String>> tentativas = List.generate(6, (_) => List.generate(5, (_) => ''));
  int tentativaAtual = 0;
  int letraAtual = 0;
  String statusMensagem = '';
  bool acertouPalavra = false;

  @override
  void initState() {
    super.initState();
    palavraSecreta = palavras[Random().nextInt(palavras.length)];
  }

  void _inserirLetra(String letra) {
    if (letraAtual < 5 && !acertouPalavra) {
      setState(() {
        tentativas[tentativaAtual][letraAtual] = letra;
        letraAtual++;
      });
    }
  }

  void _removerLetra() {
    if (letraAtual > 0 && !acertouPalavra) {
      setState(() {
        letraAtual--;
        tentativas[tentativaAtual][letraAtual] = '';
      });
    }
  }

  void _enviarTentativa() {
    if (letraAtual == 5 && !acertouPalavra) {
      String tentativa = tentativas[tentativaAtual].join();
      if (tentativa == palavraSecreta) {
        setState(() {
          statusMensagem = 'Parabéns! Você acertou!';
          acertouPalavra = true;
        });
      } else if (tentativaAtual < 5) {
        setState(() {
          tentativaAtual++;
          letraAtual = 0;
          statusMensagem = 'Tente novamente!';
        });
      } else {
        setState(() {
          statusMensagem = 'Você perdeu! A palavra era $palavraSecreta';
        });
      }
    }
  }

  Color _obterCorCaixa(int linha, int coluna) {
    String letra = tentativas[linha][coluna];
    if (acertouPalavra && linha == tentativaAtual) return Colors.green;
    if (linha >= tentativaAtual) return Colors.grey;
    if (palavraSecreta[coluna] == letra) return Colors.green;
    if (palavraSecreta.contains(letra)) return Colors.yellow;
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...tentativas.asMap().entries.map((entry) {
            int linhaIndex = entry.key;
            List<String> tentativa = entry.value;
            return LinhaTentativa(
              tentativa: tentativa,
              linhaIndex: linhaIndex,
              obterCorCaixa: _obterCorCaixa,
            );
          }).toList(),
          SizedBox(height: 20.0),
          Text(
            statusMensagem,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          CustomKeyboard(
            onLetterPressed: _inserirLetra,
            onDeletePressed: _removerLetra,
            onEnterPressed: _enviarTentativa,
          ),
        ],
      ),
    );
  }
}

class LinhaTentativa extends StatelessWidget {
  final List<String> tentativa;
  final int linhaIndex;
  final Color Function(int, int) obterCorCaixa;

  LinhaTentativa({
    required this.tentativa,
    required this.linhaIndex,
    required this.obterCorCaixa,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: tentativa.asMap().entries.map((entry) {
        int colunaIndex = entry.key;
        String letra = entry.value;
        return Container(
          margin: EdgeInsets.all(4.0),
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            color: obterCorCaixa(linhaIndex, colunaIndex),
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(
              letra,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class CustomKeyboard extends StatelessWidget {
  final Function(String) onLetterPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onEnterPressed;

  CustomKeyboard({
    required this.onLetterPressed,
    required this.onDeletePressed,
    required this.onEnterPressed,
  });

  final List<String> letras = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', ''
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 7,
          children: List.generate(letras.length, (index) {
            return TextButton(
              onPressed: () => onLetterPressed(letras[index]),
              child: Text(letras[index], style: TextStyle(fontSize: 20.0)),
            );
          }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: onDeletePressed,
              child: Text('⌫', style: TextStyle(fontSize: 20.0)),
            ),
            TextButton(
              onPressed: onEnterPressed,
              child: Text('Enter', style: TextStyle(fontSize: 20.0)),
            ),
          ],
        ),
      ],
    );
  }
}
