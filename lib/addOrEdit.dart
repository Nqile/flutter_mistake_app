import 'package:flutter/material.dart';
import 'package:flutter_mistake_app/Mistake.dart';
import 'package:flutter_mistake_app/database.dart';
import 'package:flutter_mistake_app/mistake_form_widget.dart';

class AddOrEdit extends StatefulWidget {
  //makes this nullable, so that you can call this widget whether or not you have a mistake or not
  final Mistake? mistake;

  AddOrEdit({
    Key? key,
    this.mistake,
  }) : super(key: key);

  @override
  _AddOrEditState createState() => _AddOrEditState();
}

class _AddOrEditState extends State<AddOrEdit> {
  // used for loading
  bool isLoading = false;
  
  //standard for making forms i think
  final _formKey = GlobalKey<FormState>();
  late String topic;
  late String subject;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    // incase there is no mistake passed into this widget
    title = widget.mistake?.title ?? '';
    description = widget.mistake?.desc ?? '';
    topic = widget.mistake?.topic ?? '';
    subject = widget.mistake?.subject ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [deleteButton(), buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: MistakeFormWidget(
            title: title,
            description: description,
            topic: topic,
            subject: subject,

            // when anything is changed, it is reflected i guess idk this is kind of standard form etiquette i think
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
            onChangedTopic: (topic) => setState(() => this.topic = topic),
            onChangedSubject: (subject) =>
                setState(() => this.subject = subject),
          ),
        ),
      );

  Widget buildButton() {
    // prevents empty entries
    final isFormValid = title.isNotEmpty &&
        description.isNotEmpty &&
        topic.isNotEmpty &&
        subject.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          //if the fields have something in them then the color is blue
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateMistake,
        child: Text('Save'),
      ),
    );
  }

  Widget deleteButton() {
    //if adding a mistake, this button will not exist
    if (widget.mistake != null) {
      return IconButton(
        icon: Icon(Icons.delete, color: Colors.white),
        onPressed: () async {
          await MistakeDatabase.instance.delete(widget.mistake?.id);

          Navigator.of(context).pop();
        },
      );
    } else {
      return SizedBox(width: 1);
    }
  }

  void addOrUpdateMistake() async {
    //makes it so you clicking on the save button does nothing if form is not valid
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.mistake != null;

      //if the purpose of this widget was to update a mistake, then call updateMisake(), otherwise addMistake()
      if (isUpdating) {
        await updateMistake();
      } else {
        await addMistake();
      }

      Navigator.of(context).pop();
    }
  }

  //updates a mistake
  Future updateMistake() async {
    final mistake = widget.mistake!.copy(
      title: title,
      desc: description,
      topic: topic,
      subject: subject,
    );

    await MistakeDatabase.instance.update(mistake);
  }

  //adds a mistake
  Future addMistake() async {
    final mistake = Mistake(
      title: title,
      desc: description,
      topic: topic,
      subject: subject,
      createdTime: DateTime.now(),
    );

    await MistakeDatabase.instance.create(mistake);
  }
}
