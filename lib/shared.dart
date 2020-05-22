import 'package:flutter/material.dart';

enum enumTeamType { ours, theirs }
enum enumGoalType { es, pp, en, sh, ps }
enum enumPeriodType { one, two, three, ot, so }

class Player {
  final int id;
  final String jersey;
  bool selected = false;

  Player(this.id, this.jersey);
}

class Goal {
  final enumGoalType type;
  final enumTeamType team;
  final DateTime time;
  final enumPeriodType period; 
  final List<Player> players;

  Goal(this.type, this.team, this.time, this.period, this.players);
}
