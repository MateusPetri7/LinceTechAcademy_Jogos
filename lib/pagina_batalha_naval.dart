import 'package:flutter/material.dart';
import 'jogo_batalha_naval.dart';
import 'jogo_batalha_naval_dois_jogadores.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class PaginaBatalhaNaval extends StatelessWidget {
  const PaginaBatalhaNaval({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JogoBatalhaNaval(),
                      ),
                    );
                  },
                  icon: Icon(Icons.directions),
                  label: Text('Batalha Naval Individual'),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JogoBatalhaNavalDoisJogadores(),
                      ),
                    );
                  },
                  icon: Icon(Icons.directions),
                  label: Text('Batalha Naval 2 jogadores'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
