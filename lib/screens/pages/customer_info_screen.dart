import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:fluttertoast/fluttertoast.dart';

class CustomerInfoScreen extends StatefulWidget {
  final Map<String, dynamic>? customer;

  const CustomerInfoScreen({super.key, this.customer});

  @override
  State<CustomerInfoScreen> createState() => _CustomerInfoScreenState();
}

class _CustomerInfoScreenState extends State<CustomerInfoScreen> {
  late TextEditingController mobileController;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController dobController;
  late TextEditingController anniversaryController;

  String? nameError;
  String? mobileError;
  String? emailError;

  @override
  void initState() {
    super.initState();
    mobileController = TextEditingController(text: widget.customer?['phone'] ?? '');
    nameController = TextEditingController(text: widget.customer?['name'] ?? '');
    emailController = TextEditingController(text: widget.customer?['email'] ?? '');
    dobController = TextEditingController(text: widget.customer?['dob'] ?? '');
    anniversaryController = TextEditingController(text: widget.customer?['anniversary'] ?? '');
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _sharePdf() async {
    if (nameController.text.isEmpty && mobileController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least Name or Mobile Number to share')),
      );
      return;
    }

    pw.MemoryImage? logoImage;
    try {
      // Try to load the logo image
      final ByteData bytes = await rootBundle.load('assets/logo.png');
      logoImage = pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (e) {
      try {
        // Fallback to app_icon if logo is not available
        final ByteData bytes = await rootBundle.load('assets/app_icon.jpg');
        logoImage = pw.MemoryImage(bytes.buffer.asUint8List());
      } catch (_) {}
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (logoImage != null)
                  pw.Center(
                    child: pw.Image(logoImage, height: 80),
                  ),
                pw.SizedBox(height: 20),
                pw.Center(
                  child: pw.Text('BRIIO CUSTOMER INFO', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.brown800)),
                ),
                pw.SizedBox(height: 40),
                pw.Container(
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Name: ${nameController.text}', style: const pw.TextStyle(fontSize: 18)),
                      pw.SizedBox(height: 16),
                      pw.Text('Mobile Number: ${mobileController.text}', style: const pw.TextStyle(fontSize: 18)),
                      if (emailController.text.isNotEmpty) ...[
                        pw.SizedBox(height: 16),
                        pw.Text('Email: ${emailController.text}', style: const pw.TextStyle(fontSize: 18)),
                      ],
                      if (dobController.text.isNotEmpty) ...[
                        pw.SizedBox(height: 16),
                        pw.Text('Date of Birth: ${dobController.text}', style: const pw.TextStyle(fontSize: 18)),
                      ],
                      if (anniversaryController.text.isNotEmpty) ...[
                        pw.SizedBox(height: 16),
                        pw.Text('Anniversary: ${anniversaryController.text}', style: const pw.TextStyle(fontSize: 18)),
                      ],
                    ],
                  )
                )
              ],
            ),
          );
        },
      ),
    );

    try {
      final output = await getTemporaryDirectory();
      final fileName = nameController.text.isNotEmpty 
          ? nameController.text.replaceAll(' ', '_') 
          : 'Customer';
      final file = File('${output.path}/$fileName.pdf');
      await file.writeAsBytes(await pdf.save());
      
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Customer Info: ${nameController.text}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating PDF: $e')),
        );
      }
    }
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    Widget? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(fontSize: 16, color: const Color(0xFF5D5146)),
        onChanged: (_) {
          // Clear error text when user starts typing
          if (errorText != null) {
            setState(() {
              if (controller == nameController) nameError = null;
              if (controller == mobileController) mobileError = null;
              if (controller == emailController) emailError = null;
            });
          }
        },
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: const Color(0xFFA1A1A1), fontSize: 16),
          errorText: errorText,
          errorStyle: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 12),
          filled: true,
          fillColor: const Color(0xFFF4F4F4), // Very light grey
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: errorText != null ? const BorderSide(color: Colors.redAccent) : BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          suffixIcon: suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: suffixIcon,
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFFCF9FC); // Extremely light pinkish-white background
    const textColor = Color(0xFF4C433C); // Soft dark brown
    
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'CUSTOMER INFO',
          style: GoogleFonts.poppins(
            fontSize: 18,
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Profile Avatar
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFEBEBEB), // Light grey for avatar bg
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 24),

              // Form Fields
              _buildTextField(
                hint: 'Mobile Number',
                controller: mobileController,
                keyboardType: TextInputType.phone,
                errorText: mobileError,
                suffixIcon: GestureDetector(
                  onTap: () {
                    if (mobileController.text.isNotEmpty) {
                      Clipboard.setData(ClipboardData(text: mobileController.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mobile number copied')),
                      );
                    }
                  },
                  child: const Icon(Icons.copy, color: textColor, size: 24),
                ),
              ),

              _buildTextField(
                hint: 'Customer Name',
                controller: nameController,
                errorText: nameError,
              ),

              _buildTextField(
                hint: 'Email ID',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                errorText: emailError,
              ),

              _buildTextField(
                hint: 'Date of Birth',
                controller: dobController,
                readOnly: true,
                onTap: () => _selectDate(context, dobController),
                suffixIcon: const Icon(Icons.calendar_today, color: textColor, size: 22),
              ),

              _buildTextField(
                hint: 'Anniversary',
                controller: anniversaryController,
                readOnly: true,
                onTap: () => _selectDate(context, anniversaryController),
                suffixIcon: const Icon(Icons.calendar_today, color: textColor, size: 22),
              ),

              const SizedBox(height: 24),

              // PDF and Templates Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // PDF Document Icon (clickable)
                  GestureDetector(
                    onTap: _sharePdf,
                    child: Container(
                      width: 36,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: textColor, width: 2.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.insert_drive_file,
                            size: 24,
                            color: textColor,
                          ),
                          Positioned(
                            bottom: 4,
                            child: Container(
                              color: bgColor,
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: const Text(
                                'PDF',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: textColor,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'Use Templetes',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Save Button
              Center(
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF53483E), // Proper dark brown button
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      final name = nameController.text.trim();
                      final mobile = mobileController.text.trim();
                      final email = emailController.text.trim();
                      
                      setState(() {
                        nameError = null;
                        mobileError = null;
                        emailError = null;

                        if (name.isEmpty) {
                          nameError = 'Please enter Customer Name';
                        }
                        
                        if (mobile.isEmpty || mobile.length != 10 || int.tryParse(mobile) == null) {
                          mobileError = 'Please enter a valid 10-digit Mobile Number';
                        }

                        if (email.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
                          emailError = 'Please enter a valid Email ID';
                        }
                      });

                      if (nameError != null || mobileError != null || emailError != null) {
                        return;
                      }

                      final customerData = {
                        'phone': mobile,
                        'name': name,
                        'email': email,
                        'dob': dobController.text.trim(),
                        'anniversary': anniversaryController.text.trim(),
                      };
                      
                      Fluttertoast.showToast(
                        msg: widget.customer != null ? "Customer updated successfully" : "Customer created successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: const Color(0xFFC4C4C4),
                        textColor: Colors.black87,
                        fontSize: 16.0,
                      );
                      
                      Navigator.pop(context, customerData);
                    },
                    child: Text(
                      widget.customer != null ? 'Edit' : 'SAVE',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
