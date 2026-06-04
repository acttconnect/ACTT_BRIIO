import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

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
          'PRIVACY POLICY',
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
            SizedBox(
              width: double.infinity,
              child: RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: 'This privacy policy sets out how Brij Ornaments Pvt. Ltd. uses and protects any information that you give us when you use our app or website. Brij Ornaments Pvt. Ltd. is committed to ensuring that your privacy is protected. Should we ask you to provide certain information by which you can be identified when using our app or website, then you can be assured that it will only be used in accordance with this privacy statement. Brij Ornaments Pvt. Ltd. may change this policy from time to time by updating this page. You should check this page from time to time to ensure that you are happy with any changes.\n\n',
                    ),
                    TextSpan(
                      text: 'We may collect the following information:\n',
                      style: TextStyle(fontWeight: FontWeight.bold, height: 2.0),
                    ),
                    TextSpan(
                      text: '- Company name, owner\'s name\n'
                      '- Contact information, including email address\n'
                      '- Demographic information such as pincode and preferences\n'
                      '- Other information relevant to customer surveys and/or offers\n\n',
                    ),
                    TextSpan(
                      text: 'When you purchase something from our app or website, as part of the buying and selling process, we collect the personal information you give us, such as your name, address, and email address.\n\n'
                      'When you browse our app or website, we also automatically receive your computer\'s internet protocol (IP) address in order to provide us with information that helps us learn about your browser and operating system.\n\n'
                      'Email marketing (if applicable): With your permission, we may send you emails about our store, new products, and other updates.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 