import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentService {
  late Razorpay _razorpay;
  final Function(PaymentSuccessResponse response) onSuccess;
  final Function(String errorMessage) onFailure;

  PaymentService({required this.onSuccess, required this.onFailure}) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Payment success
    if (response.paymentId != null) {
      onSuccess(response);
    } else {
      onFailure("Payment ID is null");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Payment failed
    onFailure(response.message ?? "Payment failed");
    Fluttertoast.showToast(msg: "Payment Failed: ${response.message}", backgroundColor: Colors.red);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    Fluttertoast.showToast(msg: "External Wallet: ${response.walletName}");
  }

  void openCheckout({
    required double amount, 
    required String contact, 
    required String email, 
    required String orderName,
    required String description,
    String? orderId,
    String? key,
  }) {
    var options = {
      'key': key ?? 'rzp_test_Rrnfu4OS59k0vP', // Matched with backend generated orders
      'amount': (amount * 100).toInt(), // Razorpay expects amount in paise (multiply by 100)
      'name': 'BRIIO APP',
      'description': description,
      'prefill': {
        'contact': contact,
        'email': email,
      },
      if (orderId != null) 'order_id': orderId,
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening razorpay: $e');
      onFailure(e.toString());
    }
  }

  void dispose() {
    _razorpay.clear(); // Removes all listeners
  }
}
