import 'high.dart';

class Thumbnail {
  High? high;
  High? maxres;
  High? medium;
  High? defaults;
  High? standard;

  Thumbnail(
      {this.high, this.maxres, this.medium, this.defaults, this.standard});

  Thumbnail.fromJson(Map<String, dynamic> json) {
    high = json['high'] != null ? new High.fromJson(json['high']) : null;
    maxres = json['maxres'] != null ? new High.fromJson(json['maxres']) : null;
    medium = json['medium'] != null ? new High.fromJson(json['medium']) : null;
    defaults =
        json['default'] != null ? new High.fromJson(json['default']) : null;
    standard =
        json['standard'] != null ? new High.fromJson(json['standard']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.high != null) {
      data['high'] = this.high!.toJson();
    }
    if (this.maxres != null) {
      data['maxres'] = this.maxres!.toJson();
    }
    if (this.medium != null) {
      data['medium'] = this.medium!.toJson();
    }
    if (this.defaults != null) {
      data['default'] = this.defaults!.toJson();
    }
    if (this.standard != null) {
      data['standard'] = this.standard!.toJson();
    }
    return data;
  }
}
