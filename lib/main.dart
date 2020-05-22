import "package:flutter/material.dart";
import "game_screen.dart";

void main() => runApp(StatsApp());

class StatsApp extends StatelessWidget {

  final String _title = "Goalie saves!";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: new GameScreen(title: _title),
    );
  }
}

