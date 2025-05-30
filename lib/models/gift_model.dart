class Gift {
  final int id;
  final String name;
  final String description;

  Gift({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      id: json['Id'],
      name: json['Name'],
      description: json['Description'],
    );
  }
}
