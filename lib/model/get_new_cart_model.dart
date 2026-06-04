/// error : false
/// data : [{"id":77,"userid":"1","productid":"6","price":"157.00","productvariationid":6,"quantity":"1","created_at":"2022-07-09T12:25:06.000000Z","updated_at":"2022-07-09T12:25:06.000000Z","products":{"id":6,"name":"chain","category_id":4,"subcategory_id":6,"image":"22-07-01-146440821.jpg","brand_id":2,"other_image":"[\"22-07-01-165665927973.png\"]","description":"<span style=\"color: rgb(77, 81, 86); font-family: arial, sans-serif; font-size: 14px;\">These are charm carrier&nbsp;</span><span style=\"font-weight: bold; color: rgb(95, 99, 104); font-family: arial, sans-serif; font-size: 14px;\">bracelets</span><span style=\"color: rgb(77, 81, 86); font-family: arial, sans-serif; font-size: 14px;\">&nbsp;with 8&nbsp;</span><span style=\"font-weight: bold; color: rgb(95, 99, 104); font-family: arial, sans-serif; font-size: 14px;\">slider</span><span style=\"color: rgb(77, 81, 86); font-family: arial, sans-serif; font-size: 14px;\">&nbsp;beads. This gives you the means to create your own story. You can add as many charms as you want or even&nbsp;...</span>","short_desc":"good product","status":1,"product_code":"product-2","gw":2,"stone":5,"nw":3,"caret":null,"created_at":"2022-07-01T07:07:59.000000Z","updated_at":"2022-07-01T07:07:59.000000Z"}},{"id":78,"userid":"1","productid":"6","price":"157.00","productvariationid":6,"quantity":"1","created_at":"2022-07-09T15:51:08.000000Z","updated_at":"2022-07-09T15:51:08.000000Z","products":{"id":6,"name":"chain","category_id":4,"subcategory_id":6,"image":"22-07-01-146440821.jpg","brand_id":2,"other_image":"[\"22-07-01-165665927973.png\"]","description":"<span style=\"color: rgb(77, 81, 86); font-family: arial, sans-serif; font-size: 14px;\">These are charm carrier&nbsp;</span><span style=\"font-weight: bold; color: rgb(95, 99, 104); font-family: arial, sans-serif; font-size: 14px;\">bracelets</span><span style=\"color: rgb(77, 81, 86); font-family: arial, sans-serif; font-size: 14px;\">&nbsp;with 8&nbsp;</span><span style=\"font-weight: bold; color: rgb(95, 99, 104); font-family: arial, sans-serif; font-size: 14px;\">slider</span><span style=\"color: rgb(77, 81, 86); font-family: arial, sans-serif; font-size: 14px;\">&nbsp;beads. This gives you the means to create your own story. You can add as many charms as you want or even&nbsp;...</span>","short_desc":"good product","status":1,"product_code":"product-2","gw":2,"stone":5,"nw":3,"caret":null,"created_at":"2022-07-01T07:07:59.000000Z","updated_at":"2022-07-01T07:07:59.000000Z"}},{"id":79,"userid":"1","productid":"6","price":"157.00","productvariationid":6,"quantity":"1","created_at":"2022-07-09T15:51:19.000000Z","updated_at":"2022-07-09T15:51:19.000000Z","products":{"id":6,"name":"chain","category_id":4,"subcategory_id":6,"image":"22-07-01-146440821.jpg","brand_id":2,"other_image":"[\"22-07-01-165665927973.png\"]","description":"<span style=\"color: rgb(77, 81, 86); font-family: arial, sans-serif; font-size: 14px;\">These are charm carrier&nbsp;</span><span style=\"font-weight: bold; color: rgb(95, 99, 104); font-family: arial, sans-serif; font-size: 14px;\">bracelets</span><span style=\"color: rgb(77, 81, 86); font-family: arial, sans-serif; font-size: 14px;\">&nbsp;with 8&nbsp;</span><span style=\"font-weight: bold; color: rgb(95, 99, 104); font-family: arial, sans-serif; font-size: 14px;\">slider</span><span style=\"color: rgb(77, 81, 86); font-family: arial, sans-serif; font-size: 14px;\">&nbsp;beads. This gives you the means to create your own story. You can add as many charms as you want or even&nbsp;...</span>","short_desc":"good product","status":1,"product_code":"product-2","gw":2,"stone":5,"nw":3,"caret":null,"created_at":"2022-07-01T07:07:59.000000Z","updated_at":"2022-07-01T07:07:59.000000Z"}},{"id":80,"userid":"1","productid":"6","price":"157.00","productvariationid":6,"quantity":"1","created_at":"2022-07-09T15:51:32.000000Z","updated_at":"2022-07-09T15:51:32.000000Z","products":{"id":6,"name":"chain","category_id":4,"subcategory_id":6,"image":"22-07-01-146440821.jpg","brand_id":2,"other_image":"[\"22-07-01-165665927973.png\"]","description":"<span style=\"color: rgb(77, 81, 86); font-family: arial, sans-serif; font-size: 14px;\">These are charm carrier&nbsp;</span><span style=\"font-weight: bold; color: rgb(95, 99, 104); font-family: arial, sans-serif; font-size: 14px;\">bracelets</span><span style=\"color: rgb(77, 81, 86); font-family: arial, sans-serif; font-size: 14px;\">&nbsp;with 8&nbsp;</span><span style=\"font-weight: bold; color: rgb(95, 99, 104); font-family: arial, sans-serif; font-size: 14px;\">slider</span><span style=\"color: rgb(77, 81, 86); font-family: arial, sans-serif; font-size: 14px;\">&nbsp;beads. This gives you the means to create your own story. You can add as many charms as you want or even&nbsp;...</span>","short_desc":"good product","status":1,"product_code":"product-2","gw":2,"stone":5,"nw":3,"caret":null,"created_at":"2022-07-01T07:07:59.000000Z","updated_at":"2022-07-01T07:07:59.000000Z"}}]
/// message : "Cart data get successfully."
library;

class GetNewCartModel {
  List<CartItem>? data;

  GetNewCartModel({this.data});

  factory GetNewCartModel.fromJson(Map<String, dynamic> json) {
    try {
      return GetNewCartModel(
        data: json['data'] != null 
            ? List<CartItem>.from(json['data'].map((x) => CartItem.fromJson(x)))
            : null,
      );
    } catch (e) {
      print('Error parsing GetNewCartModel: $e');
      throw Exception('Failed to parse cart data: $e');
    }
  }
}

class CartItem {
  int? id;
  String? productid;
  String? quantity;
  String? goldPurity;
  String? bangleSize;
  Products? products;

  CartItem({
    this.id,
    this.productid,
    this.quantity,
    this.goldPurity,
    this.bangleSize,
    this.products,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      productid: json['productid']?.toString(),
      quantity: json['quantity']?.toString(),
      goldPurity: json['gold_purity']?.toString(),
      bangleSize: json['bangle_size']?.toString(),
      products: json['products'] != null ? Products.fromJson(json['products']) : null,
    );
  }
}

/// id : 77
/// userid : "1"
/// productid : "6"
/// price : "157.00"
/// productvariationid : 6
/// quantity : "1"
/// created_at : "2022-07-09T12:25:06.000000Z"
/// updated_at : "2022-07-09T12:25:06.000000Z"
/// products : {"id":6,"name":"chain","category_id":4,"subcategory_id":6,"image":"22-07-01-146440821.jpg","brand_id":2,"other_image":"[\"22-07-01-165665927973.png\"]","description":"<span style=\"color: rgb(77, 81, 86); font-family: arial, sans-serif; font-size: 14px;\">These are charm carrier&nbsp;</span><span style=\"font-weight: bold; color: rgb(95, 99, 104); font-family: arial, sans-serif; font-size: 14px;\">bracelets</span><span style=\"color: rgb(77, 81, 86); font-family: arial, sans-serif; font-size: 14px;\">&nbsp;with 8&nbsp;</span><span style=\"font-weight: bold; color: rgb(95, 99, 104); font-family: arial, sans-serif; font-size: 14px;\">slider</span><span style=\"color: rgb(77, 81, 86); font-family: arial, sans-serif; font-size: 14px;\">&nbsp;beads. This gives you the means to create your own story. You can add as many charms as you want or even&nbsp;...</span>","short_desc":"good product","status":1,"product_code":"product-2","gw":2,"stone":5,"nw":3,"caret":null,"created_at":"2022-07-01T07:07:59.000000Z","updated_at":"2022-07-01T07:07:59.000000Z"}

class Products {
  Products({
    int? id,
    String? name,
    int? categoryId,
    int? subcategoryId,
    String? image,
    int? brandId,
    String? otherImage,
    String? description,
    String? shortDesc,
    int? status,
    String? productCode,
    int? gw,
    int? stone,
    int? nw,
    dynamic caret,
    String? createdAt,
    String? updatedAt,
    String? catName,
    String? bangleSize,
    String? goldPurity,
  }) {
    _id = id;
    _name = name;
    _categoryId = categoryId;
    _subcategoryId = subcategoryId;
    _image = image;
    _brandId = brandId;
    _otherImage = otherImage;
    _description = description;
    _shortDesc = shortDesc;
    _status = status;
    _productCode = productCode;
    _gw = gw;
    _stone = stone;
    _nw = nw;
    _caret = caret;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _catName = catName;
    _bangleSize = bangleSize;
    _goldPurity = goldPurity;
  }

  Products.fromJson(dynamic json) {
    _id = json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0;
    _name = json['name']?.toString() ?? '';
    _categoryId = json['category_id'] is int ? json['category_id'] : int.tryParse(json['category_id'].toString()) ?? 0;
    _subcategoryId = json['subcategory_id'] is int ? json['subcategory_id'] : int.tryParse(json['subcategory_id'].toString()) ?? 0;
    _image = json['image']?.toString() ?? '';
    _brandId = json['brand_id'] is int ? json['brand_id'] : int.tryParse(json['brand_id'].toString()) ?? 0;
    _otherImage = json['other_image']?.toString() ?? '';
    _description = json['description']?.toString() ?? '';
    _shortDesc = json['short_desc']?.toString() ?? '';
    _status = json['status'] is int ? json['status'] : int.tryParse(json['status'].toString()) ?? 0;
    _productCode = json['product_code']?.toString() ?? '';
    _gw = json['gw'] is int ? json['gw'] : int.tryParse(json['gw'].toString()) ?? 0;
    _stone = json['stone'] is int ? json['stone'] : int.tryParse(json['stone'].toString()) ?? 0;
    _nw = json['nw'] is int ? json['nw'] : int.tryParse(json['nw'].toString()) ?? 0;
    _caret = json['caret'];
    _createdAt = json['created_at']?.toString() ?? '';
    _updatedAt = json['updated_at']?.toString() ?? '';
    _catName = json['cat_name']?.toString() ?? '';
    _bangleSize = json['bangle_size'] ?? '';
    _goldPurity = json['gold_purity'] ?? '';
  }

  int? _id;
  String? _name;
  int? _categoryId;
  int? _subcategoryId;
  String? _image;
  int? _brandId;
  String? _otherImage;
  String? _description;
  String? _shortDesc;
  int? _status;
  String? _productCode;
  int? _gw;
  int? _stone;
  int? _nw;
  dynamic _caret;
  String? _createdAt;
  String? _updatedAt;
  String? _catName;
  String? _bangleSize;
  String? _goldPurity;

  Products copyWith({
    int? id,
    String? name,
    int? categoryId,
    int? subcategoryId,
    String? image,
    int? brandId,
    String? otherImage,
    String? description,
    String? shortDesc,
    int? status,
    String? productCode,
    int? gw,
    int? stone,
    int? nw,
    dynamic caret,
    String? createdAt,
    String? updatedAt,
    String? catName,
    String? bangleSize,
    String? goldPurity,
  }) =>
      Products(
        id: id ?? _id,
        name: name ?? _name,
        categoryId: categoryId ?? _categoryId,
        subcategoryId: subcategoryId ?? _subcategoryId,
        image: image ?? _image,
        brandId: brandId ?? _brandId,
        otherImage: otherImage ?? _otherImage,
        description: description ?? _description,
        shortDesc: shortDesc ?? _shortDesc,
        status: status ?? _status,
        productCode: productCode ?? _productCode,
        gw: gw ?? _gw,
        stone: stone ?? _stone,
        nw: nw ?? _nw,
        caret: caret ?? _caret,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        catName: catName ?? _catName,
        bangleSize: bangleSize ?? _bangleSize,
        goldPurity: goldPurity ?? _goldPurity,
      );

  int? get id => _id;

  String? get name => _name;

  int? get categoryId => _categoryId;

  int? get subcategoryId => _subcategoryId;

  String? get image => _image;

  int? get brandId => _brandId;

  String? get otherImage => _otherImage;

  String? get description => _description;

  String? get shortDesc => _shortDesc;

  int? get status => _status;

  String? get productCode => _productCode;

  int? get gw => _gw;

  int? get stone => _stone;

  int? get nw => _nw;

  dynamic get caret => _caret;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get catName => _catName;

  String? get bangleSize => _bangleSize;

  String? get goldPurity => _goldPurity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['category_id'] = _categoryId;
    map['subcategory_id'] = _subcategoryId;
    map['image'] = _image;
    map['brand_id'] = _brandId;
    map['other_image'] = _otherImage;
    map['description'] = _description;
    map['short_desc'] = _shortDesc;
    map['status'] = _status;
    map['product_code'] = _productCode;
    map['gw'] = _gw;
    map['stone'] = _stone;
    map['nw'] = _nw;
    map['caret'] = _caret;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['cat_name'] = _catName;
    map['bangle_size'] = _bangleSize;
    map['gold_purity'] = _goldPurity;
    return map;
  }
}
