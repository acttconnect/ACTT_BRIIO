import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../model/customorder_model.dart';
import '../../utils/const.dart';
import '../../utils/globel_veriable.dart';
import '../home/container_radius.dart';
import 'package:http/http.dart' as http;
import '../pages/custom_order_tracking_screen.dart';

class CustomOrderHistory extends StatefulWidget {
  const CustomOrderHistory({super.key});

  @override
  State<CustomOrderHistory> createState() => _CustomOrderHistoryState();
}

class _CustomOrderHistoryState extends State<CustomOrderHistory> {
  final normalText =
      TextStyle(fontSize: 14, fontFamily: GoogleFonts.lato().fontFamily);

  final largeText =
      TextStyle(fontSize: 16, fontFamily: GoogleFonts.lato().fontFamily);

  final normalColorText = TextStyle(
      fontSize: 16,
      fontFamily: GoogleFonts.lato().fontFamily,
      color: Colors.amber.shade800);

  Future<CustomOrderModel> getCustomOrder() async {
    final url = '${apiUrl}getOrders?cid=${GlobalK.userId}';
    final response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['error'] == false) {
        return CustomOrderModel.fromJson(data);
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong');
      }
    } else {
      Fluttertoast.showToast(
          msg:
              'Internal server error ${response.statusCode} ${response.reasonPhrase}');
    }
    throw Exception('Unable to load data');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: Colors.grey.shade700,
            )),
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          'CUSTOM ORDER HISTORY',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700),
        ),
      ),
      body: FutureBuilder<CustomOrderModel>(
        future: getCustomOrder(),
        builder: (context, snapshot) => snapshot.hasData
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.data!.length,
                  itemBuilder: (context, ind) =>
                      buildCustomOrderCard(context, snapshot, ind),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget buildCustomOrderCard(BuildContext context,
      AsyncSnapshot<CustomOrderModel> snapshot, int index) {
    final size = MediaQuery.of(context).size;
    final item = snapshot.data!.data![index];
    List<String> images = [];
    images = item.imagepicker!.split(',');
    final createdAt = DateTime.parse(item.createdAt!);
    final formattedDate = DateFormat('yyyy-MM-dd').format(createdAt);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order ID : ${item.orderId}', style: TextStyle(fontSize: 16)),
                Text(formattedDate, style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomOrderTrackingScreen(
                    order: item,
                  ),
                ),
              );
            },
            child: RoundedContainer(
              padding: const EdgeInsets.all(16),
              isImage: false,
              borderColor: Colors.grey.shade500,
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section
                  SizedBox(
                    width: size.width * 0.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Replace single image with scrollable row of images
                        SizedBox(
                          height: 100,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: images.map((image) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      '$imgPath/products/$image',
                                      height: 100,
                                      width: size.width * 0.3,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Details Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gold Purity
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text('Gold Purity', style: normalText),
                            ),
                            Expanded(
                              child: Text('${item.caret} Carat', 
                                style: normalText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Bangle Size
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text('Bangle Size', style: normalText),
                            ),
                            Expanded(
                              child: Text(item.bangleSize!, 
                                style: normalText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Weight
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text('Weight', style: normalText),
                            ),
                            Expanded(
                              child: Text('${item.gram}g', 
                                style: normalText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Status
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text('Status', style: normalText),
                            ),
                            Expanded(
                              child: Text(item.status!, 
                                style: normalColorText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
