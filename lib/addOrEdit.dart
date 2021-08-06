import 'package:flutter/material.dart';
import 'package:flutter_mistake_app/Mistake.dart';
import 'package:flutter_mistake_app/database.dart';
import 'package:flutter_mistake_app/mistake_form_widget.dart';

class AddOrEdit extends StatefulWidget {
  final Mistake? mistake;

  AddOrEdit({
    Key? key,
    this.mistake,
  }) : super(key: key);

  @override
  _AddOrEditState createState() => _AddOrEditState();
}

class _AddOrEditState extends State<AddOrEdit> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late String topic;
  late String subject;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

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
    final isFormValid = title.isNotEmpty &&
        description.isNotEmpty &&
        topic.isNotEmpty &&
        subject.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateMistake,
        child: Text('Save'),
      ),
    );
  }

  Widget deleteButton() {
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
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.mistake != null;

      if (isUpdating) {
        await updateMistake();
      } else {
        await addMistake();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateMistake() async {
    final mistake = widget.mistake!.copy(
      title: title,
      desc: description,
      topic: topic,
      subject: subject,
    );

    await MistakeDatabase.instance.update(mistake);
  }

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
