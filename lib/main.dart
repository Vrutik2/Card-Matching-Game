import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

// Main function to run the app
void main() {
  runApp(MyApp());
}

// Main App widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Matching Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChangeNotifierProvider(
        create: (context) => GameState([]),
        child: GameScreen(),
      ),
    );
  }
}

// Card model class
class CardModel {
  final String frontImage;
  final String backImage;
  bool isFaceUp;

  CardModel({required this.frontImage, required this.backImage, this.isFaceUp = false});
}

// Game state management using ChangeNotifier
class GameState with ChangeNotifier {
  List<CardModel> cards;

  GameState(this.cards);
}

// Game screen widget
class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Matching Game'),
      ),
      body: Center(child: Text('Game Grid Here')),
    );
  }
}

