class Outcome {
  final String id;
  final String title;
  final List<Outcome> outcomes;

  Outcome({
    required this.id,
    required this.title,
    required this.outcomes,
  });

  factory Outcome.fromJson(Map<String, dynamic> json) {
    var outcomesList = json['outcomes'] as List<dynamic>;
    List<Outcome> outcomes = outcomesList.map((outcomeJson) {
      return Outcome.fromJson(outcomeJson);
    }).toList();

    return Outcome(
      id: json['id'],
      title: json['title'],
      outcomes: outcomes,
    );
  }
}
