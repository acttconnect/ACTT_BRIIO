import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:briio_application/widgets/custom_loading.dart';
import 'package:briio_application/screens/pages/greeting_images_page.dart';

class FestivalsPage extends StatefulWidget {
  const FestivalsPage({super.key});

  @override
  State<FestivalsPage> createState() => _FestivalsPageState();
}

class _FestivalsPageState extends State<FestivalsPage> {
  bool isLoading = true;
  List<dynamic> allGreetings = [];

  final List<String> staticFestivals = const [
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
  void initState() {
    super.initState();
    _fetchGreetings();
  }

  Future<void> _fetchGreetings() async {
    try {
      final response = await http.get(Uri.parse('https://briio.in/api/get-greetings'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          allGreetings = List.from(data['data']);
        }
      }
    } catch (e) {
      debugPrint("Error fetching greetings: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
          'Festivals & Occasions',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
      body: isLoading 
        ? const Center(child: CustomLoading(width: 40, height: 40))
        : ListView.separated(
            itemCount: staticFestivals.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.shade200,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final festivalName = staticFestivals[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                title: Text(
                  festivalName,
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
                      // Get all greetings that match this festival name
                      final categoryGreetings = allGreetings
                          .where((element) => element['sub_category'] == festivalName)
                          .toList();
                          
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GreetingImagesPage(
                            festivalName: festivalName,
                            greetings: categoryGreetings,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
