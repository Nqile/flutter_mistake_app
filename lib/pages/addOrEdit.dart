import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mistake_app/model/Mistake.dart';
import 'package:flutter_mistake_app/pages/subjectPage.dart';
import 'package:flutter_mistake_app/storage/database.dart';
import 'package:flutter_mistake_app/widgets/mistake_form_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
  File? img;
  String? imgPath;
  final picker = ImagePicker();

  //
  chooseImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    final permanentImg = await saveImagePermanently(pickedFile!.path);
    setState(() {
      imgPath = permanentImg.path;
    });
  }

  //copies the image into a permanent directory (supposedly)
  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

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
    subject = widget.mistake?.subject ?? 'All Subjects';
    imgPath = widget.mistake?.imgPath ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        actions: [deleteButton(), buildButton()],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 16.0),
          Text("Subject of the Mistake (Example: Math)",
              style: TextStyle(fontSize: 16.0)),
          SizedBox(height: 8.0),
          buildSubject(context),
          Form(
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
            ),
          ),
          Text("Images"),
          imageButtons(),
          Container(
              child: imgPath != null
                  ? Container(
                      width: 250,
                      height: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              //uses the imgPath as reference because that's what the database saves
                              image: FileImage(File(imgPath!)))))
                  : Container(
                      width: 250,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ))),
          SizedBox(height: 40),
        ]),
      ));

  Widget buildSubject(context) => Container(
      decoration: BoxDecoration(
          border: Border.all(
        width: 0.5,
        color: Colors.black,
      )),
      width: 380,
      height: 55,
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: GestureDetector(
                  child: Text(subject, style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: Colors.blueGrey)),
              ),
              child: Icon(
                Icons.arrow_drop_down,
                size: 40,
              ),
            ),
          ],
        ),
        onTap: () async {
          var currentSubject = await Navigator.of(context).push(
            MaterialPageRoute(
                //in this case it's edit
                builder: (context) => SubjectPage()),
          );
          setState(() {
            subject = currentSubject;
          });
        },
      ));

  Widget buildButton() {
    // prevents empty entries
    final isFormValid = title.isNotEmpty &&
        description.isNotEmpty &&
        topic.isNotEmpty &&
        subject.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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

  Widget imageButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      IconButton(
        icon: Icon(Icons.photo_camera),
        onPressed: () {
          print("Image from camera");
          chooseImage(ImageSource.camera);
        },
      ),
      IconButton(
          icon: Icon(Icons.insert_photo),
          onPressed: () {
            print("Image from gallery");
            chooseImage(ImageSource.gallery);
          }),
    ]);
  }

  Widget deleteButton() {
    //if adding a mistake, this button will not exist
    if (widget.mistake != null) {
      return IconButton(
        icon: Icon(Icons.delete, color: Colors.white),
        onPressed: () async {
          await MistakeDatabase.instance.delete(widget.mistake?.id);

          Navigator.of(this.context).pop();
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

      Navigator.of(this.context).pop();
    }
  }

  //updates a mistake
  Future updateMistake() async {
    final mistake = widget.mistake!.copy(
      title: title,
      desc: description,
      topic: topic,
      subject: subject,
      imgPath: imgPath,
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
      imgPath: imgPath!,
    );

    await MistakeDatabase.instance.create(mistake);
  }
}
