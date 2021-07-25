import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class add_entry extends StatefulWidget {
  const add_entry({Key? key}) : super(key: key);

  @override
  _add_entryState createState() => _add_entryState();
}

class _add_entryState extends State<add_entry> {
  TextEditingController _titleInputController = new TextEditingController();
  TextEditingController _subjectInputController = new TextEditingController();
  TextEditingController _topicInputController = new TextEditingController();
  TextEditingController _descInputController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _titleInputController.dispose();
    _subjectInputController.dispose();
    _topicInputController.dispose();
    _descInputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a New Entry"),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
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
                      controller: _titleInputController,
                      decoration: InputDecoration(
                        hintText: "Add a title...",
                        hintStyle: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                  ),
                ),
                //enables the user to change their input
                Icon(Icons.edit),
              ],
            ),
          ),
          //-------------Subject-------------//
          Padding(padding: EdgeInsets.only(top: 20.0)),
          Text("Subject of the Mistake (Example: Math",
              style: TextStyle(fontSize: 16.0)),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _subjectInputController,
                      decoration: InputDecoration(
                        hintText: "Add a subject...",
                        hintStyle: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                  ),
                ),
                //enables the user to change their input
                Icon(Icons.edit),
              ],
            ),
          ),
          //-------------Topic-------------//
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
                      controller: _topicInputController,
                      decoration: InputDecoration(
                        hintText: "Add a Topic...",
                        hintStyle: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                  ),
                ),
                //enables the user to change their input
                Icon(Icons.edit),
              ],
            ),
          ),
          //-------------Description-------------//
          Padding(padding: EdgeInsets.only(top: 20.0)),
          Text("Description of the Mistake", style: TextStyle(fontSize: 16.0)),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _descInputController,
                      decoration: InputDecoration(
                        hintText: "Add a description...",
                        hintStyle: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                  ),
                ),
                //enables the user to change their input
                Icon(Icons.edit),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
