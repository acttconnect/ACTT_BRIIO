import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:briio_application/widgets/custom_loading.dart';
import 'customer_info_screen.dart';

class CustomerListScreen extends StatefulWidget {
  final bool isSelectionMode;
  const CustomerListScreen({super.key, this.isSelectionMode = false});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  List<Map<String, dynamic>> customers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? customersJson = prefs.getString('saved_customers');
    if (customersJson != null) {
      setState(() {
        customers = List<Map<String, dynamic>>.from(json.decode(customersJson));
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _saveCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_customers', json.encode(customers));
  }

  void _deleteCustomer(int index) {
    setState(() {
      customers.removeAt(index);
    });
    _saveCustomers();
  }

  Future<void> _navigateToAddCustomer() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CustomerInfoScreen()),
    );
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        customers.add(result);
      });
      _saveCustomers();
    }
  }

  Future<void> _navigateToEditCustomer(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerInfoScreen(customer: customers[index]),
      ),
    );
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        customers[index] = result;
      });
      _saveCustomers();
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Colors.white;
    const textColor = Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'CUSTOMER LIST',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: textColor, size: 24),
            onPressed: _navigateToAddCustomer,
          ),
          IconButton(
            icon: const Icon(Icons.search, color: textColor, size: 24),
            onPressed: () {
              // TODO: Implement Search
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isLoading
          ? const Center(child: CustomLoading(width: 40, height: 40))
          : customers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No Customers Added Yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Card(
                        color: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.grey.shade200,
                              child: const Icon(
                                Icons.person,
                                color: Colors.black87,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              customer['name'] ?? 'Unknown',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: textColor,
                              ),
                            ),
                            subtitle: Text(
                              customer['phone'] ?? '',
                              style: GoogleFonts.poppins(
                                color: Colors.grey.shade500,
                                fontSize: 13,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Customer'),
                                        content: const Text('Are you sure you want to delete this customer?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _deleteCustomer(index);
                                            },
                                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                              ],
                            ),
                            onTap: () {
                              if (widget.isSelectionMode) {
                                Navigator.pop(context, customer);
                              } else {
                                _navigateToEditCustomer(index);
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
