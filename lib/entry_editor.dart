import 'package:flutter/material.dart';

//The app goes here after user clicks on one of the entries or the + button

class entry_editor extends StatefulWidget {
  const entry_editor({Key? key, required this.snapshot, required this.index})
      : super(key: key);

  final AsyncSnapshot snapshot;
  final index;

  @override
  _entry_editorState createState() => _entry_editorState();
}

class _entry_editorState extends State<entry_editor> {
  bool _titleIsEditable = false;
  bool _subjectIsEditable = false;
  bool _descIsEditable = false;
  bool _topicIsEditable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.snapshot.data[widget.index].title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //---------------------title------------------------//
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Text("Title (Name/Tag of the quiz)",
                style: TextStyle(fontSize: 16.0)),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText:
                              "${widget.snapshot.data[widget.index].title}",
                          hintStyle: TextStyle(color: Colors.blueGrey),
                        ),
                        enabled: _titleIsEditable,
                      ),
                    ),
                  ),
                  //enables the user to change their input
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _titleIsEditable = !_titleIsEditable;
                      });
                    },
                  ),
                ],
              ),
            ),
//  -------------------------subject------------------------//
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Text("Subject of the Mistake (Example: Math)",
                style: TextStyle(fontSize: 16.0)),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText:
                              "${widget.snapshot.data[widget.index].subject}",
                          hintStyle: TextStyle(color: Colors.blueGrey),
                        ),
                        enabled: _subjectIsEditable,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _subjectIsEditable = !_subjectIsEditable;
                      });
                    },
                  ),
                ],
              ),
            ),
//  -------------------------topic------------------------//
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Text("Topic of the Mistake (Example: Grammar)",
                style: TextStyle(fontSize: 16.0)),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText:
                              "${widget.snapshot.data[widget.index].topic}",
                          hintStyle: TextStyle(color: Colors.blueGrey),
                        ),
                        enabled: _topicIsEditable,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _topicIsEditable = !_topicIsEditable;
                      });
                    },
                  ),
                ],
              ),
            ),
//  -------------------------desc------------------------//
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Text("Description of the Mistake",
                style: TextStyle(fontSize: 16.0)),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText:
                              "${widget.snapshot.data[widget.index].desc}",
                          hintStyle: TextStyle(color: Colors.blueGrey),
                        ),
                        enabled: _descIsEditable,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _descIsEditable = !_descIsEditable;
                      });
                    },
                  ),
                ],
              ),
            ),
//  -------------------------end?------------------------//
          ],
        ),
      ),
    );
  }
}
