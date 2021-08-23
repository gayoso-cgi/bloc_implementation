class Pivot {
  int? contentId;
  int? tagsId;

  Pivot({this.contentId, this.tagsId});

  Pivot.fromJson(Map<String, dynamic> json) {
    contentId = json['content_id'];
    tagsId = json['tags_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content_id'] = this.contentId;
    data['tags_id'] = this.tagsId;
    return data;
  }
}
