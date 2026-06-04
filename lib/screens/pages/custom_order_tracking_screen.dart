import 'package:briio_application/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../model/customorder_model.dart';
import '../../utils/globel_veriable.dart';

class CustomOrderTrackingScreen extends StatelessWidget {
  final Data order;

  const CustomOrderTrackingScreen({
    super.key, 
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> images = order.imagepicker!.split(',');

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
          'CUSTOM ORDER TRACKING',
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
                Text('${order.status}', style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.grey.shade700),),
                Text('${order.createdAt?.split('T')[0]}', style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.grey.shade700),),
              ],
            ),
            _buildDetailCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Images carousel
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              '$imgPath/products/${images[index]}',
                              height: 150,
                              width: MediaQuery.of(context).size.width * 0.35,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(child: CircularProgressIndicator());
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Details section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customized Design',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow('Gold Purity', '${order.caret}'),
                        _buildDetailRow('Bangle Size', order.bangleSize ?? ''),
                        _buildDetailRow('Weight', '${order.gram}g'),
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
                order.description ?? 'No instructions provided',
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
                    style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
      
                  Text(
                    '${GlobalK.address}\n'
                    // '${GlobalK.landmark != "NA" ? "${GlobalK.landmark}, " : ""}'
                    '${GlobalK.city}, ${GlobalK.state}\n'
                    'PIN: ${GlobalK.pincode}\n'
                    'Mobile: ${GlobalK.phone}',
                    style: GoogleFonts.lato(fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Order Timeline Section
            _buildSectionTitle('Track Delivery'),
            _buildTimeline(order),
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
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(Data order) {
    final List<Map<String, dynamic>> stages = [
      {
        'title': 'Order Placed',
        'status': order.status,
        'date': order.createdAt?.split('T')[0],
      },
      {
        'title': 'Order Confirmed',
        'status': order.status == 'Confirmed' || order.status == 'Ready' || order.status == 'Delivered' ? 'Confirmed' : null,
        'date': order.status == 'Confirmed' || order.status == 'Ready' || order.status == 'Delivered' ? order.updatedAt?.split('T')[0] : null,
      },
      {
        'title': 'Ready for Delivery',
        'status': order.status == 'Ready' || order.status == 'Delivered' ? 'Ready' : null,
        'date': order.status == 'Ready' || order.status == 'Delivered' ? order.updatedAt?.split('T')[0] : null,
      },
      {
        'title': 'Delivered',
        'status': order.status == 'Delivered' ? 'Delivered' : null,
        'date': order.status == 'Delivered' ? order.updatedAt?.split('T')[0] : null,
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
                  Text(
                    stages[index]['title'],
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: stages[index]['status'] != null
                          ? Colors.black
                          : Colors.grey.shade600,
                    ),
                  ),
                  if (stages[index]['date'] != null)
                    Text(
                      stages[index]['date'],
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.grey.shade600,
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