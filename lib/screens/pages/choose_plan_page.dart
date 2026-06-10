import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:briio_application/widgets/custom_loading.dart';
import 'package:briio_application/utils/payment_service.dart';
import 'package:briio_application/utils/globel_veriable.dart';
import 'package:briio_application/utils/const.dart';

class ChoosePlanPage extends StatefulWidget {
  const ChoosePlanPage({super.key});

  @override
  State<ChoosePlanPage> createState() => _ChoosePlanPageState();
}

class _ChoosePlanPageState extends State<ChoosePlanPage> {
  bool _isLoading = true;
  late PaymentService _paymentService;
  
  String _selectedPlanName = '';
  int _selectedDurationDays = 30;
  double _selectedAmount = 1000.0;
  double _selectedTotalWithGst = 1180.0;

  @override
  void initState() {
    super.initState();
    _paymentService = PaymentService(
      onSuccess: (response) async {
        Get.dialog(
          const Center(child: CircularProgressIndicator(color: Colors.white)),
          barrierDismissible: false,
        );
        
        try {
          var renewResponse = await http.post(
            Uri.parse('${apiUrl}membership-renew'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "user_id": GlobalK.userId ?? 1,
              "plan_name": _selectedPlanName,
              "amount": _selectedTotalWithGst,
              "duration_days": _selectedDurationDays,
              "razorpay_payment_id": response.paymentId,
              "razorpay_order_id": response.orderId ?? "",
              "razorpay_signature": response.signature ?? ""
            }),
          );

          Get.back(); // dismiss loading

          if (renewResponse.statusCode == 200 || renewResponse.statusCode == 201) {
            Get.snackbar('Success', 'Membership renewed successfully!', backgroundColor: Colors.green, colorText: Colors.white);
            if (mounted) {
              Navigator.pop(context); // Go back after success
            }
          } else {
            Get.snackbar('Error', 'Failed to renew membership. Please try again.', backgroundColor: Colors.red, colorText: Colors.white);
          }
        } catch (e) {
          Get.back(); // dismiss loading
          Get.snackbar('Error', 'An error occurred: $e', backgroundColor: Colors.red, colorText: Colors.white);
        }
      },
      onFailure: (errorMessage) {
        // Handled by PaymentService toasts
      },
    );
    _fetchPlans();
  }

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }

  Future<void> _fetchPlans() async {
    // Simulate fetching plans from an API
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showPaymentBottomSheet(String duration, String price, int priceNum) {
    int gst = (priceNum * 0.18).round();
    int total = priceNum + gst;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: const Color(0xFFFBF8FB), // Very light pinkish-white
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    duration,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '₹ $priceNum',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'GST (18%)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '₹ $gst',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.black12, thickness: 1),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '₹ $total',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D5146), // Brown color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context); // close bottom sheet first

                    Get.dialog(
                      const Center(child: CircularProgressIndicator(color: Colors.white)),
                      barrierDismissible: false,
                    );

                    try {
                      var orderResponse = await http.post(
                        Uri.parse('${apiUrl}generate-razorpay-order'),
                        headers: {
                          'Accept': 'application/json',
                          'Content-Type': 'application/json',
                        },
                        body: jsonEncode({
                          "amount": _selectedTotalWithGst,
                        }),
                      );

                      Get.back(); // dismiss loading

                      if (orderResponse.statusCode == 200 || orderResponse.statusCode == 201) {
                        var orderData = jsonDecode(orderResponse.body);
                        String orderId = orderData['id'] ?? orderData['order_id'] ?? '';

                        _paymentService.openCheckout(
                          amount: _selectedTotalWithGst,
                          contact: GlobalK.phone ?? '',
                          email: GlobalK.userEmail ?? GlobalK.mail ?? '',
                          orderName: 'BRIIO PLUS - $_selectedPlanName',
                          description: 'Subscription Payment',
                          orderId: orderId.isNotEmpty ? orderId : null,
                        );
                      } else {
                        Get.snackbar('Error', 'Failed to generate payment order', backgroundColor: Colors.red, colorText: Colors.white);
                      }
                    } catch (e) {
                      Get.back(); // dismiss loading
                      Get.snackbar('Error', 'Something went wrong: $e', backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  },
                  child: const Text(
                    'Pay Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Choose Your Plan',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: CustomLoading(width: 80, height: 80),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlanCard('1 Month', '1,000', 1000),
                  const SizedBox(height: 12),
                  _buildPlanCard('6 Months', '5,700', 5700),
                  const SizedBox(height: 12),
                  _buildPlanCard('12 Months', '10,800', 10800),
                  const SizedBox(height: 24),
                  const Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem('Unlimited Access to all jewellery categories'),
                  _buildFeatureItem('High-Quality Design Images on white background for easy sharing'),
                  _buildFeatureItem('Quick PDF Creation with your shop name & logo'),
                  _buildFeatureItem('Direct WhatsApp Sharing of selected designs to customers'),
                  _buildFeatureItem('Customer Management (CRM) – Save customer details (name, phone, DOB, anniversary)'),
                  _buildFeatureItem('Customer Reminders – Stay connected with customers on birthdays/anniversaries'),
                  _buildFeatureItem('Order Management – Add to cart, place bulk orders with one click'),
                  _buildFeatureItem('Low Wastage Guarantee on direct orders placed with BRIIO'),
                  _buildFeatureItem('Priority Support – Fast help whenever you need it'),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildPlanCard(String duration, String priceStr, int priceNum) {
    return GestureDetector(
      onTap: () {
        _selectedPlanName = duration;
        _selectedAmount = priceNum.toDouble();
        _selectedDurationDays = duration.contains('1 Month') ? 30 : (duration.contains('6 Months') ? 180 : 365);
        _selectedTotalWithGst = _selectedAmount + (_selectedAmount * 0.18).round();
        _showPaymentBottomSheet(duration, priceStr, priceNum);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFEBEBEB), // Light grey color from mockup
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              duration,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              '₹ $priceStr',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Icon(
              Icons.circle,
              size: 8,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
