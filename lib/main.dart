import 'package:flutter/material.dart';
import 'package:flutter_mistake_app/addOrEdit.dart';
import 'package:flutter_mistake_app/database.dart';
import 'package:intl/intl.dart';

import 'Mistake.dart';

void main() async {
  //WHEN I STILL DIDNT HAVE THIS THING HERE I WAS ACTUALLY CRYING OVER WHY THE APP WOULDNT RUN
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
  //mistakes that will come from the database
  late List<Mistake> mistakes;
  //to ensure that the database has loaded before updating the screen or something
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

  //updates the list of mistakes
  Future refreshMistakes() async {
    setState(() => isLoading = true);

    this.mistakes = await MistakeDatabase.instance.readAllMistakes();

    setState(() => isLoading = false);
  }

  var dropdownValue = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          DropdownButton<String>(
            value: dropdownValue,
            hint: Text("Subject"),
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>['One', 'Two', 'Free', 'Four']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )
        ],
      ),
      body: Center(
        //if it's loading, return loading screen, then if the list of mistakes r empty return "no entries" and return the listview if it isn't empty
        child: isLoading
            ? CircularProgressIndicator()
            : mistakes.isEmpty
                ? Text('No Entries',
                    style: TextStyle(color: Colors.black, fontSize: 24))
                : _buildListViewSeparated(),
      ),
      floatingActionButton: FloatingActionButton(
        //async so that the refreshMistakes() happens after you come back from whereever screen you came from
        onPressed: () async {
          await Navigator.of(context).push(
            //in this case it's add
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
          //it's just easier to do this lol
          final mistake = mistakes[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 7.5, horizontal: 20.0),
            child: Card(
              child: ListTile(
                //async so that the refreshMistakes() happens after you come back from whereever screen you came from
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                        //in this case it's edit
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
