import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerCare extends StatelessWidget {
  const CustomerCare({super.key});

  void _launchWhatsApp() async {
    final whatsappUrl = "whatsapp://send?phone=+919797099707";
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      // If WhatsApp is not installed, open in browser
      await launchUrl(Uri.parse("https://wa.me/+919797099707"));
    }
  }

  void _launchEmail() async {
    final Uri emailUri = Uri.parse('mailto:customercare@briio.in');
    
    try {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch email: $e');
    }
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
          'CUSTOMER CARE',
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
                      text: 'Welcome to BRIIO\'s Customer Care page! We always prioritize your satisfaction and aim to provide exceptional support for your mobile experience. Whether youhave questions, feedback, or encounterany issues while using our application, ourdedicated customer care team is here toassist you promptly and effectively.\n\n',
                    ),
                    TextSpan(
                      text: 'How can we help you?\n',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 2.0,
                      ),
                    ),
                    TextSpan(
                      text: '\n1. Contact Us:\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Have a specific issue or need personalized assistance? Reach out to our support team directly via email or through WhatsApp messaging feature.\n\n',
                    ),
                    TextSpan(
                      text: '2. Feedback:\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Your feedback is invaluable to us! Share your thoughts, suggestions, or concerns to help us enhance your BRIIO experience.\n\n',
                    ),
                    TextSpan(
                      text: '3. Updates:\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Stay informed about the latest app updates, improvements, and announcements.\n\n',
                    ),
                    TextSpan(
                      text: 'At BRIIO, we\'re committed to delivering a seamless and enjoyable mobile experience. Your satisfaction is our priority, and we\'re here to ensure that your journey with BRIIO is nothing short of excellent.\n\n',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: _launchWhatsApp,
              child: Row(
                children: const [
                  Icon(Icons.phone, color: Colors.black45),
                  SizedBox(width: 10),
                  Text(
                    '+91 79700 99707',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: _launchEmail,
              child: Row(
                children: const [
                  Icon(Icons.email_outlined, color: Colors.black45),
                  SizedBox(width: 10),
                  Text(
                    'customercare@briio.in',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: _launchWhatsApp,
                backgroundColor: Colors.transparent,
                child: Image.asset('assets/wapp.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 