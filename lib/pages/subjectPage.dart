import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mistake_app/pages/subjectAddOrEdit.dart';
import 'package:flutter_mistake_app/storage/subject_simple_preferences.dart';

class SubjectPage extends StatefulWidget {
  SubjectPage({Key? key}) : super(key: key);

  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  bool isLoading = false;
  List<String> subjects = ["All Subjects"];

  @override
  void initState() {
    super.initState();
    refreshSubjects();
  }

  //updates the list of subjects, used for real time updates in between pages
  Future refreshSubjects() async {
    setState(() {
      isLoading = true;
    });
    subjects = SubjectSimplePreferences.getSubjects() ?? ["All Subjects"];
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : subjects.isEmpty
                ? Text("No Subjects",
                    style: TextStyle(color: Colors.black, fontSize: 24))
                : _separateListViewBuilder(),
      ),
      floatingActionButton: FloatingActionButton(
        //async so that the refreshMistakes() happens after you come back from whereever screen you came from
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => SubjectAddOrEdit()),
          );

          refreshSubjects();
        },
        tooltip: 'Create a New Subject',
        child: const Icon(Icons.add),
      ), // This
    );
  }

  Widget _separateListViewBuilder() {
    return Column(children: <Widget>[
      ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 7.5, horizontal: 20.0),
            child: Card(
              child: ListTile(
                title: Text(subject),
                //makes it so you can NOT edit "all subjects" ever
                trailing: subject == "All Subjects"
                    ? null
                    : IconButton(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                                //in this case it's edit
                                builder: (context) =>
                                    SubjectAddOrEdit(subject: subject)),
                          );

                          refreshSubjects();
                        },
                        icon: Icon(Icons.edit, size: 15)),
                onTap: () {
                  Navigator.pop(context, subject);
                },
                onLongPress: () async {
                  if (subject != "All Subjects")
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                          //in this case it's edit
                          builder: (context) => SubjectAddOrEdit(
                                subject: subject,
                              )),
                    );

                  refreshSubjects();
                },
              ),
            ),
          );
        },
      )
    ]);
  }
}
