import 'package:flutter/material.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class JogoVelha extends StatelessWidget {
  const JogoVelha({super.key});

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
            child: Text('Jogo da Velha'),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: TelaVelha(),
      ),
    );
  }
}

class TelaVelha extends StatefulWidget {
  const TelaVelha({Key? key}) : super(key: key);

  @override
  State<TelaVelha> createState() => _TelaVelhaState();
}

class _TelaVelhaState extends State<TelaVelha> {
  List<List<String>> grade = [
    ['', '', ''],
    ['', '', ''],
    ['', '', ''],
  ];

  String jogadorAtual = 'X';
  String textoInformativo = 'Verificador de Jogador!';
  bool jogoIniciado = false;
  bool primeiraPartida = true;
  int jogadas = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AbsorbPointer(
            absorbing: !jogoIniciado,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int coluna = 0; coluna < 3; coluna++)
                      myButton(linha: 0, coluna: coluna),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int coluna = 0; coluna < 3; coluna++)
                      myButton(linha: 1, coluna: coluna),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int coluna = 0; coluna < 3; coluna++)
                      myButton(linha: 2, coluna: coluna),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  textoInformativo,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              botaoInicio(),
            ],
          ),
        ],
      ),
    );
  }

  Widget myButton({required int linha, required int coluna}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: 100,
        height: 100,
        child: AbsorbPointer(
          absorbing: grade[linha][coluna] == "" ? false : true,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                clique(linha: linha, coluna: coluna);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            child: Text(
              grade[linha][coluna],
              style: const TextStyle(fontSize: 50),
            ),
          ),
        ),
      ),
    );
  }

  Widget botaoInicio() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            jogoIniciado = true;
            primeiraPartida = false;
            jogadas = 0;
            grade = List.generate(3, (index) => List.filled(3, ''));
            textoInformativo = '$jogadorAtual é sua vez.';
          });
        },
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(300, 50),
          backgroundColor: darkBlue,
        ),
        child: Center(
          child: Text(
            primeiraPartida ? "Iniciar!" : "Jogar novamente!",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void clique({required int linha, required int coluna}) {
    jogadas++;
    grade[linha][coluna] = jogadorAtual;
    bool existeVencedor =
    verificarVencedor(jogador: jogadorAtual, linha: linha, coluna: coluna);

    if (existeVencedor) {
      textoInformativo = '$jogadorAtual Venceu!';
      jogoIniciado = false;
    } else if (existeVencedor == false && jogadas == 9) {
      textoInformativo = 'Empate!';
      jogoIniciado = false;
    } else {
      if (jogadorAtual == 'X') {
        jogadorAtual = 'O';
      } else {
        jogadorAtual = 'X';
      }
      textoInformativo = '$jogadorAtual é sua vez.';
    }
  }

  bool verificarVencedor(
      {required String jogador, required int linha, required int coluna}) {
    bool venceu = true;

    for (int i = 0; i < 3; i++) {
      if (grade[linha][i] != jogador) {
        venceu = false;
        break;
      }
    }

    if (venceu == false) {
      for (int j = 0; j < 3; j++) {
        if (grade[j][coluna] != jogador) {
          venceu = false;
          break;
        } else {
          venceu = true;
        }
      }
    }

    if (venceu == false) {
      if (grade[1][1] == jogador) {
        if (grade[0][0] == jogador && grade[2][2] == jogador) {
          venceu = true;
        } else if (grade[0][2] == jogador && grade[2][0] == jogador) {
          venceu = true;
        }
      }
    }

    return venceu;
  }
}
