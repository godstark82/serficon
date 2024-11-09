class CardModel {
  final String? id;
  final String? image;
  final String title;
  final String description;

  CardModel(
      {this.id,
      required this.image,
      required this.title,
      required this.description});

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
        id: json['id'] ?? 'No ID',
        image: json['image'] ?? 'No Image',
        title: json['title'] ?? 'No Title',
        description: json['description'] ?? 'No Description',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'title': title,
        'description': description,
      };

  CardModel copyWith({
    String? id,
    String? image,
    String? title,
    String? description,
  }) =>
      CardModel(
          id: id ?? this.id,
          image: image ?? this.image,
          title: title ?? this.title,
          description: description ?? this.description);
}
