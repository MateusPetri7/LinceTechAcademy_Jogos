import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class JogoBatalhaNaval extends StatelessWidget {
  const JogoBatalhaNaval({super.key});

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
  List<List<Celula>> tabuleiroJogador;
  int quantidadeAcertos = 0;
  final int totalNavios;
  bool venceu = false;

  ProvedorJogo()
      : tabuleiroJogador =
  List.generate(10, (_) => List.generate(10, (_) => Celula())),
        totalNavios = [5, 4, 3, 3, 2].reduce((a, b) => a + b) {
    _posicionarNavios(tabuleiroJogador, tamanhosNavios);
  }

  void reiniciarJogo() {
    tabuleiroJogador = List.generate(tamanhoTabuleiro,
            (_) => List.generate(tamanhoTabuleiro, (_) => Celula()));
    quantidadeAcertos = 0;
    venceu = false;
    _posicionarNavios(tabuleiroJogador, tamanhosNavios);
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
    if (!tabuleiroJogador[x][y].foiAtingido) {
      tabuleiroJogador[x][y].foiAtingido = true;
      if (tabuleiroJogador[x][y].temNavio) {
        quantidadeAcertos++;
        if (quantidadeAcertos == totalNavios) {
          venceu = true;
          _mostrarDialogoVitoria(context);
        }
      }
      notifyListeners();
    }
  }

  void _mostrarDialogoVitoria(BuildContext context) {
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
      body: Center(
        child: Consumer<ProvedorJogo>(
          builder: (context, jogo, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: jogo.tamanhoTabuleiro,
                    ),
                    itemCount: jogo.tamanhoTabuleiro * jogo.tamanhoTabuleiro,
                    itemBuilder: (context, index) {
                      int x = index % jogo.tamanhoTabuleiro;
                      int y = index ~/ jogo.tamanhoTabuleiro;
                      Celula celula = jogo.tabuleiroJogador[x][y];
                      return GestureDetector(
                        onTap: () {
                          if (!jogo.venceu) {
                            jogo.atirar(x, y, context);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.all(2.0),
                          color: celula.foiAtingido
                              ? (celula.temNavio ? Colors.red : Colors.blue)
                              : Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
