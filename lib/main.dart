import 'package:flutter/material.dart';
import 'package:flutter_mistake_app/addOrEdit.dart';
import 'package:flutter_mistake_app/database.dart';
import 'package:intl/intl.dart';

import 'Mistake.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  late List<Mistake> mistakes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshMistakes();
  }

  @override
  void dispose() {
    MistakeDatabase.instance.close();
    super.dispose();
  }

  Future refreshMistakes() async {
    setState(() => isLoading = true);

    this.mistakes = await MistakeDatabase.instance.readAllMistakes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : mistakes.isEmpty
                ? Text('No Entries',
                    style: TextStyle(color: Colors.black, fontSize: 24))
                : _buildListViewSeparated(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddOrEdit()),
          );

          refreshMistakes();
        },
        tooltip: 'Create a New Entry',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //puts entries on the screen
  Widget _buildListViewSeparated() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: mistakes.length,
        itemBuilder: (context, index) {
          final mistake = mistakes[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 7.5, horizontal: 20.0),
            child: Card(
              child: ListTile(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => AddOrEdit(mistake: mistake)),
                  );

                  refreshMistakes();
                },
                title: Text(mistake.subject + " - " + mistake.title),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 4),
                      Text(DateFormat.yMMMd().format(mistake.createdTime) +
                          " - " +
                          mistake.desc),
                      SizedBox(height: 4),
                      //will add a preview picture to here soon
                    ]),
              ),
            ),
          );
        });
  }
}
