class NewsModel {
  String id;
  String title;
  String content;
  String? imageUrl;
  String? link;
  String? qrCode;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    this.link,
    this.qrCode,
  });

  factory NewsModel.fromMap(Map<String, dynamic> data, String id) {
    return NewsModel(
      id: id,
      title: data['title'],
      content: data['content'],
      imageUrl: data['image_url'],
      link: data['link'],
      qrCode: data['qr_code'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'link': link,
      'qr_code': qrCode,
    };
  }
}
