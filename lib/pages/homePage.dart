import 'package:flutter/material.dart';
import 'package:flutter_mistake_app/pages/addOrEdit.dart';
import 'package:flutter_mistake_app/pages/subjectPage.dart';
import 'package:flutter_mistake_app/storage/database.dart';
import 'package:intl/intl.dart';

import '../model/Mistake.dart';

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
  //the subject currently displayed
  String currentSubject = "All Subjects";

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

    //this.mistakes should have the entries of all subjects at the start, but if the dropdown value is no longer null or "subjects", change it to subjects using the readSubjectMistakes method from database
    if (currentSubject == "All Subjects") {
      this.mistakes = await MistakeDatabase.instance.readAllMistakes();
    } else {
      this.mistakes = await MistakeDatabase.instance
          .readMistakesBasedOnSubject(currentSubject);
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        // actions: [_appBarActions()],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(35), child: _subjectPicker()),
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
    return SingleChildScrollView(
      child: ListView.builder(
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
                  title: mistake.subject == "All Subjects"
                      ? Text(mistake.title)
                      : Text(mistake.subject + " - " + mistake.title),
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
          }),
    );
  }

  Widget _subjectPicker() {
    return Container(
      margin: const EdgeInsets.only(left: 50, bottom: 11.0, right: 50),
      padding: EdgeInsets.only(bottom: 2, top: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 2, color: Colors.blue),
      ),
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(0.0),
                child: Text(
                  currentSubject,
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 1.0, bottom: 1.0),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: Colors.blueGrey)),
              ),
              child: Icon(Icons.arrow_drop_down, size: 28),
            ),
          ],
        ),
        onTap: () async {
          currentSubject = await Navigator.of(context).push(
            MaterialPageRoute(
                //in this case it's edit
                builder: (context) => SubjectPage()),
          );
          refreshMistakes();
        },
      ),
    );
  }
}

//scrapped ideas graveyard

// Widget _buildDropDown() {
//   return DropdownButton<String>(
//     value: dropdownValue,
//     hint: Text(
//       "Subject",
//       style: TextStyle(color: Colors.black),
//     ),
//     icon: Icon(Icons.arrow_drop_down, color: Colors.black),
//     iconSize: 24,
//     elevation: 20,
//     style: const TextStyle(color: Colors.black),
//     underline: Container(
//       height: 2,
//       color: Colors.black,
//     ),
//     onChanged: (String? newValue) {
//       setState(() {
//         dropdownValue = newValue!;
//       });
//     },
//     items: <String>['One', 'Two', 'Free', 'Four']
//         .map<DropdownMenuItem<String>>((String value) {
//       return DropdownMenuItem<String>(
//         value: value,
//         child: Text(value),
//       );
//     }).toList(),
//   );
// }

// Widget _addNewSubject() {
//   return IconButton(
//     onPressed: null,
//     icon: Icon(Icons.add_box, color: Colors.blue),
//     tooltip: "Add A New Subject",
//   );
// }
//
// Widget _appBarActions() {
//   return Container(
//     decoration: BoxDecoration(
//       color: Colors.white,
//       border: Border.all(
//         color: Colors.blue,
//         width: 4,
//       ),
//     ),
//     child: Row(
//       children: <Widget>[
//         // Padding(
//         //   padding: EdgeInsets.all(8.0),
//         //   child: _buildDropDown(),
//         // ),
//         Container(
//           // decoration: BoxDecoration(
//           //   border: Border.all(
//           //     color: Colors.white,
//           //     width: 1,
//           //   ),
//           // ),
//           child: _addNewSubject(),
//         ),
//       ],
//     ),
//   );
// }