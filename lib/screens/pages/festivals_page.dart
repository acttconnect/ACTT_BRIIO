import 'package:flutter/material.dart';

class FestivalsPage extends StatelessWidget {
  const FestivalsPage({super.key});

  final List<String> festivals = const [
    'Diwali',
    'New Year',
    'Makar Sankranti',
    'Republic Day',
    'Maha Shivratri',
    'Holi',
    'Ramzan',
    'Akshay Tritiya',
    'Raksha Bandhan',
    'Independence Day',
    'Janamashtmi',
    'Ganesh Chaturthi',
    'Navratri'
  ];

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
          'Festivals & Occasions',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: festivals.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey.shade200,
          height: 1,
        ),
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            title: Text(
              festivals[index],
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black54,
            ),
            onTap: () {
              // Handle festival selection
            },
          );
        },
      ),
    );
  }
}
