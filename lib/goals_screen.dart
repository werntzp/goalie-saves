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
  enumPeriodType _goalPeriod = enumPeriodType.one;
  String _displayPeriod = "";
  DateTime _time;

  // load up any details or state info 
  void _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _displayPeriod = (prefs.getString("period") ?? "1");
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
    Goal g = new Goal(_goalType, enumTeamType.home, _time, p);
    Navigator.pop(context, g);

  }

  Widget _customTimePicker() {
    return new TimePickerSpinner(
      is24HourMode: true,
      isShowSeconds: false,
      normalTextStyle: TextStyle(
        fontSize: 20,
        color: Colors.black38
      ),
      highlightedTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black
      ),
      spacing: 5,
      itemHeight: 40,
      isForce2Digits: true,
      onTimeChange: (time) {
        setState(() {
          _time = time;
        });
      },
    );
  }

  Widget _renderGoalPeriods(BuildContext context) {
    return
      Container(
        child: Container(
          child: Row(
          children: <Widget>[
            Radio<enumPeriodType>(
              value: enumPeriodType.one,
              groupValue: _goalPeriod,
              onChanged: (enumPeriodType value) {
                setState(() {
                  _goalPeriod = value;
                });
              },
            ),
            Text("One", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,)),
            Radio<enumPeriodType>(
              value: enumPeriodType.two,
              groupValue: _goalPeriod,
                onChanged: (enumPeriodType value) {
                setState(() {
                  _goalPeriod = value;
                });
              },
            ),
            Text("Two", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,)),
            Radio<enumPeriodType>(
                value: enumPeriodType.three,
                groupValue: _goalPeriod,
                onChanged: (enumPeriodType value) {
                  setState(() {
                    _goalPeriod = value;
                  });
                },
              ),
            Text("Three", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,)),
            Radio<enumPeriodType>(
                value: enumPeriodType.ot,
                groupValue: _goalPeriod,
                onChanged: (enumPeriodType value) {
                  setState(() {
                    _goalPeriod = value;
                  });
                },
              ),
            Text("OT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,)),
            Radio<enumPeriodType>(
                value: enumPeriodType.so,
                groupValue: _goalPeriod,
                onChanged: (enumPeriodType value) {
                  setState(() {
                    _goalPeriod = value;
                  });
                },
              ),
            Text("SO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,)),
          ],
          ),
        ),
      );
  }

  Widget _renderGoalTypes(BuildContext context) {
    return
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
                  Padding(padding: const EdgeInsets.all(10.0),),
                  Text("Period", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  _renderGoalPeriods(context),
                  Padding(padding: const EdgeInsets.all(10.0),),
                  Text("Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  Container(
                    height: 125, 
                    child: _customTimePicker(),
                  ),
                  Padding(padding: const EdgeInsets.all(10.0),),
                  Text("Type", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  _renderGoalTypes(context),
                  Padding(padding: const EdgeInsets.all(25.0),),
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
