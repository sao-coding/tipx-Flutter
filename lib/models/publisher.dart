class Publisher {
  String? name;
  String? email;

  Publisher({this.name, this.email});

  factory Publisher.fromJson(Map<String, dynamic> json) => Publisher(
        name: json['name'] as String?,
        email: json['email'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
      };
}
