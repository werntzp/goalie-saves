import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart";
import "shared.dart";

class GoalsScreen extends StatefulWidget{
  GoalsScreen({Key key}) : super(key: key);

  @override
  _GoalsScreenState createState() => _GoalsScreenState();

}

class _GoalsScreenState extends State<GoalsScreen> {

  enumGoalType _goalType = enumGoalType.es;
  List<Player> _players = <Player>[];
  String _displayPeriod = "";
  DateTime _time;

  // load up any details or state info 
  void _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String t1 = "";

    setState(() {
      _displayPeriod = (prefs.getString("period") ?? "1");
      t1 = (prefs.getString("players") ?? "");
      if (t1.length > 1) {
        List<String> t2 = t1.split(";");
        for(var i = 0; i < t2.length; i++){
          try {
            if (t2[i] != "") {
              _players.add(new Player(i, t2[i]));
            }
          }
          on Exception catch (e) {
            print("error caught trying to parse: $e");
          }

    }

      }

    });

  }

  // override the init function to see if there's anything custom stored  
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _save() async {    
    // decide which period to use 
    enumPeriodType p; 
    if (_displayPeriod == "1") {
      p = enumPeriodType.one;
    }
    else if (_displayPeriod == "2") {
      p = enumPeriodType.two;
    }
    else if (_displayPeriod == "3") {
      p = enumPeriodType.three;
    }
    else if (_displayPeriod == "OT") {
      p = enumPeriodType.ot;
    }
    else {
      p = enumPeriodType.so;
    }

    // create a goal object to pass back  
    Goal g = new Goal(_goalType, enumTeamType.home, _time, p, _players);
    Navigator.pop(context, g);

  }

  Widget _customTimePicker() {
    return new TimePickerSpinner(
      is24HourMode: true,
      isShowSeconds: false,
      normalTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.black38
      ),
      highlightedTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black
      ),
      spacing: 5,
      itemHeight: 30,
      isForce2Digits: true,
      onTimeChange: (time) {
        setState(() {
          _time = time;
        });
      },
    );
  }

  Widget _listItem(int index, String jersey) {
    return ListTile(
      dense: true,
      title: Text(jersey, style: TextStyle(fontWeight: FontWeight.bold)),
      selected: _players[index].selected,
      onTap: () {
        setState(() {
          _players[index].selected = !_players[index].selected;
        });

      },
      trailing: (_players[index].selected)
                  ? Icon(Icons.check_box)
                  : Icon(Icons.check_box_outline_blank),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Goal Details"),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: <Widget>[
                  Padding(padding: const EdgeInsets.all(8.0),),
                  Text("Period $_displayPeriod", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  Padding(padding: const EdgeInsets.all(8.0),),
                  Text("Time of goal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  Container(
                    height: 100, 
                    child: _customTimePicker(),
                  ),
                  Padding(padding: const EdgeInsets.all(8.0),),
                  Text("Goal type", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  Container(
                    child: Container(
                      child: Row(
                      children: <Widget>[
                        Radio<enumGoalType>(
                          value: enumGoalType.es,
                          groupValue: _goalType,
                          onChanged: (enumGoalType value) {
                            setState(() {
                              _goalType = value;
                            });
                          },
                        ),
                        Text("ES", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,)),
                        Radio<enumGoalType>(
                          value: enumGoalType.pp,
                          groupValue: _goalType,
                            onChanged: (enumGoalType value) {
                            setState(() {
                              _goalType = value;
                            });
                          },
                        ),
                        Text("PP", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,)),
                        Radio<enumGoalType>(
                            value: enumGoalType.sh,
                            groupValue: _goalType,
                            onChanged: (enumGoalType value) {
                              setState(() {
                                _goalType = value;
                              });
                            },
                          ),
                        Text("SH", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,)),
                        Radio<enumGoalType>(
                            value: enumGoalType.en,
                            groupValue: _goalType,
                            onChanged: (enumGoalType value) {
                              setState(() {
                                _goalType = value;
                              });
                            },
                          ),
                        Text("EN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,)),
                        Radio<enumGoalType>(
                            value: enumGoalType.ps,
                            groupValue: _goalType,
                            onChanged: (enumGoalType value) {
                              setState(() {
                                _goalType = value;
                              });
                            },
                          ),
                        Text("PS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,)),
                      ],
                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(8.0),),
                  Text("Players on ice", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: ConstrainedBox(
                      constraints: new BoxConstraints(
                        maxHeight: 250.0,
                      ),
                      child: ListView.builder(
                            shrinkWrap: false,
                            itemCount: _players.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _listItem(index, _players[index].jersey); //MyItem(_players[index].toString());
                            },
                          ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(5.0),),
                  Center(
                    child: FloatingActionButton(heroTag: "fab9", onPressed: _save, backgroundColor: Colors.black, tooltip: "Add Goal", mini: true, child: Icon(Icons.add)),
                  ),
                ],
              ),
          ),
        ),
    );
  }

}
