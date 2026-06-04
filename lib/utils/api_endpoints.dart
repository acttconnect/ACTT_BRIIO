class ApiEndpoints {
  // Base URLs
  static const String baseUrl = 'https://briio.in/api/';
  static const String imageBaseUrl = 'https://briio.in/uploads/';

  // Endpoints
  static const String sliders = '${baseUrl}Sliders';
  static const String categories = '${baseUrl}Categorie';
  static const String subCategories = '${baseUrl}Subcategorie';
  static const String allProducts = '${baseUrl}AllProduct';
  
  static const String productBySubCategoryId = '${baseUrl}ProductBySubCategorieId';
  static const String subCategoryThree = '${baseUrl}get-sub-category-three';
  static const String subCategoryFour = '${baseUrl}get-sub-category-four';
  static const String productsBySubCategoryFour = '${baseUrl}get-products-by-sub-category-four';
  static const String productByBrandId = '${baseUrl}getProductByBrandId';
  static const String productByCategoryId = '${baseUrl}ProductByCategorieId';
  static const String productById = '${baseUrl}ProductById';
  static const String productByIdWithUserId = '${baseUrl}ProductByIdWithUserId';
  
  static const String homeData = '${baseUrl}HomeData';
  
  static const String getOrderData = '${baseUrl}getOrderData';
  static const String getOrderId = '${baseUrl}getOrderId';
  static const String placeOrder = '${baseUrl}submitOrderData';
  
  static const String addWishlist = '${baseUrl}addWishlist';
  static const String getWishlist = '${baseUrl}getWishlist';
  static const String deleteWishlist = '${baseUrl}deleteWishlist';
  
  static const String addCart = '${baseUrl}addCart';
  static const String getCart = '${baseUrl}getCart';
  static const String deleteCart = '${baseUrl}deleteCart';
  
  static const String notifications = '${baseUrl}get_notifications';
  
  static const String updateProfile = '${baseUrl}updateProfile';
}
