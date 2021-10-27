class Entry {
  final String entryOne;
  final String entryTwo;
  final String entryThree;
  final String title;
  final DateTime date;
  var rating;

  Entry(this.entryOne, this.entryTwo, this.entryThree, this.title, this.date,
      this.rating);

  Entry.fromJson(Map<dynamic, dynamic> json)
      : date = DateTime.parse(json['date'] as String),
        entryOne = json['entryOne'] as String,
        entryTwo = json['entryTwo'] as String,
        entryThree = json['entryThree'] as String,
        title = json['title'] as String,
        rating = json['rating'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'date': date.toString(),
        'entryOne': entryOne,
        'entryTwo': entryTwo,
        'entryThree': entryThree,
        'title': title,
        'rating': rating,
      };
}
