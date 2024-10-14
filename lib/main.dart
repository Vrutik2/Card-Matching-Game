import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final initialCards = List.generate(8, (index) => CardModel(
      frontImage: 'assets/design${index + 1}.png',
      backImage: 'assets/back_design.png',
    ))..addAll(List.generate(8, (index) => CardModel(
      frontImage: 'assets/design${index + 1}.png',
      backImage: 'assets/back_design.png',
    )));
    
    initialCards.shuffle(Random());

    return MaterialApp(
      title: 'Card Matching Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChangeNotifierProvider(
        create: (context) => GameState(initialCards),
        child: GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Matching Game'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Provider.of<GameState>(context, listen: false).resetGame();
            },
          ),
        ],
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.0,
            ),
            itemCount: gameState.cards.length,
            itemBuilder: (context, index) {
              return CardWidget(card: gameState.cards[index]);
            },
          );
        },
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final CardModel card;

  const CardWidget({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<GameState>(context, listen: false).flipCard(card);
      },
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: card.isFaceUp
            ? Image.asset(card.frontImage, key: ValueKey('front${card.frontImage}'))
            : Container(
                key: ValueKey('back'),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(card.backImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
      ),
    );
  }
}

class CardModel {
  final String frontImage;
  final String backImage;
  bool isFaceUp;

  CardModel({required this.frontImage, required this.backImage, this.isFaceUp = false});
}

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

  void resetGame() {
    cards.forEach((card) => card.isFaceUp = false);
    flippedCards.clear();
    // Shuffle the existing cards
    cards.shuffle(Random());
    notifyListeners();
  }
}