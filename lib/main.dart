import "package:flutter/material.dart";
import "game_screen.dart";
import "shared.dart";
import "summary_screen.dart";

void main() => runApp(StatsApp());

class StatsApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/summary": (context) => SummaryScreen(),
      },
      title: APP_TITLE,
      home: new GameScreen(),
    );
  }
}

