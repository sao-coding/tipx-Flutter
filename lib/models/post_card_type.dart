class PostCardType {
  String? id;
  String? title;
  bool? sticky;
  String? category;
  String? unit;
  String? date;
  String? deadline;

  PostCardType({
    this.id,
    this.title,
    this.sticky,
    this.category,
    this.unit,
    this.date,
    this.deadline,
  });

  factory PostCardType.fromJson(Map<String, dynamic> json) => PostCardType(
        id: json['id'] as String?,
        title: json['title'] as String?,
        sticky: json['sticky'] as bool?,
        category: json['category'] as String?,
        unit: json['unit'] as String?,
        date: json['date'] as String?,
        deadline: json['deadline'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'sticky': sticky,
        'category': category,
        'unit': unit,
        'date': date,
        'deadline': deadline,
      };
}
