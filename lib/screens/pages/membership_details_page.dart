import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:briio_application/widgets/custom_loading.dart';
import 'package:briio_application/screens/pages/choose_plan_page.dart';
import 'package:briio_application/screens/pages/view_bill_page.dart';
import 'package:briio_application/utils/const.dart';
import 'package:briio_application/utils/globel_veriable.dart';

class MembershipDetailsPage extends StatefulWidget {
  const MembershipDetailsPage({super.key});

  @override
  State<MembershipDetailsPage> createState() => _MembershipDetailsPageState();
}

class _MembershipDetailsPageState extends State<MembershipDetailsPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _membershipData;

  @override
  void initState() {
    super.initState();
    _fetchMembership();
  }

  Future<void> _fetchMembership() async {
    try {
      var response = await http.get(Uri.parse('${apiUrl}membership-purchases?user_id=${GlobalK.userId ?? 1}'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          _membershipData = data.first;
        } else if (data is Map && data['data'] != null && data['data'] is List && data['data'].isNotEmpty) {
          _membershipData = data['data'].first;
        } else if (data is Map && data.containsKey('plan_name')) {
          _membershipData = data as Map<String, dynamic>;
        } else if (data is Map && data.containsKey('membership')) {
          _membershipData = data['membership'];
        }
      }
    } catch (e) {
      debugPrint("Error fetching membership: $e");
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
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
          'MEMBERSHIP DETAILS',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoading)
              const Expanded(
                child: Center(
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: CustomLoading(width: 80, height: 80),
                  ),
                ),
              )
            else ...[
              const Text(
                'Membership',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              if (_membershipData == null)
                const Text(
                  'No active membership found.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                )
              else
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E7E3), // Light grey/beige from mockup
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Plan Name',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            _membershipData?['plan_name']?.toString() ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Duration',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            _membershipData?['duration_days'] != null ? '${_membershipData!['duration_days']} Days' : 'N/A',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Purchase Date',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            _membershipData?['created_at'] != null ? _membershipData!['created_at'].toString().substring(0, 10) : 'N/A',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Get.to(() => ViewBillPage(membershipData: _membershipData));
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 18, color: Colors.black54),
                          SizedBox(width: 8),
                          Text(
                            'View bill',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5D5146), // Brown color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await Get.to(() => const ChoosePlanPage());
                  if (mounted) {
                    setState(() {
                      _isLoading = true;
                    });
                    _fetchMembership();
                  }
                },
                child: const Text(
                  'UPGRADE PLAN',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
