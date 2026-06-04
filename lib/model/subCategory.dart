class subCategories {
  int? id;
  int? categoryId;
  String? subcategory;
  String? subtitle;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;

  subCategories(
      {this.id,
        this.categoryId,
        this.subcategory,
        this.subtitle,
        this.image,
        this.status,
        this.createdAt,
        this.updatedAt});

  subCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    subcategory = json['subcategory'];
    subtitle = json['subtitle'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['subcategory'] = subcategory;
    data['subtitle'] = subtitle;
    data['image'] = image;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}