var counter = 0;
class Mistake {
  String title, topic, desc, subject;
  int id = counter;
  static List<Mistake> mistakeList = [];

  Mistake(this.title, this.topic, this.desc, this.subject) {
    counter+=1;
    mistakeList.add(this);
  }
}

//needs a class for the url of pictures for both:
//the problem and solution
