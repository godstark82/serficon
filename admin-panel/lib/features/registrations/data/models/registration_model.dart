class RegistrationModel {
  final String email;
  final String name;
  final String affiliation;
  final String category;
  final String days;
  final String presentingPaper;
  final String country;
  final String registrationDate;

  RegistrationModel({
    required this.email,
    required this.name,
    required this.affiliation,
    required this.category,
    required this.days,
    required this.presentingPaper,
    required this.country,
    required this.registrationDate,
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    return RegistrationModel(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      affiliation: json['affiliation'] ?? '',
      category: json['category'] ?? '',
      days: json['days'] ?? '',
      presentingPaper: json['presenting_paper'] ?? '',
      country: json['country'] ?? '',
      registrationDate: json['registration_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'affiliation': affiliation,
      'category': category,
      'days': days,
      'presentingPaper': presentingPaper,
      'country': country,
      'registrationDate': registrationDate,
    };
  }
}
