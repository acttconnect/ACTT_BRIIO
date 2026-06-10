import 'package:briio_application/widgets/custom_loading.dart';
import 'package:briio_application/utils/const.dart';
import 'package:briio_application/utils/globel_veriable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../model/show_history.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Orders order;
  final int orderDetailIndex;

  const OrderTrackingScreen({
    super.key, 
    required this.order,
    required this.orderDetailIndex,
  });

  @override
  Widget build(BuildContext context) {
    final orderDetail = order.orderdetails![orderDetailIndex];
    final address = order.address!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.grey.shade700),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Text(
          'ORDER ID-${order.orderid}',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Details Section
            _buildSectionTitle('Order Details'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${orderDetail.activeStatus}", style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.grey.shade700),),
                Text('${orderDetail.createdAt?.split('T')[0]}', style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.grey.shade700),),
              ],
            ),
            _buildDetailCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image section
                 ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        '$imgPath/products/${orderDetail.image}',
                        fit: BoxFit.cover,
                        height: 150,
                      
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CustomLoading(width: 40, height: 40));
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print('Image Error: $error');
                          return Icon(Icons.error);
                        },
                      ),
                    ),
                  // Details section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                        '${orderDetail.productname}',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                        _buildDetailRow('Gold Purity', orderDetail.goldPurity ?? ''),
                        _buildDetailRow('Bangle Size', orderDetail.bangleSize ?? ''),
                        _buildDetailRow('Weight', '${orderDetail.weight}g'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    
            const SizedBox(height: 24),
    
            // Additional Instructions Section
            _buildSectionTitle('Additional Instructions'),
            _buildDetailCard(
              child: Text(
                orderDetail.intruction ?? 'No instructions provided',
                style: GoogleFonts.lato(fontSize: 14),
              ),
            ),
    
            const SizedBox(height: 24),
    
            // Delivery Address Section
            _buildSectionTitle('Delivery Address'),
            _buildDetailCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${GlobalK.companyName}',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${address.address1}\n'
                    '${address.landmark != "NA" ? "${address.landmark}, " : ""}'
                    '${address.city}, ${address.state}\n'
                    'PIN: ${address.pincode}\n'
                    'Mobile: ${address.mobile}',
                    style: GoogleFonts.lato(fontSize: 14),
                  ),
                ],
              ),
            ),
    
            const SizedBox(height: 24),
    
            // Order Timeline Section
            _buildSectionTitle('Track Delivery'),
            _buildTimeline(orderDetail),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _buildDetailCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // const SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(Orderdetails orderDetail) {
    final List<Map<String, dynamic>> stages = [
      {
        'title': 'Order Placed',
        'status': orderDetail.activeStatus,
        'date': orderDetail.createdAt?.split('T')[0],
      },
      {
        'title': 'Order Confirmed',
        'status': orderDetail.confirmedStatus,
        'date': orderDetail.confirmedStatusDate,
      },
      {
        'title': 'Ready for Delivery',
        'status': orderDetail.readyStatus,
        'date': orderDetail.readyStatusDate,
      },
      {
        'title': 'Delivered',
        'status': orderDetail.deliveredStatus,
        'date': orderDetail.deliveredStatusDate,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: List.generate(
          stages.length,
          (index) => TimelineTile(
            isFirst: index == 0,
            isLast: index == stages.length - 1,
            beforeLineStyle: LineStyle(
              color: stages[index]['status'] != null 
                  ? Colors.blue 
                  : Colors.grey.shade300,
            ),
            afterLineStyle: LineStyle(
              color: index < stages.length - 1 && stages[index + 1]['status'] != null
                  ? Colors.blue
                  : Colors.grey.shade300,
            ),
            indicatorStyle: IndicatorStyle(
              width: 20,
              color: stages[index]['status'] != null
                  ? Colors.blue
                  : Colors.grey.shade300,
            ),
            endChild: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      stages[index]['title'],
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: stages[index]['status'] != null
                            ? Colors.black
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  if (stages[index]['date'] != null)
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          stages[index]['date'],
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 