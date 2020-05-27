import "package:flutter/material.dart";
import "shared.dart";

class SummaryScreen extends StatelessWidget{
  SummaryScreen({Key key}) : super(key: key);

  @override
    Widget build(BuildContext xcontext) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(APP_TITLE),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: const EdgeInsets.all(12.0),),
              Text("1st Period", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      Column(children: <Widget>[Text("Our Team")],),
                      Column(children: <Widget>[Text("12")],),
                      Column(children: <Widget>[Text("Their Team")],),
                      Column(children: <Widget>[Text("7")],),                    
                    ]
                  ), 
                ],
              ),
              Padding(padding: const EdgeInsets.all(12.0),),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      Column(children: <Widget>[Text("Time")],),
                      Column(children: <Widget>[Text("Team")],),
                      Column(children: <Widget>[Text("Type")],),
                      Column(children: <Widget>[Text("Players on ice")],),                    
                    ]
                  ), 
                ],
              ),
              Padding(padding: const EdgeInsets.all(12.0),),
              Text("2nd Period", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      Column(children: <Widget>[Text("Our Team")],),
                      Column(children: <Widget>[Text("12")],),
                      Column(children: <Widget>[Text("Their Team")],),
                      Column(children: <Widget>[Text("7")],),                    
                    ]
                  ), 
                ],
              ),
              Padding(padding: const EdgeInsets.all(12.0),),
              Text("3rd Period", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      Column(children: <Widget>[Text("Our Team")],),
                      Column(children: <Widget>[Text("12")],),
                      Column(children: <Widget>[Text("Their Team")],),
                      Column(children: <Widget>[Text("7")],),                    
                    ]
                  ), 
                ],
              ),              Padding(padding: const EdgeInsets.all(12.0),),
              Text("Overtime", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      Column(children: <Widget>[Text("Our Team")],),
                      Column(children: <Widget>[Text("12")],),
                      Column(children: <Widget>[Text("Their Team")],),
                      Column(children: <Widget>[Text("7")],),                    
                    ]
                  ), 
                ],
              ),              Padding(padding: const EdgeInsets.all(12.0),),
              Text("Shootout", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      Column(children: <Widget>[Text("Our Team")],),
                      Column(children: <Widget>[Text("12")],),
                      Column(children: <Widget>[Text("Their Team")],),
                      Column(children: <Widget>[Text("7")],),                    
                    ]
                  ), 
                ],
              ),
            ],
          )
        )
      )
    );
    }
}
