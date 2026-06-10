import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../model/address_model.dart';
import '../../utils/cart_order.dart';
import '../../utils/const.dart';
import '../../utils/globel_veriable.dart';
import '../../utils/payment_service.dart';

class SavedAddress extends StatefulWidget {
  final bool forOrder;
  final bool? isCartOrder;
  final int? productId;
  final int? cartId;
  final String? goldPurity;
  final String? bangleSize;
  final String? weight;
  final String instruction;
  final double amount;

  const SavedAddress(
      {super.key,
      required this.forOrder,
      this.productId,
      this.goldPurity,
      this.bangleSize,
      this.weight,
      this.isCartOrder,
      this.cartId,
      this.amount = 0.0,
      required this.instruction});

  @override
  State<SavedAddress> createState() => _SavedAddressState();
}

class _SavedAddressState extends State<SavedAddress> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final landmark = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final pin = TextEditingController();
  final addKey = GlobalKey<FormState>();
  final c = Get.put(MyController());
  late PaymentService _paymentService;
  
  // To hold temporary order data during payment
  int? _pendingAddressId;
  int? _pendingProductId;
  String? _pendingGoldPurity;
  String? _pendingBangleSize;
  String? _pendingWeight;
  String? _pendingInstruction;

  @override
  void initState() {
    super.initState();
    _paymentService = PaymentService(
      onSuccess: (response) {
        _processOrder(paymentId: response.paymentId ?? "");
      },
      onFailure: (errorMessage) {
        c.isCartLoading.value = false;
      },
    );
  }

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }

  void _processOrder({required String paymentId}) {
    if (_pendingAddressId == null) return;
    
    if (widget.isCartOrder ?? false) {
      CartOrder.placeOrder(
        productId: _pendingProductId ?? 0,
        addressId: _pendingAddressId!.toString(),
        goldPurity: _pendingGoldPurity ?? '22K',
        bangleSize: _pendingBangleSize ?? 'Standard',
        weight: _pendingWeight ?? '0',
        instruction: _pendingInstruction ?? '',
        totalAmount: widget.amount,
        paymentMethod: 'Razorpay',
        paymentId: paymentId,
      );
    } else {
      submitOrder(
        bangleSize: _pendingBangleSize!,
        weight: _pendingWeight!,
        goldPurity: _pendingGoldPurity!,
        addressId: _pendingAddressId!,
        productId: _pendingProductId!,
        instruction: _pendingInstruction ?? '',
        totalAmount: widget.amount,
        paymentMethod: 'Razorpay',
        paymentId: paymentId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.grey[800]),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          widget.forOrder ? 'SELECT ADDRESS' : 'SAVED ADDRESS',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ),
      body: Obx(
        () => c.isCartLoading.value
            ? const Center(child: CircularProgressIndicator())
            : FutureBuilder<AddressModel>(
                future: showAddress(),
                builder: (context, snapshot) => snapshot.hasData
                    ? snapshot.data!.data!.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_off_outlined, 
                                     size: 64, 
                                     color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  widget.forOrder
                                      ? 'Please add address to proceed further'
                                      : 'No addresses saved yet',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(12),
                            child: ListView.builder(
                              itemCount: snapshot.data!.data!.length,
                              itemBuilder: (context, index) => widget.forOrder
                                  ? buildAddressCard1(snapshot, index)
                                  : buildAddressCard(snapshot, index),
                            ),
                          )
                    : const Center(child: CircularProgressIndicator()),
              ),
      ),
      floatingActionButton: widget.forOrder
          ? null
          : FloatingActionButton.extended(
              backgroundColor: Colors.black87,
              elevation: 2,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                'Add Address',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () => addAddressDialog(),
            ),
    );
  }

  addAddressDialog() {
    name.clear();
    phone.clear();
    address.clear();
    landmark.clear();
    city.clear();
    state.clear();
    pin.clear();
    return Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(Get.context!).size.height * 0.8,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: addKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add New Address',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.close, color: Colors.grey[600]),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          modernTextField(
                            controller: name,
                            hintText: 'Full Name',
                            iconData: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),
                          modernTextField(
                            controller: phone,
                            hintText: 'Mobile Number',
                            iconData: Icons.phone_outlined,
                            isNumeric: true,
                          ),
                          const SizedBox(height: 16),
                          modernTextField(
                            controller: address,
                            hintText: 'Address',
                            iconData: Icons.home_outlined,
                          ),
                          const SizedBox(height: 16),
                          modernTextField(
                            controller: landmark,
                            hintText: 'Landmark',
                            iconData: Icons.location_on_outlined,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: modernTextField(
                                  controller: city,
                                  hintText: 'City',
                                  iconData: Icons.location_city_outlined,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: modernTextField(
                                  controller: pin,
                                  hintText: 'PIN Code',
                                  iconData: Icons.pin_drop_outlined,
                                  isNumeric: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          modernTextField(
                            controller: state,
                            hintText: 'State',
                            iconData: Icons.map_outlined,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                final isValid = addKey.currentState!.validate();
                                if (isValid) {
                                  saveAddressFromApi(
                                    id: GlobalK.userId!.toInt(),
                                    name: name.text,
                                    mobile: phone.text,
                                    address: address.text,
                                    landmark: landmark.text,
                                    city: city.text,
                                    state: state.text,
                                    pincode: pin.text,
                                  ).then((value) => setState(() {}));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'SAVE ADDRESS',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Widget modernTextField({
    required TextEditingController controller,
    required String hintText,
    bool? isNumeric,
    required IconData iconData,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ?? false ? TextInputType.number : TextInputType.text,
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey[500],
          fontSize: 14,
        ),
        prefixIcon: Icon(iconData, size: 20, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black87, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red[400]!, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red[400]!, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (value) => value!.isEmpty ? 'This field is required' : null,
    );
  }

  Widget buildAddressCard(AsyncSnapshot<AddressModel> snapshot, int index) {
    final item = snapshot.data!.data![index];
    return Card(
      color: Colors.white,
      elevation: 0.5,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 20),
                const SizedBox(width: 8),
                Text(
                  item.cname!,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${item.landmark!}, ${item.city}',
              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
            ),
            Text(
              '${item.state!}, India',
              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
            ),
            Text(
              item.pincode!.toString(),
              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone_outlined, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  item.mobile!,
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
              ],
            ),
            const Divider(height: 24),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red[400],
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Icon(Icons.delete_outline, size: 20),
              label: const Text('Delete Address'),
              onPressed: () => deleteAddress(item.id!.toInt())
                  .then((value) => setState(() {})),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAddressCard1(AsyncSnapshot<AddressModel> snapshot, int index) {
    final item = snapshot.data!.data![index];
    return Card(
      color: Colors.white,
      elevation: 0.5,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          _pendingAddressId = item.id!.toInt();
          _pendingProductId = widget.productId;
          _pendingGoldPurity = widget.goldPurity;
          _pendingBangleSize = widget.bangleSize;
          _pendingWeight = widget.weight;
          _pendingInstruction = widget.instruction;

          c.isCartLoading.value = true;
          
          try {
            var orderResponse = await http.post(
              Uri.parse('${apiUrl}getOrderId'),
              headers: {'Accept': 'application/json'},
            );
            
            if (orderResponse.statusCode == 200 || orderResponse.statusCode == 201) {
              var orderData = jsonDecode(orderResponse.body);
              String? razorpayKey = orderData['order']?['razorpayId'];
              
              _paymentService.openCheckout(
                amount: widget.amount > 0 ? widget.amount : 1.0,
                contact: item.mobile ?? GlobalK.phone ?? '',
                email: GlobalK.userEmail ?? GlobalK.mail ?? '',
                orderName: 'Jewelry Order',
                description: 'Payment for your order',
                key: razorpayKey,
              );
            } else {
              Fluttertoast.showToast(msg: 'Failed to initiate payment');
            }
          } catch (e) {
            Fluttertoast.showToast(msg: 'Error: $e');
          } finally {
            c.isCartLoading.value = false;
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    item.cname!,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${item.landmark!}, ${item.city}',
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
              Text(
                '${item.state!}, India',
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
              Text(
                item.pincode!.toString(),
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.phone_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    item.mobile!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitOrder(
      {required String bangleSize,
      required String weight,
      required String goldPurity,
      required int addressId,
      required int productId,
      required String instruction,
      required double totalAmount,
      String paymentMethod = 'COD',
      String paymentId = '0'}) async {
    final url = '${apiUrl}submitOrderData';
    c.isCartLoading.value = true;
    
    final payload = {
      "user_id": GlobalK.userId,
      "product_id": productId,
      "address_id": addressId,
      "total": totalAmount,
      "gold_purity": goldPurity,
      "bangle_size": bangleSize,
      "weight": weight,
      "intruction": instruction,
      "payment_method": paymentMethod,
      "payment_id": paymentId
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['error'] == false) {
          c.isCartLoading.value = false;
          Fluttertoast.showToast(msg: 'Order Placed Successfully');
          Get.back();
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return Dialog(
                surfaceTintColor: Colors.white,
                clipBehavior: Clip.none,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Thank You for choosing \n BRIIO!! \n Your order will be confirmed shortly.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              Navigator.of(context).pop(true);
            }
          });
        } else {
          c.isCartLoading.value = false;
          Get.back();
          Fluttertoast.showToast(msg: data['message'] ?? 'Failed');
        }
      } else {
        c.isCartLoading.value = false;
        Get.back();
        Fluttertoast.showToast(msg: 'Internal server error: ${response.statusCode}');
      }
    } catch (e) {
      c.isCartLoading.value = false;
      Get.back();
      Fluttertoast.showToast(msg: 'An error occurred');
    }
  }

  Future<void> deleteAddress(int addressId) async {
    final url =
        '${apiUrl}deleteAddress?user_id=${GlobalK.userId}&address_id=$addressId';
    final response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['error'] == false) {
        Fluttertoast.showToast(msg: 'Address deleted');
      } else {
        Fluttertoast.showToast(msg: 'Failed');
      }
    } else {
      Fluttertoast.showToast(msg: 'Internal server error');
    }
  }

  Future<AddressModel> showAddress() async {
    final url = '${apiUrl}showAddress?user_id=${GlobalK.userId}';
    final response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['error'] == false) {
        return AddressModel.fromJson(data);
      } else {
        Fluttertoast.showToast(msg: response.reasonPhrase.toString());
      }
    } else {
      Fluttertoast.showToast(msg: 'Internal server error');
    }
    throw Exception('Unable to load data');
  }
}

Future<void> saveAddressFromApi(
    {required int id,
    required String name,
    required String mobile,
    required String address,
    required String landmark,
    required String city,
    required String state,
    required String pincode}) async {
  final url =
      '${apiUrl}addaddress?user_id=$id&mobile=$mobile&landmark=$landmark&city=$city&state=$state&pincode=$pincode&address_1=$address&cname=$name';
  final response = await http.post(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['error'] == false) {
      Fluttertoast.showToast(msg: 'Address added');
      Get.back();
    } else {
      Fluttertoast.showToast(msg: 'Failed');
    }
  } else {
    Fluttertoast.showToast(msg: 'Internal server error');
  }
}
