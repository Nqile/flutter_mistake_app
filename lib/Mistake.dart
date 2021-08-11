final String tableMistakes = 'mistakes';

//used for creating a table in database sqflite
class MistakeFields {
  static final List<String> values = [id, title, topic, desc, subject, time];

  static final String id = '_id';
  static final String title = '_title';
  static final String topic = '_topic';
  static final String desc = '_desc';
  static final String subject = '_subject';
  static final String time = '_time';
  static final String imgPath = '_imgPath';
}

class Mistake {
  final String title, topic, desc, subject, imgPath;
  final DateTime createdTime;
  //id is for sqflite
  final int? id;

  Mistake(
      {this.id,
      required this.title,
      required this.topic,
      required this.desc,
      required this.subject,
      required this.createdTime,
      required this.imgPath});

//i think what this does is copies contents of one mistake to another (used for updating a mistake i think)
  Mistake copy({
    int? id,
    String? title,
    String? topic,
    String? desc,
    String? subject,
    DateTime? createdTime,
    String? imgPath,
  }) =>
      Mistake(
        id: id ?? this.id,
        title: title ?? this.title,
        topic: topic ?? this.topic,
        desc: desc ?? this.desc,
        subject: subject ?? this.subject,
        createdTime: createdTime ?? this.createdTime,
        imgPath: imgPath ?? this.imgPath,
      );

  //returns a map of the mistake
  Map<String, Object?> toJson() => {
        MistakeFields.id: id,
        MistakeFields.title: title,
        MistakeFields.topic: topic,
        MistakeFields.desc: desc,
        MistakeFields.subject: subject,
        MistakeFields.time: createdTime.toIso8601String(),
        MistakeFields.imgPath: imgPath,
      };

  //turns the map of the mistake into an actual instance of the mistake
  static Mistake fromJson(Map<String, Object?> json) => Mistake(
        id: json[MistakeFields.id] as int?,
        title: json[MistakeFields.title] as String,
        topic: json[MistakeFields.topic] as String,
        desc: json[MistakeFields.desc] as String,
        subject: json[MistakeFields.subject] as String,
        createdTime: DateTime.parse(json[MistakeFields.time] as String),
        imgPath: json[MistakeFields.imgPath] as String,
      );
}
