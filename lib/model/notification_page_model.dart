class NotificationModel {
  final String heading;
  final String content;
  final String imageUrl;

  NotificationModel({required this.heading, required this.content, required this.imageUrl});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      heading: json['headings']?['en'] ?? 'No Title',
      content: json['contents']?['en'] ?? 'No Content',
      imageUrl: json['global_image'] ?? '',
    );
  }
}
