import 'package:flutter/material.dart';

import 'Mistake.dart';

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
    Mistake("Q1-Quiz #1", "Algebra", "Math"),
    Mistake("Q2-Quiz #4", "Geometry", "Math"),
    Mistake("Q3-Quiz #2", "Trigonometry", "Math")
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
        onPressed: null,
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
                  null;
                },
                title: Text(snapshot.data[index].Topic),
                subtitle: Text(snapshot.data[index].Desc),
              ),
            ),
          );
        });
  }
}
