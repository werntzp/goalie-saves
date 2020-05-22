import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import "package:shared_preferences/shared_preferences.dart";
import "package:path_provider/path_provider.dart";
import "dart:io";

// class used to populate the listview 
class MyItem extends StatelessWidget {
  final int title;
  final VoidCallback onDelete;

  MyItem(this.title, {this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(title.toString()),
      onLongPress: this.onDelete,
    );
  }
}

// main class 
class SettingsScreen extends StatefulWidget{
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();

}

class _SettingsScreenState extends State<SettingsScreen> {

  final textController = TextEditingController();
  final playerController = TextEditingController();
  String _ourTeamName = "";
  String _logo = "images/opp_logo.png"; 
  String _file = "logo.png";
  String _labelText = "Player number";
  File _imageFile;
  String _path = "";
  Directory _directory; 
  List<int> _players = <int>[];
  bool _isSwitched = false;

  // get a handle to the logo file
  Future<File> get _logoFile async {
    return File("$_path/$_file");
  }

  // do we have a number?
  bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  // add new jersey numbers to the list 
  void _addItemToList(){
    setState(() {
      Text txt = Text(playerController.text);
      String str = txt.data;
      if (_isNumeric(str)) {
        _players.insert(0, int.tryParse(str));
        playerController.clear();
      }
      
    });
  }

  // load custom name and/or logo 
  void _load() async {
    String extraGoalInfo = "no";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _directory = await getApplicationDocumentsDirectory();
    _path = _directory.path;

    if (await File("$_path/$_file").exists() == true) {
      _imageFile = await _logoFile;
    }
    else {
      _imageFile = null;
    }

    setState(() {
      _ourTeamName = (prefs.getString("teamname") ?? "Our Team");
      String tmp = (prefs.getString("players") ?? "");
      if (tmp.length > 1) {
        _players.clear();
        List<String> lst = tmp.split(";");
        for (var i = 0; i < lst.length; i++) {
          try {
            _players.add(int.parse(lst[i]));
          }
          on Exception catch (e) {
            // parsing error 
            print("error caught trying to parse: $e");
          }        
        }
        extraGoalInfo = (prefs.getString("extra") ?? "no");
        if (extraGoalInfo == "yes") {
          _isSwitched = true;
        }
        else {
          _isSwitched = false;
        }

        _myList();

      }
    });
  }

  // save the new team name and/or logo (if they selected a new one)
  void _save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Text teamName = Text(textController.text);
    String name = teamName.data;
    var concatenate = StringBuffer();
    String extra = "";

    if (_isSwitched) {
      extra = "yes";
    }
    else {
      extra = "no";
    }
    prefs.setString("extra", extra);

    if (name == "") {
      name = _ourTeamName;
    }
    prefs.setString("teamname", name);

    // did they choose a new image?  
    if (_imageFile != null) {
      try {
        await File("$_path/$_file").delete();
      }
      on Exception catch (e) {
        // do nothing; probably no file to delete 
        print("error caught trying to delete file: $e");
      }
      try {
        _imageFile.copy("$_path/$_file");
      }
      on Exception catch (e) {
        // do nothing; probably no file to delete 
        print("error caught trying to copy file: $e");
      }
    }

    // did they select players?
    if (_players.length > 0) {
      _players.forEach((item){
        concatenate.write(item);
        concatenate.write(";");
      });
      prefs.setString("players", concatenate.toString());
    }

    // go back 
    Navigator.pop(context, "saved");

  }

  // get the image from the image picker 
  Future _pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  // return a listview 
  Widget _myList() {
      if (_isSwitched) { 
        return Column(
          children: <Widget>[
              Text("Players", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: ConstrainedBox(
                  constraints: new BoxConstraints(
                    maxHeight: 175.0,
                  ),
                  child: ListView.builder(
                        shrinkWrap: false,
                        itemCount: _players.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MyItem(_players[index], onDelete: () => removeItem(index));
                        },
                      )
                ),
              ),
              Padding(padding: const EdgeInsets.all(2.0),),
              Row(
                  children: <Widget>[
                    Container(
                      width: 150.0,
                      height: 38.0,
                      child: TextField(
                        controller: playerController,  
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: _labelText,
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    RaisedButton(
                      child: Text("Add"),
                      onPressed: _addItemToList,

                    ),
                  ],
                ),
          ],
        );  
      }
      else {
        return Padding(padding: const EdgeInsets.all(129.0),);

      }
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

  void removeItem(int index) {
    setState(() {
      _players = List.from(_players)
        ..removeAt(index);
    });
  }

  // override the init function to see if there's anything custom stored  
  @override
  void initState() {
    super.initState();
    _load();
  }

  // release the controller resources 
  @override
  void dispose() {
    textController.dispose();
    playerController.dispose();
    super.dispose();
  }

  // main build function
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: <Widget>[
                Padding(padding: const EdgeInsets.all(8.0),),
                Text("Team name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                Container(
                  height: 38.0,
                  child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      labelText: "$_ourTeamName",
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.all(8.0),),
                Text("Team logo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                GestureDetector(
                  onTap: _pickImage,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: _teamLogo(),
                  ),
                ),
                Padding(padding: const EdgeInsets.all(5.0),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Extra goal info", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),  
                    Padding(padding: const EdgeInsets.all(2.0),),
                    Switch(
                      value: _isSwitched,
                      onChanged: (value){
                        setState(() {
                          _isSwitched = value;                          
                        });
                      },
                    ),
                  ]
                ),
                Text("Capture time of goal, goal type, and players on the ice.", style: TextStyle(fontSize: 15),),  
                Padding(padding: const EdgeInsets.all(8.0),),
                _myList(),
                Padding(padding: const EdgeInsets.all(12.0),),
                Center(
                  child: FloatingActionButton(heroTag: "fab8", onPressed: _save, backgroundColor: Colors.black, tooltip: "Save", mini: true, child: Icon(Icons.save)),
                ),
              ],
              ),
            ),
        ),
    ); 
  }
}
