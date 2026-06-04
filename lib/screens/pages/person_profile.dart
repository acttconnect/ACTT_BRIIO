import 'package:briio_application/screens/pages/savedaddress.dart';
import 'package:briio_application/screens/pages/update_profile.dart';
import 'package:briio_application/widgets/custom_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/auth_controller.dart';
import '../../utils/globel_veriable.dart';
import '../auth/sign_in.dart';
import 'customorder_history.dart';
import 'order_history.dart';
import 'package:briio_application/screens/pages/terms_conditions.dart';
import 'package:briio_application/screens/pages/about_us.dart';
import 'package:briio_application/screens/pages/privacy_policy.dart';
import 'package:briio_application/screens/pages/customer_care.dart';
import 'package:briio_application/screens/pages/bank_details.dart';
import 'package:briio_application/screens/pages/festivals_page.dart';
import 'package:briio_application/screens/pages/membership_details_page.dart';

class PersonProfile extends StatefulWidget {
  const PersonProfile({super.key});

  @override
  State<PersonProfile> createState() => _PersonProfileState();
}

class _PersonProfileState extends State<PersonProfile> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    // Simulate fetching user profile data from an API.
    // Replace this with your actual GET API call later.
    await Future.delayed(const Duration(seconds: 1));
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
        clipBehavior: Clip.none,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 1,
        title: Text(
          'PROFILE',
          style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: _isLoading 
                  ? Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: CustomLoading(width: 80, height: 80),
                        ),
                      ),
                    )
                  : Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.08,
                      child: Image.asset(
                        'assets/blg.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade700,
                              width: 6,
                            ),
                            color: Colors.grey.shade700,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${GlobalK.companyName}', // Assuming companyName corresponds to "New" or similar above Name
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  IconButton(
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                    icon: Image.asset(
                                      'assets/edit_icon.png',
                                      width: 20,
                                      height: 20,
                                      color: Colors.grey.shade600,
                                    ),
                                    onPressed: () async {
                                      final result = await Get.to(
                                          () => const UpdateProfileScreen());
                                      if (result == true) {
                                        setState(() {});
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${GlobalK.userFName}', // User name (e.g. Nosgsh)
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${GlobalK.address},${GlobalK.city},${GlobalK.state}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '+91${GlobalK.phone}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ), // Closing Padding
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildMenuItem(
              icon: Icons.shopping_bag,
              title: 'Orders History',
              onTap: () {
                if (GlobalK.userId == null) {
                  Get.offAll(() => const SignIn());
                } else {
                  Get.to(() => const OrderHistoryPage());
                }
              },
            ),
            _buildMenuItem(
              icon: Icons.dashboard_customize,
              title: 'Custom Order History',
              onTap: () {
                if (GlobalK.userId == null) {
                  Get.offAll(() => const SignIn());
                } else {
                  Get.to(() => const CustomOrderHistory());
                }
              },
            ),
            _buildMenuItem(
              icon: Icons.group,
              title: 'Customer List',
              onTap: () {
                // TODO: Navigate to Customer List
              },
            ),
            _buildMenuItem(
              icon: Icons.support_agent,
              title: 'Customer Care',
              onTap: () => Get.to(() => const CustomerCare()),
            ),
            _buildMenuItem(
              icon: Icons.celebration,
              title: 'Greetings',
              onTap: () => Get.to(() => const FestivalsPage()),
            ),
            _buildMenuItem(
              icon: Icons.card_membership,
              title: 'Membership Details',
              onTap: () {
                Get.to(() => const MembershipDetailsPage());
              },
            ),
            _buildMenuItem(
              icon: Icons.group,
              title: 'About us',
              onTap: () => Get.to(() => const AboutUs()),
            ),
            _buildMenuItem(
              icon: Icons.security,
              title: 'Privacy Policy',
              onTap: () => Get.to(() => const PrivacyPolicy()),
            ),
            _buildMenuItem(
              icon: Icons.security,
              title: 'Terms & Conditions',
              onTap: () => Get.to(() => const TermsConditions()),
            ),
            _buildMenuItem(
              icon: Icons.language,
              title: 'Visit Our Website',
              onTap: () async {
                final Uri url = Uri.parse('https://briio.in/');
                if (!await launchUrl(url,
                    mode: LaunchMode.externalApplication)) {
                  Get.snackbar('Error', 'Could not launch website');
                }
              },
            ),
            _buildMenuItem(
              icon: Icons.account_balance,
              title: 'Bank Details',
              onTap: () => Get.to(() => const BankDetails()),
            ),
            _buildMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {
                Get.defaultDialog(
                  backgroundColor: Colors.white,
                  title: 'Confirm Logout',
                  middleText: 'Are you sure you want to logout?',
                  confirm: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                    ),
                    onPressed: () => AuthLogin.logout(),
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  cancel: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                    ),
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 80), // Padding for floating button
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Open WhatsApp for support
        },
        backgroundColor: Colors.green,
        shape: const CircleBorder(),
        child: Image.asset(
          'assets/whatsapp.png', // WhatsApp icon
          height: 35,
          width: 35,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          leading: Icon(
            icon,
            color: Colors.black54,
            size: 26,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Colors.black54,
          ),
          onTap: onTap,
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFF5F5F5), // Very light divider
        ),
      ],
    );
  }
}
