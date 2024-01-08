class VideoModel {
  final String title;
  final String description;
  final String fileUrl;
  final String thumbnailUrl;
  final String creatorUid;
  final String creator;
  final int likes;
  final int comments;
  final int createAt;

  VideoModel({
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.thumbnailUrl,
    required this.creatorUid,
    required this.likes,
    required this.comments,
    required this.createAt,
    required this.creator,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "fileUrl": fileUrl,
      "thumbnailUrl": thumbnailUrl,
      "creatorUid": creatorUid,
      "likes": likes,
      "comments": comments,
      "createdAt": createAt,
      "creator": creator,
    };
  }
}
