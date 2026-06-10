import 'package:briio_application/widgets/custom_loading.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import '../../model/show_history.dart';
import '../../utils/const.dart';
import '../../utils/globel_veriable.dart';
import '../home/container_radius.dart';
import '../pages/order_tracking_screen.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  Future<ShowOrderModel> getOrderHistory() async {
    final response = await post(
      Uri.parse('${apiUrl}getOrderData'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"user_id": GlobalK.userId}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body.toString());
      if (data['error'] == false) {
        return ShowOrderModel.fromJson(data);
      } else {
        Fluttertoast.showToast(msg: response.reasonPhrase.toString());
      }
    } else {
      Fluttertoast.showToast(msg: response.reasonPhrase.toString());
    }
    throw Exception('Unable to load data');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: Colors.grey.shade700,
            )),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        foregroundColor: Colors.black,
        title: Text(
          'ORDER HISTORY',
          style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<ShowOrderModel>(
          future: getOrderHistory(),
          builder: (context, snapshot) => snapshot.hasData
              ? snapshot.data!.orders!.isEmpty
                  ? Center(
                      child: Text(
                        'You have not ordered any product yet',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.orders!.length,
                      itemBuilder: (context, index) => OrdersCard(
                        snapshot: snapshot,
                        index: index,
                      ),
                    )
              : const Center(
                  child: CustomLoading(width: 40, height: 40),
                ),
        ),
      ),
    );
  }
}

class OrdersCard extends StatelessWidget {
  final AsyncSnapshot<ShowOrderModel> snapshot;
  final int index;

  OrdersCard({
    super.key,
    required this.snapshot,
    required this.index,
  });

  final normalText =
      TextStyle(fontSize: 12, fontFamily: GoogleFonts.lato().fontFamily);
  final largeText =
      TextStyle(fontSize: 14, fontFamily: GoogleFonts.lato().fontFamily);
  final normalColorText = TextStyle(
      fontSize: 18,
      fontFamily: GoogleFonts.lato().fontFamily,
      color: Colors.amber.shade800);

  @override
  Widget build(BuildContext context) {
    final orderId = snapshot.data!.orders![index].orderid;
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order ID : $orderId', style: largeText),
                Text(
                    snapshot.data!.orders![index].orderdetails![0].createdAt!
                        .split('T')
                        .first,
                    style: normalText),
              ],
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.orders![index].orderdetails!.length,
            itemBuilder: (context, ind) => ordersItemCard(snapshot, ind, size, context),
          )
        ],
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.only(top: 8),
    //   child: RoundedContainer(
    //     padding: const EdgeInsets.all(8),
    //     color: Colors.black12,
    //     isImage: false,
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Row(
    //           mainAxisSize: MainAxisSize.max,
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Text('Order ID : $orderId!', style: largeText),
    //             Text(
    //                 snapshot.data!.orders![index].orderdetails![0].createdAt!
    //                     .split('T')
    //                     .first,
    //                 style: normalText),
    //           ],
    //         ),
    //         // Text('Delivery Address : ', style: normalColorText),
    //         // Text(
    //         //     '${address.cname!},\n${address.address1!} ${address.landmark}, ${address.city!},\n${address.state}, India\nPin Code : ${address.pincode}\nMobile No : ${address.mobile}',
    //         //     style: normalText),
    //         ListView.builder(
    //           physics: const NeverScrollableScrollPhysics(),
    //           shrinkWrap: true,
    //           itemCount: snapshot.data!.orders![index].orderdetails!.length,
    //           itemBuilder: (context, ind) =>
    //               ordersItemCard(snapshot, ind, size),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }

  ordersItemCard(AsyncSnapshot<ShowOrderModel> snapshot, int ind, Size size, BuildContext context) {
    final item = snapshot.data!.orders![index].orderdetails![ind];
    
    // Function to get status color
    Color getStatusColor(String? status) {
      switch(status?.toLowerCase()) {
        case 'delivered':
          return Colors.green;
        case 'confirmed':
          return Colors.blue;
        case 'ready':
          return Colors.orange;
        case 'cancelled':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderTrackingScreen(
              order: snapshot.data!.orders![index],
              orderDetailIndex: ind,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: RoundedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          borderColor: Colors.grey.shade500,
          isImage: false,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundedContainer(
                height: 150,
                width: size.width * 0.4,
                isImage: true,
                networkImg: '$imgPath/products/${item.image}',
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productname!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('Gold Purity', item.goldPurity ?? '22kt'),
                      _buildInfoRow('Bangle Size', item.bangleSize ?? '2 - 8'),
                      _buildInfoRow('Weight', '${item.weight}g'),
                      _buildInfoRow(
                        'Status',
                        item.activeStatus ?? '',
                        valueColor: getStatusColor(item.activeStatus),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,  // Fixed width for labels like in custom order history
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: valueColor ?? Colors.black87,
                fontWeight: valueColor != null ? FontWeight.w500 : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,  // Add ellipsis if the text is too long
              maxLines: 1,  // Ensure the text stays on a single line
            ),
          ),
        ],
      ),
    );
  }
}
