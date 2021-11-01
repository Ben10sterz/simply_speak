class Entry {
  final String entryOne;
  final String entryTwo;
  final String entryThree;
  final String title;
  final String date;
  final String rating;

  Entry(this.date, this.rating, this.title, this.entryOne, this.entryTwo,
      this.entryThree);

  Entry.fromJson(Map<dynamic, dynamic> json)
      : date = json['date'] as String,
        rating = json['rating'] as String,
        title = json['title'] as String,
        entryOne = json['entryOne'] as String,
        entryTwo = json['entryTwo'] as String,
        entryThree = json['entryThree'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'date': date.toString(),
        'rating': rating,
        'title': title,
        'entryOne': entryOne,
        'entryTwo': entryTwo,
        'entryThree': entryThree,
      };
}
