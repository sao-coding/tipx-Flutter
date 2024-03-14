import 'file.dart';
import 'publisher.dart';

class PostType {
  String? id;
  String? title;
  String? date;
  String? deadline;
  String? unit;
  Publisher? publisher;
  String? category;
  String? content;
  List<File>? file;
  String? link;

  PostType({
    this.id,
    this.title,
    this.date,
    this.deadline,
    this.unit,
    this.publisher,
    this.category,
    this.content,
    this.file,
    this.link,
  });

  factory PostType.fromJson(Map<String, dynamic> json) => PostType(
        id: json['id'] as String?,
        title: json['title'] as String?,
        date: json['date'] as String?,
        deadline: json['deadline'] as String?,
        unit: json['unit'] as String?,
        publisher: json['publisher'] == null
            ? null
            : Publisher.fromJson(json['publisher'] as Map<String, dynamic>),
        category: json['category'] as String?,
        content: json['content'] as String?,
        file: (json['file'] as List<dynamic>?)
            ?.map((e) => File.fromJson(e as Map<String, dynamic>))
            .toList(),
        link: json['link'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date,
        'deadline': deadline,
        'unit': unit,
        'publisher': publisher?.toJson(),
        'category': category,
        'content': content,
        'file': file?.map((e) => e.toJson()).toList(),
        'link': link,
      };
}
