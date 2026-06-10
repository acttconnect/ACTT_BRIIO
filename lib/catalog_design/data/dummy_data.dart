import '../models/product_model.dart';

final List<Map<String, dynamic>> dummyCatalogJson = [
  {
    'id': '1',
    'code': 'BGKOLHR00030',
    'description': 'Crafted with precision, this gold bangle reflects Kolkata\'s rich heritage, offering a perfect blend of elegance and tradition.',
    'weight': 'WT-48GM',
    'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Diamond_Ring.jpg/640px-Diamond_Ring.jpg',
  },
  {
    'id': '2',
    'code': 'BGKOLHR00030',
    'description': 'Crafted with precision, this gold bangle reflects Kolkata\'s rich heritage, offering a perfect blend of elegance and tradition.',
    'weight': 'WT-48GM',
    'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Diamond_Ring.jpg/640px-Diamond_Ring.jpg',
  },
  {
    'id': '3',
    'code': 'BGKOLHR00030',
    'description': 'Crafted with precision, this gold bangle reflects Kolkata\'s rich heritage, offering a perfect blend of elegance and tradition.',
    'weight': 'WT-48GM',
    'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Diamond_Ring.jpg/640px-Diamond_Ring.jpg',
  },
  {
    'id': '4',
    'code': 'BGKOLHR00030',
    'description': 'Crafted with precision, this gold bangle reflects Kolkata\'s rich heritage, offering a perfect blend of elegance and tradition.',
    'weight': 'WT-48GM',
    'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Diamond_Ring.jpg/640px-Diamond_Ring.jpg',
  },
];

final List<CatalogProduct> dummyProducts = 
    dummyCatalogJson.map((json) => CatalogProduct.fromJson(json)).toList();
