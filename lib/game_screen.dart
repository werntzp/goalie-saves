import "package:flutter/material.dart";
import "settings_screen.dart";
import "goals_screen.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:path_provider/path_provider.dart";
import "dart:io";
import "shared.dart";

class GameScreen extends StatefulWidget{
  GameScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GameScreenState createState() => _GameScreenState();

}

class _GameScreenState extends State<GameScreen> {

  static const int GOALS = 0;
  static const int SHOTS = 1; 
  static const int UP = 0;
  static const int DOWN = 1;
  final String _logo = "images/opp_logo.png";
  enumPeriodType _period = enumPeriodType.one;
  int _ourGoals = 0;
  int _theirGoals = 0;
  int _ourShots = 0;
  int _theirShots = 0;
  double _svg = 100.00;
  String _displaySvg = "100.00"; 
  String _ourTeamName = "";
  String _theirTeamName = "Opponent";
  String _displayPeriod = "1";
  String _path = "";
  Directory _directory; 
  String _file = "logo.png";
  File _imageFile;
  List<Goal> _goals = <Goal>[];
  bool _isSwitched = false;

  // don't get goals or shots go above 99 or below 0 
  int restrictNumber(direction, counter) {

    if (direction == UP) {
      counter++;
      if (counter > 99) {
        counter = 99;
      }
    }
    else {
      counter--;
      if (counter < 0) {
        counter = 0;
      }
    }
    return counter;
  }

  // clear out all the values 
  void _reset() {
    setState(() {
      _ourGoals = 0;
      _theirGoals = 0;
      _ourShots = 0;
      _theirShots = 0;
      _svg = 100.00;
      _displaySvg = "100.00"; 
    }
    );    
  }

  // get a handle to the logo file
  Future<File> get _logoFile async {
    return File("$_path/$_file");
  }

  // decide whether to fill the logo image with the default one, 
  // or a user selected image 
  Widget _teamLogo() {
    if (_imageFile == null) {
      return Image.asset("$_logo", width: 100, height: 100,);
    } else {
      imageCache.clear();
      return Image.file(_imageFile, width: 100, height: 100,);
    }
  }

  // load team name (otherwise just use a default string)
  void _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _directory = await getApplicationDocumentsDirectory();
    _path = _directory.path;
    String extra = "no";

    if (await File("$_path/$_file").exists() == true) {
      _imageFile = await _logoFile;
    }
    else {
      _imageFile = null;
    }

    extra = (prefs.getString("extra") ?? "no");

    setState(() {
      _ourTeamName = (prefs.getString("teamname") ?? "Our Team");
      if (extra == "yes") {
        _isSwitched = true;
      }
      else {
        _isSwitched = false;
      }
    });
  }

  // move to the settings dialog page; upon return, if we have a name returned, update it
  void _settings() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
    if (result != null) {
      setState(() {
        _load();
      });
    }
  }

  // instead of just incrementing goal, bring up screen to get more details about it 
  void _addGoalExtra() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("period", _displayPeriod);
 
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GoalsScreen()),
    );
    if (result != null) {
      _goals.add(result);
    }
  }

  // export all the shots, goals, etc. to a CSV
  void _gameSummary() {
    // E_NOTIMPL
  }

  // cycle through values for the game period (1,2,3,OT, or SO)
  void _incrementPeriod() {
    setState(() {

      if (_period == enumPeriodType.one) {
        _period = enumPeriodType.two;
        _displayPeriod = "2";
      }
      else if (_period == enumPeriodType.two) {
        _period = enumPeriodType.three;
        _displayPeriod = "3";
      }
      else if (_period == enumPeriodType.three) {
        _period = enumPeriodType.ot;
        _displayPeriod = "OT";
      }
      else if (_period == enumPeriodType.ot) {
        _period = enumPeriodType.so;
        _displayPeriod = "SO";
      }
      else {
        _period = enumPeriodType.one;
        _displayPeriod = "1";
      }
    });    
  }

  // as goals or shots change, update the goalie's save percentage
  void _updateSavePercentage() {
    if (_theirShots < _theirGoals) {
      _theirShots = _theirGoals;
    }
    _svg = ((_theirShots - _theirGoals) / _theirShots) * 100.00;
    _displaySvg = _svg.toStringAsFixed(2);
  }

  // function to go up or down in goals and shots
  void _incrementOurShots() {
    _update(enumTeamType.ours, SHOTS, UP);
  }
  void _decrementOurShots() {
    _update(enumTeamType.ours, SHOTS, DOWN);
  }
  void _incrementOurGoals() {
    _update(enumTeamType.ours, GOALS, UP);
  }
  void _decrementOurGoals() {
    _update(enumTeamType.ours, GOALS, DOWN);
  }
  void _incrementTheirShots() {
    _update(enumTeamType.theirs, SHOTS, UP);
  }
  void _decrementTheirShots() {
    _update(enumTeamType.theirs, SHOTS, DOWN);
  }
  void _incrementTheirGoals() {
    _update(enumTeamType.theirs, GOALS, UP);
  }
  void _decrementTheirGoals() {
    _update(enumTeamType.theirs, GOALS, DOWN);
  }

  Widget _goalsActionButton() {
    if (_isSwitched) {
      return FloatingActionButton(heroTag: "fab1", onPressed: _addGoalExtra, backgroundColor: Colors.black, tooltip: "Add Goal", mini: true, child: Icon(Icons.add));
    } else {
      return FloatingActionButton(heroTag: "fab1", onPressed: _incrementOurGoals, backgroundColor: Colors.black, tooltip: "Add Goal", mini: true, child: Icon(Icons.add));
    }
  }

  // update number of shots or goals  
  void _update(who, what, direction) {
    setState(() {

      if ((who == enumTeamType.ours) & (what == SHOTS)) {
        _ourShots = restrictNumber(direction, _ourShots);
      }
      else if ((who == enumTeamType.ours) & (what == GOALS)) {
        _ourGoals = restrictNumber(direction, _ourGoals);
        if (_ourShots < _ourGoals) {
          _ourShots = _ourGoals;
        }
        // add or remove goal from the list
        if (direction == UP) {
          Goal g = new Goal(null, enumTeamType.ours, null, _period, null);
          _goals.add(g);
        }
        else {
          // start at end of list and remove last goal that is ours
          Iterable rev = _goals.reversed;
          for (Goal g in rev) {
            if (g.team == enumTeamType.ours) {
              _goals.remove(g);
              break;
            }    
          }
        }

      }
      else if ((who == enumTeamType.theirs) & (what == SHOTS)) {
        _theirShots = restrictNumber(direction, _theirShots);
        _updateSavePercentage();
      }
      else {
        _theirGoals = restrictNumber(direction, _theirGoals);
        if (_theirShots < _theirGoals) {
          _theirShots = _theirGoals;
        }

        // add a new goal to the list
        Goal g = new Goal(null, enumTeamType.theirs, null, _period, null);
        _goals.add(g);

        _updateSavePercentage();
      }

    });
  }

  // override the init function to see if there's a stored team name 
  @override
  void initState() {
    super.initState();
    _load();
  }

  // main build function 
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Goalie saves"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(35.0),),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      child: Column(
                        children: <Widget>[
                          Text("$_ourTeamName", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                          FittedBox(
                            fit: BoxFit.fill,
                            child: _teamLogo(),
                          ),
                        ],
                      ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                        onTap: _incrementPeriod,
                      child: Column(
                        children: <Widget>[
                          Padding(padding: const EdgeInsets.all(25.0),),
                          Text("Period", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                          Text("$_displayPeriod", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      child: Column(
                        children: <Widget>[
                          Text("$_theirTeamName", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                          FittedBox(
                            fit: BoxFit.fill,
                            child: Image.asset("$_logo", width: 100, height: 100,),
                          ),
                        ],
                      ),
                  ),
                  ],
                ),
              ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Center(
                            child: Text("Goals", style: TextStyle(fontSize: 25)),
                        ),
                    ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                            child: Row(children: <Widget>[
                              GestureDetector(
                                onLongPress: _decrementOurGoals,
                                child: Text("$_ourGoals", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 65),),
                              ),
                              _goalsActionButton(),
                            ],
                          ), 
                        ),                     
                        Container(
                            child: Row(children: <Widget>[
                              GestureDetector(
                                onLongPress: _decrementTheirGoals,
                                child: Text("$_theirGoals", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 65),),
                              ),
                              FloatingActionButton(heroTag: "fab2", onPressed: _incrementTheirGoals, backgroundColor: Colors.black, tooltip: "Add Goal", mini: true, child: Icon(Icons.add))
                            ],
                          ),
                        ),
                    ], 
                  ),
                ],
              ),
            ),
          Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          child: Center(
                            child: Text("Shots", style: TextStyle(fontSize: 20)),
                          ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Row(children: <Widget>[
                          GestureDetector(
                            onLongPress: _decrementOurShots,
                            child: Text("$_ourShots", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45, color: Colors.black54),),
                          ),
                          FloatingActionButton(heroTag: "fab3", onPressed: _incrementOurShots, backgroundColor: Colors.black54, tooltip: "Add Shot", mini: true, child: Icon(Icons.add)),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(children: <Widget>[
                          GestureDetector(
                            onLongPress: _decrementTheirShots,
                            child: Text("$_theirShots", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45, color: Colors.black54),),
                          ),
                          FloatingActionButton(heroTag: "fab4", onPressed: _incrementTheirShots, backgroundColor: Colors.black54, tooltip: "Add Shot", mini: true, child: Icon(Icons.add)),
                          ],
                        ),
                      ),
                    ], 
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Center(
                        child: Column(
                          children: <Widget>[
                          Text("Your goalie", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black54),),
                          Text("SVG%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black54),),
                          Text("$_displaySvg", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black54),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),         
            Padding(padding: const EdgeInsets.all(5.0),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(heroTag: "fab5", onPressed: _reset, backgroundColor: Colors.black, tooltip: "Reset", mini: true, child: Icon(Icons.delete)),
                FloatingActionButton(heroTag: "fab6", onPressed: _gameSummary, backgroundColor: Colors.black, tooltip: "Game Summary", mini: true, child: Icon(Icons.view_list)),
                FloatingActionButton(heroTag: "fab7", onPressed: _settings, backgroundColor: Colors.black, tooltip: "Settings", mini: true, child: Icon(Icons.settings)),
              ],
            ),
            Padding(padding: const EdgeInsets.all(10.0),),
          ]
        ),
      ),
    );
  }
}