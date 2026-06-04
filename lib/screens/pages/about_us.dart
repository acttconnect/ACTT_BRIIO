import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

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
          'ABOUT US',
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
                      text: 'Welcome to BRIIO, where craftsmanship meets elegance in every golden detail. As purveyors of exquisite gold bangles, we embody a legacy of meticulous artistry and timeless design. With a passion for perfection, we meticulously craft each piece, infusing it with the richness of tradition and the allure of modern sophistication. At BRIIO, we don\'t just create accessories; we curate statements of style and symbols of prestige. Join us in celebrating the beauty of gold, as we redefine luxury one bangle at a time.',
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