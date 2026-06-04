import 'package:flutter/material.dart';

class BankDetails extends StatelessWidget {
  const BankDetails({super.key});

  Widget _buildDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 8, bottom: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.grey.shade700),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 1,
        title: Text(
          'BANK DETAILS',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.account_balance,
                size: 100,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailItem('COMPANY', 'Brij Ornaments Pvt. Ltd.'),
            _buildDetailItem('BANK', 'HDFC Bank'),
            _buildDetailItem('ACCOUNT NUMBER', '50200071036921'),
            _buildDetailItem('IFSC CODE', 'HDFC0002357'),
            _buildDetailItem('BRANCH', 'Zone II, M.P. Nagar, Bhopal'),
          ],
        ),
      ),
    );
  }
} 