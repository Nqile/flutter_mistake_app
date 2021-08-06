import 'package:flutter/material.dart';

class MistakeFormWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final String? subject;
  final String? topic;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final ValueChanged<String> onChangedSubject;
  final ValueChanged<String> onChangedTopic;

  const MistakeFormWidget({
    Key? key,
    this.title = '',
    this.description = '',
    this.subject = '',
    this.topic = '',
    required this.onChangedTitle,
    required this.onChangedDescription,
    required this.onChangedSubject,
    required this.onChangedTopic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Title (Name/Tag of the test)",
                  style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 8),
              buildTitle(),
              SizedBox(height: 8),
              Text("Subject of the Mistake (Example: Math)",
                  style: TextStyle(fontSize: 16.0)),
              buildSubject(),
              SizedBox(height: 8),
              Text("Topic of the Mistake (Example: Grammar)",
                  style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 8),
              buildTopic(),
              SizedBox(height: 8),
              Text("Description of the Mistake",
                  style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 8),
              buildDescription(),
              SizedBox(height: 16),
            ],
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.black),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The title cannot be empty' : null,
        onChanged: onChangedTitle,
      );

  Widget buildDescription() => TextFormField(
        maxLines: 5,
        initialValue: description,
        style: TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Type the description...',
          hintStyle: TextStyle(color: Colors.black),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'The description cannot be empty'
            : null,
        onChanged: onChangedDescription,
      );

  Widget buildSubject() => TextFormField(
        maxLines: 1,
        initialValue: subject,
        style: TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Type the subject...',
          hintStyle: TextStyle(color: Colors.black),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'The subject cannot be empty'
            : null,
        onChanged: onChangedSubject,
      );

  Widget buildTopic() => TextFormField(
        maxLines: 1,
        initialValue: topic,
        style: TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Type the topic...',
          hintStyle: TextStyle(color: Colors.black),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The topic cannot be empty' : null,
        onChanged: onChangedTopic,
      );
}
