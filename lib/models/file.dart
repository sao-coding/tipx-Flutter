class File {
  String? title;
  String? link;

  File({this.title, this.link});

  factory File.fromJson(Map<String, dynamic> json) => File(
        title: json['title'] as String?,
        link: json['link'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'link': link,
      };
}
