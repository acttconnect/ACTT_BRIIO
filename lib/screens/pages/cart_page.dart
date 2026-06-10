// ignore_for_file: deprecated_member_use

import 'package:briio_application/screens/pages/savedaddress.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../classes/add_cart.dart';
import '../../model/get_new_cart_model.dart';
import '../../utils/const.dart';
import '../../utils/globel_veriable.dart';
import '../../widgets/big_text.dart';
import '../home/product_detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<GetNewCartModel>? _cartFuture;

  @override
  void initState() {
    super.initState();
    _refreshCart();
  }

  void _refreshCart() {
    setState(() {
      _cartFuture = AddCard.getCard().catchError((error) {
        print('Cart Error: $error'); // For debugging
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading cart: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        throw error; // Rethrow to be caught by FutureBuilder
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'CART',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<GetNewCartModel>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: _refreshCart,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data?.data == null) {
            return const Center(child: Text('No data available'));
          }

          final cartData = snapshot.data!.data;
          
          if (cartData!.isEmpty) {
            return Center(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.asset(
                        'assets/empty_cart-removebg-preview.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'Your cart is empty !',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: Colors.grey.shade800),
                    )
                  ],
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                child: InkWell(
                  onTap: () { Fluttertoast.showToast(msg: "Filter button clicked");
                    // Soft code - Filter action (no API for this yet)
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.filter_list, size: 18, color: Colors.grey.shade800),
                        const SizedBox(width: 8),
                        Text(
                          'Filter',
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cartData.length,
                  itemBuilder: (context, index) => buildCart(snapshot, index),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _addCartText({String? hintText, String? valueText}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 85, // Fixed width for labels
            child: BigText(
              text: '$hintText',
              size: 13,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: BigText(
              text: '$valueText',
              size: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Card buildCart(AsyncSnapshot<GetNewCartModel> snapshot, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () { Fluttertoast.showToast(msg: "Filter button clicked");
                  setState(() {
                    GlobalK.productId = snapshot.data!.data![index].products!.id.toString();
                    GlobalK.productName = snapshot.data!.data![index].products!.name.toString();
                  });
                  Get.to(() => ProductDetailsPage(
                    productId: snapshot.data!.data![index].products!.id!,
                  ));
                },
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: '${imgPath}products/${snapshot.data!.data![index].products!.image!.toString()}',
                      fit: BoxFit.contain,
                      memCacheWidth: 300,
                      memCacheHeight: 300,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4,top: 10),
                    child: Text(
                      snapshot.data!.data![index].products!.name!.toString(),
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  _addCartText(
                    hintText: 'Category : ',
                    valueText: snapshot.data!.data![index].products!.catName.toString(),
                  ),
                  if (snapshot.data!.data![index].bangleSize?.isNotEmpty == true)
                    _addCartText(
                      hintText: 'Bangle Size : ',
                      valueText: snapshot.data!.data![index].bangleSize.toString(),
                    ),
                  if (snapshot.data!.data![index].goldPurity?.isNotEmpty == true)
                    _addCartText(
                      hintText: 'Gold Purity : ',
                      valueText: snapshot.data!.data![index].goldPurity.toString(),
                    ),
                  _addCartText(
                    hintText: 'Net Wt. : ',
                    valueText: snapshot.data!.data![index].products!.nw.toString(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 32,
                          child: TextButton(
                            onPressed: () async {
                              try {
                                final productId = snapshot.data!.data![index].productid;
                                final quantity = snapshot.data!.data![index].quantity;
                                
                                if (productId == null || quantity == null) {
                                  throw Exception('Invalid product data');
                                }

                                await AddCard.getDeleteCard(
                                  product_id: productId.toString(),
                                  quantity: quantity.toString(),
                                );
                                
                                _refreshCart();
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Item removed from cart'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error removing item: ${e.toString()}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 0),
                            ),
                            child: const Text(
                              'REMOVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 32,
                          child: TextButton(
                            onPressed: () {
                              try {
                                final productId = snapshot.data!.data![index].productid;
                                final cartId = snapshot.data!.data![index].id;
                                final goldPurity = snapshot.data!.data![index].goldPurity ?? '';
                                final bangleSize = snapshot.data!.data![index].bangleSize ?? '';
                                final weight = snapshot.data!.data![index].products?.nw ?? '';

                                if (productId == null || cartId == null) {
                                  throw Exception('Invalid product data');
                                }

                                final parsedProductId = int.tryParse(productId);
                                if (parsedProductId == null) {
                                  throw Exception('Invalid product ID format');
                                }

                                Get.to(() => SavedAddress(
                                  forOrder: true,
                                  instruction: '',
                                  isCartOrder: true,
                                  productId: parsedProductId,
                                  cartId: cartId.toInt(),
                                  goldPurity: goldPurity,
                                  bangleSize: bangleSize,
                                  weight: weight.toString(),
                                ));
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: ${e.toString()}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 0),
                            ),
                            child: const Text(
                              'ORDER',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
