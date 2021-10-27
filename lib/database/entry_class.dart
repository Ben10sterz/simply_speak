class Entry {
  final String entryOne;
  final String entryTwo;
  final String entryThree;
  final String title;
  final DateTime date;
  final String rating;

  Entry(this.date, this.title, this.rating, this.entryOne, this.entryTwo,
      this.entryThree);

  Entry.fromJson(Map<dynamic, dynamic> json)
      : date = DateTime.parse(json['date'] as String),
        title = json['title'] as String,
        rating = json['rating'] as String,
        entryOne = json['entryOne'] as String,
        entryTwo = json['entryTwo'] as String,
        entryThree = json['entryThree'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'date': date.toString(),
        'title': title,
        'rating': rating,
        'entryOne': entryOne,
        'entryTwo': entryTwo,
        'entryThree': entryThree,
      };
}
