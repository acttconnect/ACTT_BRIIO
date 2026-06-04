import '../utils/const.dart';

class BackImage {
  int? id;
  String? name;
  String? subtitle;
  String? image;
  String? bgImage;
  int? status;
  String? createdAt;
  String? updatedAt;

  BackImage(
      {this.id,
        this.name,
        this.subtitle,
        this.image,
        this.bgImage,
        this.status,
        this.createdAt,
        this.updatedAt});

  BackImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    subtitle = json['subtitle'];
    image = json['image'];
    bgImage = "${imgPath}homesliders/${json['bgimage']}";
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['subtitle'] = subtitle;
    data['image'] = image;
    data['bgimage'] = bgImage;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}