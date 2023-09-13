import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(LoadingScreen());
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _showImage = true;
  late Timer _blinkTimer;

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  void _startBlinking() {
    _blinkTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        _blinkTimer.cancel();
        return;
      }
      setState(() {
        _showImage = !_showImage;
      });
    });

    Timer(Duration(seconds: 3), () {
      if (!mounted) {
        return;
      }
      runApp(MyApp());
    });
  }

  @override
  void dispose() {
    _blinkTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFFCD167),
        body: Center(
          child: AnimatedOpacity(
            opacity: _showImage ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: Image.asset(
              'assets/2.png',
              width: 400,
              height: 400,
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome Page',
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color(0xFFFCD167),
        toolbarHeight: 70,
        title: Text('Bem Vindo(a)', style: TextStyle(color: Colors.black)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/2.png',
              width: 80,
              height: 80,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomContainer(
              title: 'Estudos',
              imageAsset: 'assets/estudos.png',
            ),
            SizedBox(height: 20),
            CustomContainer(
              title: 'Reuniões',
              imageAsset: 'assets/reunioes.png',
            ),
            SizedBox(height: 20),
            CustomContainer(
              title: 'Alarmes',
              imageAsset: 'assets/alarmes.png',
            ),
          ],
        ),
      ),
    );
  }
}

class CustomContainer extends StatefulWidget {
  final String title;
  final String imageAsset;

  CustomContainer({required this.title, required this.imageAsset});

  @override
  _CustomContainerState createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          color: _isPressed ? Color(0xFFC64F80) : Color(0xFFEA86BF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.imageAsset,
              width: 40,
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
