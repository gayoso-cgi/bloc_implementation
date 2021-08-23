import 'thumbnail.dart';

class Meta {
  int? id;
  int? contentId;
  String? size;
  String? length;
  String? format;
  Thumbnail? thumbnail;
  String? createdAt;
  String? updatedAt;

  Meta(
      {this.id,
      this.contentId,
      this.size,
      this.length,
      this.format,
      this.thumbnail,
      this.createdAt,
      this.updatedAt});

  Meta.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contentId = json['content_id'];
    size = json['size'];
    length = json['length'];
    format = json['format'];
    thumbnail = json['thumbnail'] != null
        ? new Thumbnail.fromJson(json['thumbnail'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content_id'] = this.contentId;
    data['size'] = this.size;
    data['length'] = this.length;
    data['format'] = this.format;
    if (this.thumbnail != null) {
      data['thumbnail'] = this.thumbnail!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
