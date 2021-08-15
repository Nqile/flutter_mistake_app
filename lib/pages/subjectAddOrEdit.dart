import 'package:flutter/material.dart';
import 'package:flutter_mistake_app/storage/subject_simple_preferences.dart';

class SubjectAddOrEdit extends StatefulWidget {
  String? subject;
  SubjectAddOrEdit({Key? key, this.subject}) : super(key: key);

  @override
  _SubjectAddOrEditState createState() => _SubjectAddOrEditState();
}

class _SubjectAddOrEditState extends State<SubjectAddOrEdit> {
  String currentSubject = '';
  String titleAppBar = '';
  List<String> subjects = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // if there is no subject, then it is empty
    currentSubject = widget.subject ?? '';
    // different text depending on if user is editing or adding a subject
    titleAppBar = widget.subject != null ? "Edit a Subject" : "Add a Subject";
    // if there are no stored subjects, default subject list to have at least "all subjects"
    subjects = SubjectSimplePreferences.getSubjects() ?? ["All Subjects"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleAppBar),
        actions: [deleteButton()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            subjectForm(),
            SizedBox(height: 8),
            saveButton(),
          ],
        ),
      ),
    );
  }

  //subject form
  Widget subjectForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
        child: buildSubject(),
      ),
    );
  }

  //subject input holder
  Widget buildSubject() => TextFormField(
        maxLines: 1,
        initialValue: currentSubject,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 12.0),
          border: OutlineInputBorder(),
          hintText: 'Type something...',
          hintStyle: TextStyle(color: Colors.black),
        ),
        validator: (currentSubject) =>
            currentSubject != null && currentSubject.isEmpty
                ? 'The subject cannot be empty'
                : null,
        onChanged: (currentSubject) {
          setState(() => this.currentSubject = currentSubject);
          print(_formKey.currentState!.validate());
        },
      );

  //save button
  Widget saveButton() {
    //only clickable if there is text inside the subject thing
    final isFormValid = currentSubject.isNotEmpty;

    return Container(
        height: 70,
        width: 400,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(fontSize: 20),
              padding: EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 10.0, bottom: 10.0),
              onPrimary: Colors.white,
              //if the fields have something in them then the color is blue
              primary: isFormValid ? null : Colors.grey.shade700,
            ),
            onPressed: addOrUpdateSubject,
            child: Text('Save'),
          ),
        ));
  }

  void addOrUpdateSubject() async {
    //makes it so you clicking on the save button does nothing if form is not valid
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.subject != null;

      //if the purpose of this widget was to update a subject, then call updatesubject(), otherwise addsujbject()
      if (isUpdating) {
        await updateSubject();
      } else {
        await addSubject();
      }

      Navigator.of(this.context).pop();
    }
  }

  Widget deleteButton() {
    //if adding a subject, this button will not exist
    if (widget.subject != null) {
      return IconButton(
        icon: Icon(Icons.delete, color: Colors.white),
        onPressed: () async {
          subjects.remove(widget.subject);
          await SubjectSimplePreferences.setSubjects(subjects);
          Navigator.of(this.context).pop();
        },
      );
    } else {
      return SizedBox(width: 1);
    }
  }

  Future updateSubject() async {
    subjects.remove(widget.subject);
    subjects.add(currentSubject);
    await SubjectSimplePreferences.setSubjects(subjects);
  }

  Future addSubject() async {
    subjects.add(currentSubject);
    await SubjectSimplePreferences.setSubjects(subjects);
  }
}
