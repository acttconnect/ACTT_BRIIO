import 'package:flutter/material.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

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
          'TERMS & CONDITIONS',
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
                      text: 'This page contains the terms & conditions. Please read these terms & conditions carefully before ordering any products from us. By purchasing any items from our official application, you agree to be bound by these terms & conditions.\n\n'
                      'By placing any order at "BRIIO", you warrant that you are 18 years or above and accept these terms & conditions which shall apply to all orders placed or to be placed at Brij Ornaments Pvt Ltd for the sale and supply of any products. None of these terms & conditions affects your statutory rights. No other terms or changes to the terms & conditions shall be binding unless agreed in writing and signed by us.\n\n'
                      'All personal information you provide us with or that we obtain will be handled by Brij Ornaments Pvt Ltd as responsible for the personal information.\n\n'
                      'Events outside Brij Ornaments Pvt Ltd\'s control should be considered force majeure.\n\n'
                      'The price applicable is on the date the order is placed with us.\n\n',
                    ),
                    TextSpan(
                      text: 'Personal Information:\n',
                      style: TextStyle(fontWeight: FontWeight.bold, height: 2.0),
                    ),
                    TextSpan(
                      text: 'All personal information you provide us with or that we obtain will be handled by Brij Ornaments Pvt Ltd as responsible for the personal information. The personal information you provide will be used to ensure delivery to you, the credit assessment, to provide offers and information on our catalog to you. The information you provide is only available to Brij Ornaments Pvt Ltd and will not be shared with other third parties. You have the right to inspect the information held about you. You always have the right to request Brij Ornaments Pvt Ltd to delete or correct the information held about you. By accepting the Brij Ornaments Pvt Ltd Conditions, you agree to the above.\n\n',
                    ),
                    TextSpan(
                      text: 'Force Majeure:\n',
                      style: TextStyle(fontWeight: FontWeight.bold, height: 2.0),
                    ),
                    TextSpan(
                      text: 'Events outside Brij Ornaments Pvt Ltd\'s control, which are not reasonably foreseeable, shall be considered force majeure. Examples of such events are government action or omission, new or amended legislation, conflict, embargo, fire or flood, sabotage, accident, war, natural disasters, strikes or lack of delivery from suppliers. The force majeure also includes government decisions that affect the market negatively and products. For example, restrictions, warnings, bans, etc.\n\n',
                    ),
                    TextSpan(
                      text: 'Cookies:\n',
                      style: TextStyle(fontWeight: FontWeight.bold, height: 2.0),
                    ),
                    TextSpan(
                      text: '"BRIIO" uses cookies according to the new Electronic Communications Act, which came into force on 25 July 2003. A cookie is a small text file stored on your computer that contains information that helps the website to identify and track the visitor. Cookies do no harm to your computer, consist only of text, can not contain viruses and occupy virtually no space on your hard drive. There are two types of cookies: "Session Cookies" and cookies that are saved permanently on your computer.\n\n'
                      'The first type of cookie commonly used is "Session Cookies". During the time you visit the website, our web server assigns your browser a unique identifier string so as not to confuse you with other visitors. A "Session Cookie" is never stored permanently on your computer and disappears when you close your browser. To use "BRIIO" without problems, you need to have cookies enabled.\n\n'
                      'The second type of cookie saves a file permanently on your computer. This type of cookie is used to track how visitors move around on the website. This is only used to offer visitors better services and support. The text files can be deleted. On "BRIIO" we use this type of cookie to keep track of your shopping cart and to keep statistics of our visitors. The information stored on your computer is only a unique number, without any connection to personal information.\n\n',
                    ),
                    TextSpan(
                      text: 'Additional Information:\n',
                      style: TextStyle(fontWeight: FontWeight.bold, height: 2.0),
                    ),
                    TextSpan(
                      text: 'Brij Ornaments Pvt Ltd reserves the right to amend any information, including but not limited to technical specifications, terms of purchase and product offerings without prior notice. At the event of when a product is sold out, Brij Ornaments Pvt Ltd has the right to cancel the order. Brij Ornaments Pvt Ltd shall also notify the customer of equivalent replacement products if available.',
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