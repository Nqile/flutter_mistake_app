import 'package:flutter/material.dart';

import 'Mistake.dart';
import 'add_entry.dart';
import 'entry_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Mistake Compiler'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //fodder mistakes to test ui
  List<Mistake> _dummyMistakes = [
    Mistake("Q2-Quiz #4", "Trigonometry", "Wrong formula used", "Math", "0"),
    Mistake("Q1-Quiz #1", "Algebra",
        "I'm not sure, google it later or ask teacher abt it", "Math", "1"),
    Mistake(
        "Q3-Quiz #2", "Sin law", "sorry pre di ko na rin alam pre", "Math", "2")
  ];

  //method for supposedly getting data from a json file
  Future<List<Mistake>> _getMistakes() async {
    final List<Mistake> mistakes = await _dummyMistakes;

    return mistakes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _getMistakes(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : _buildListViewSeparated(snapshot);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //clicking the card goes to the details of the card yes epic
          var route = new MaterialPageRoute(
            builder: (BuildContext context) => new add_entry(),
          );
          Navigator.of(context).push(route);
        },
        tooltip: 'Create a New Entry',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //listview builder for the futurebuilder
  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 7.5, horizontal: 20.0),
            child: Card(
              child: ListTile(
                onTap: () {
                  //clicking the card goes to the details of the card yes epic
                  var route = new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new entry_editor(snapshot: snapshot, index: index),
                  );
                  Navigator.of(context).push(route);
                },
                title: Text(snapshot.data[index].subject +
                    " - " +
                    snapshot.data[index].title),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(snapshot.data[index].desc),
                      //will add a preview picture to here soon
                    ]),
              ),
            ),
          );
        });
  }
}
