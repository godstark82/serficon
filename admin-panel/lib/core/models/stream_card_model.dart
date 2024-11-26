class StreamCardModel {
  String? title;
  List<String>? descriptions;

  StreamCardModel({this.title, this.descriptions});

  factory StreamCardModel.fromJson(Map<String, dynamic> json) =>
      StreamCardModel(
        title: json['title'],
        descriptions: List<String>.from(json['descriptions'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'descriptions': descriptions?.map((x) => x.toString()).toList(),
      };

  StreamCardModel copyWith({
    String? title,
    List<String>? descriptions, 
    
  }) =>
      StreamCardModel(
          title: title ?? this.title,
          descriptions: descriptions ?? this.descriptions);
}
