class MainCategoryModel {
  bool? error;
  List<MainCategory>? data;

  MainCategoryModel({this.error, this.data});

  MainCategoryModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['data'] != null) {
      data = <MainCategory>[];
      json['data'].forEach((v) {
        data!.add(MainCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MainCategory {
  int? id;
  String? name;
  String? subHeading;
  String? image;
  String? bgimage;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? authId;

  MainCategory(
      {this.id,
      this.name,
      this.subHeading,
      this.image,
      this.bgimage,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.authId});

  MainCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    subHeading = json['sub_heading'];
    image = json['image'];
    bgimage = json['bgimage'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    authId = json['auth_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['sub_heading'] = subHeading;
    data['image'] = image;
    data['bgimage'] = bgimage;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['auth_id'] = authId;
    return data;
  }
}
