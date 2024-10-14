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
  List<CardModel> flippedCards = [];
  bool isFlipping = false;

  GameState(this.cards);

  void flipCard(CardModel card) {
    if (!card.isFaceUp && !isFlipping) {
      card.isFaceUp = true;
      flippedCards.add(card);

      if (flippedCards.length == 2) {
        checkForMatch();
      }
      notifyListeners();
    }
  }

  void checkForMatch() {
    isFlipping = true;
    if (flippedCards[0].frontImage == flippedCards[1].frontImage) {
      flippedCards.clear();
      isFlipping = false; // Match found, allow further interaction
    } else {
      Future.delayed(Duration(seconds: 1), () {
        flippedCards[0].isFaceUp = false;
        flippedCards[1].isFaceUp = false;
        flippedCards.clear();
        isFlipping = false; // No match, allow further interaction
        notifyListeners();
      });
    }
  }
}


