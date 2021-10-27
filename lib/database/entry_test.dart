class EntryTest {
  final String text;
  final DateTime date;

  EntryTest(this.text, this.date);

  EntryTest.fromJson(Map<dynamic, dynamic> json)
      : date = DateTime.parse(json['date'] as String),
        text = json['text'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'date': date.toString(),
        'text': text,
      };
}
