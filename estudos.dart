import 'package:flutter/material.dart';

void main() {
  runApp(ProgressBarApp());
}

class ProgressBarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Cor de fundo da página
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFCD167), // Cor do AppBar
        ),
      ),
      initialRoute: '/', // Rota inicial
      routes: {
        '/': (context) => ProgressBarScreen(), // Rota da tela principal
        '/outraTela': (context) => OutraTela(), // Rota da outra tela
      },
    );
  }
}

class ProgressBarScreen extends StatefulWidget {
  @override
  _ProgressBarScreenState createState() => _ProgressBarScreenState();
}

class _ProgressBarScreenState extends State<ProgressBarScreen> {
  int progressValue0 = 1; // Novo valor do slider
  int progressValue1 = 1;
  int progressValue2 = 1;

  String selectedValue =
      'Ciências da Natureza e suas Tecnologias'; // Valor selecionado da DropdownButton

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Estudos',
          style: TextStyle(
              color: Colors.black), // Define a cor do texto para preto
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alinhamento à esquerda
        children: <Widget>[
          Center(
            child: Column(
              children: [
                Text(
                  'Competências a serem estudadas', // Título
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                    height: 10), // Espaçamento entre o título e o menu suspenso
                // Centraliza o DropdownButton
                DropdownButton<String>(
                  value: selectedValue,
                  onChanged: (newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  items: <String>[
                    'Ciências da Natureza e suas Tecnologias',
                    'Ciências Humanas e suas Tecnologias',
                    'Matemática e suas Tecnologias',
                    'Linguagens, Códigos e suas Tecnologias',
                    'Redação'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                16), // Aumenta o espaçamento vertical do item do menu suspenso
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          SizedBox(height: 20), // Espaçamento entre o menu suspenso e o botão
          Center(
            // Centraliza o Slider
            child: Column(
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    thumbColor: Color(0xFFFCD167), // Cor da bolinha
                    activeTrackColor:
                        Color(0xFF822E5E), // Cor da barra de progresso ativa
                    inactiveTrackColor:
                        Color(0xFFD6D6D6), // Cor da barra de progresso inativa
                    overlayColor: Color(0xFFEA68BF)
                        .withAlpha(100), // Cor de destaque ao tocar
                    trackHeight: 5.0, // Altura da barra de progresso
                    thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 12.0), // Formato da bolinha
                    overlayShape: RoundSliderOverlayShape(
                        overlayRadius: 20.0), // Formato do destaque
                  ),
                  child: Slider(
                    value: progressValue1.toDouble(),
                    min: 1,
                    max: 7,
                    onChanged: (newValue) {
                      setState(() {
                        progressValue1 = newValue.toInt();
                      });
                    },
                  ),
                ),
                Text(
                  'Dias da semana: $progressValue1',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 30), // Espaçamento entre os sliders
                SliderTheme(
                  data: SliderThemeData(
                    thumbColor: Color(0xFFFCD167), // Cor da bolinha
                    activeTrackColor:
                        Color(0xFF822E5E), // Cor da barra de progresso ativa
                    inactiveTrackColor:
                        Color(0xFFD6D6D6), // Cor da barra de progresso inativa
                    overlayColor: Color(0xFFEA68BF)
                        .withAlpha(100), // Cor de destaque ao tocar
                    trackHeight: 5.0, // Altura da barra de progresso
                    thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 12.0), // Formato da bolinha
                    overlayShape: RoundSliderOverlayShape(
                        overlayRadius: 20.0), // Formato do destaque
                  ),
                  child: Slider(
                    value: progressValue2.toDouble(),
                    min: 1,
                    max: 24,
                    onChanged: (newValue) {
                      setState(() {
                        progressValue2 = newValue.toInt();
                      });
                    },
                  ),
                ),
                Text(
                  'Horas no dia: $progressValue2',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          SizedBox(height: 20), // Espaçamento entre o botão e o final da tela
          Align(
            alignment: Alignment.center, // Centraliza o botão
            child: ElevatedButton(
              onPressed: () {
                // Navegar para outra tela ao clicar no botão "Ir"
                Navigator.pushNamed(context, '/outraTela');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: 40, vertical: 24), // Aumenta o tamanho do botão
                backgroundColor: Color(0xFFEA86BF), // Cor de fundo do botão
              ),
              child: Text(
                'Ir',
                style: TextStyle(
                    fontSize: 18), // Aumenta o tamanho do texto do botão
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Tela adicional (outraTela)
class OutraTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Outra Tela'),
      ),
      body: Center(
        child: Text('Esta é outra tela!'),
      ),
    );
  }
}
