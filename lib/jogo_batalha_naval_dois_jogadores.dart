import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class JogoBatalhaNavalDoisJogadores extends StatelessWidget {
  const JogoBatalhaNavalDoisJogadores({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProvedorJogo(),
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: darkBlue,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('Batalha Naval'),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: TelaBatalhaNaval(),
        ),
      ),
    );
  }
}

class Celula {
  bool temNavio;
  bool foiAtingido;

  Celula({this.temNavio = false, this.foiAtingido = false});
}

class ProvedorJogo with ChangeNotifier {
  final List<int> tamanhosNavios = [5, 4, 3, 3, 2];
  final int tamanhoTabuleiro = 10;
  List<List<Celula>> tabuleiroJogador1;
  List<List<Celula>> tabuleiroJogador2;
  int quantidadeAcertosJogador1 = 0;
  int quantidadeAcertosJogador2 = 0;
  final int totalNavios;
  bool venceu = false;
  int jogadorAtual = 1;

  ProvedorJogo()
      : tabuleiroJogador1 = List.generate(
      10, (_) => List.generate(10, (_) => Celula())),
        tabuleiroJogador2 = List.generate(
            10, (_) => List.generate(10, (_) => Celula())),
        totalNavios = [5, 4, 3, 3, 2].reduce((a, b) => a + b) {
    _posicionarNavios(tabuleiroJogador1, tamanhosNavios);
    _posicionarNavios(tabuleiroJogador2, tamanhosNavios);
  }

  void reiniciarJogo() {
    tabuleiroJogador1 = List.generate(tamanhoTabuleiro,
            (_) => List.generate(tamanhoTabuleiro, (_) => Celula()));
    tabuleiroJogador2 = List.generate(tamanhoTabuleiro,
            (_) => List.generate(tamanhoTabuleiro, (_) => Celula()));
    quantidadeAcertosJogador1 = 0;
    quantidadeAcertosJogador2 = 0;
    venceu = false;
    jogadorAtual = 1;
    _posicionarNavios(tabuleiroJogador1, tamanhosNavios);
    _posicionarNavios(tabuleiroJogador2, tamanhosNavios);
    notifyListeners();
  }

  void _posicionarNavios(
      List<List<Celula>> tabuleiro, List<int> tamanhosNavios) {
    final random = Random();

    for (int tamanho in tamanhosNavios) {
      bool posicionado = false;
      while (!posicionado) {
        bool orientacaoHorizontal = random.nextBool();
        int linhaInicial = random.nextInt(tamanhoTabuleiro);
        int colunaInicial = random.nextInt(tamanhoTabuleiro);

        if (orientacaoHorizontal) {
          if (colunaInicial + tamanho <= tamanhoTabuleiro) {
            bool sobreposto = false;
            for (int i = 0; i < tamanho; i++) {
              if (tabuleiro[linhaInicial][colunaInicial + i].temNavio) {
                sobreposto = true;
                break;
              }
            }
            if (!sobreposto) {
              for (int i = 0; i < tamanho; i++) {
                tabuleiro[linhaInicial][colunaInicial + i].temNavio = true;
              }
              posicionado = true;
            }
          }
        } else {
          if (linhaInicial + tamanho <= tamanhoTabuleiro) {
            bool sobreposto = false;
            for (int i = 0; i < tamanho; i++) {
              if (tabuleiro[linhaInicial + i][colunaInicial].temNavio) {
                sobreposto = true;
                break;
              }
            }
            if (!sobreposto) {
              for (int i = 0; i < tamanho; i++) {
                tabuleiro[linhaInicial + i][colunaInicial].temNavio = true;
              }
              posicionado = true;
            }
          }
        }
      }
    }
  }

  void atirar(int x, int y, BuildContext context) {
    List<List<Celula>> tabuleiro =
    jogadorAtual == 1 ? tabuleiroJogador2 : tabuleiroJogador1;
    int quantidadeAcertos =
    jogadorAtual == 1 ? quantidadeAcertosJogador1 : quantidadeAcertosJogador2;

    if (!tabuleiro[x][y].foiAtingido) {
      tabuleiro[x][y].foiAtingido = true;
      if (tabuleiro[x][y].temNavio) {
        quantidadeAcertos++;
        if (jogadorAtual == 1) {
          quantidadeAcertosJogador1 = quantidadeAcertos;
        } else {
          quantidadeAcertosJogador2 = quantidadeAcertos;
        }
        if (quantidadeAcertos == totalNavios) {
          venceu = true;
          _mostrarDialogoVitoria(context);
        }
      }
      jogadorAtual = jogadorAtual == 1 ? 2 : 1;
      notifyListeners();
    }
  }

  void _mostrarDialogoVitoria(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Parabéns!'),
          content: Text('Jogador ${jogadorAtual == 1 ? 2 : 1} ganhou o jogo!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                reiniciarJogo();
              },
              child: Text('Jogar Novamente'),
            ),
          ],
        );
      },
    );
  }
}

class TelaBatalhaNaval extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double gridSize = constraints.maxWidth / 2 - 20;
          double cellSize = gridSize / 10;
          return Center(
            child: Consumer<ProvedorJogo>(
              builder: (context, jogo, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Tabuleiro do Jogador 1 (Jogador 2 atira aqui)'),
                    _buildGrid(context, jogo, 2, cellSize),
                    SizedBox(height: 20),
                    Text('Tabuleiro do Jogador 2 (Jogador 1 atira aqui)'),
                    _buildGrid(context, jogo, 1, cellSize),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid(BuildContext context, ProvedorJogo jogo, int tabuleiroDoOponente, double cellSize) {
    return SizedBox(
      width: cellSize * 15,
      height: cellSize * 15,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: jogo.tamanhoTabuleiro,
        ),
        itemCount: jogo.tamanhoTabuleiro * jogo.tamanhoTabuleiro,
        itemBuilder: (context, index) {
          int x = index % jogo.tamanhoTabuleiro;
          int y = index ~/ jogo.tamanhoTabuleiro;
          Celula celula = tabuleiroDoOponente == 1
              ? jogo.tabuleiroJogador1[x][y]
              : jogo.tabuleiroJogador2[x][y];
          return GestureDetector(
            onTap: () {
              if (!jogo.venceu && jogo.jogadorAtual == (tabuleiroDoOponente == 1 ? 2 : 1)) {
                jogo.atirar(x, y, context);
              }
            },
            child: Container(
              width: cellSize,
              height: cellSize,
              margin: EdgeInsets.all(2.0),
              color: celula.foiAtingido
                  ? (celula.temNavio ? Colors.red : Colors.blue)
                  : Colors.white,
            ),
          );
        },
      ),
    );
  }
}
