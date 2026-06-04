import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../classes/design_upload.dart';
import '../../widgets/custom_loading.dart';

class UploadImageD extends StatefulWidget {
  const UploadImageD({super.key});

  @override
  State<UploadImageD> createState() => _UploadImageDState();
}

class _UploadImageDState extends State<UploadImageD> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  TextEditingController gramController = TextEditingController();
  TextEditingController produtDesecController = TextEditingController();
  List<XFile> images = [];
  bool _isLoading = true;
  final _picker = ImagePicker();

  List<String> categories = [];
  List<String> bangleSizes = [];
  List<String> goldPurity = [];

  String? selectedCategory;
  String? selectedBangleSize;
  String? selectedGoldPurity;

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  Future<void> _fetchDropdownData() async {
    // Soft coded API fetch
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        categories = ['Rings', 'Necklaces', 'Bracelets', 'Earrings', 'Bangles'];
        bangleSizes = ['2/2', '2/4', '2/6', '2/8', '2/10', '2/12'];
        goldPurity = ['14K', '18K', '22K', '24K'];
        _isLoading = false;
      });
    }
  }

  Future<void> pickMultipleImages() async {
    final List<XFile> selectedImages = await _picker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      setState(() {
        images = selectedImages;
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        images.add(photo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color labelColor = Color(0xFF6B625B); // Dark brown-grey from image
    const Color fieldBgColor = Color(0xFFEEEEEE); // Light grey fill
    const Color hintColor = Color(0xFF9E9E9E);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: labelColor),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'CUSTOM ORDER',
          style: TextStyle(
            color: labelColor,
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: CustomLoading(width: 80, height: 80),
              ),
            )
          : Form(
              key: globalKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Picker Section
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _showImagePickerOptions();
                        },
                        child: images.isEmpty
                            ? Column(
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 60,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Select Image',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: images.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == images.length) {
                                      return GestureDetector(
                                        onTap: _showImagePickerOptions,
                                        child: Container(
                                          width: 100,
                                          margin: const EdgeInsets.symmetric(horizontal: 4),
                                          decoration: BoxDecoration(
                                            color: fieldBgColor,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.add, color: labelColor, size: 30),
                                          ),
                                        ),
                                      );
                                    }
                                    return Stack(
                                      children: [
                                        Container(
                                          width: 100,
                                          margin: const EdgeInsets.symmetric(horizontal: 4),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            image: DecorationImage(
                                              image: FileImage(File(images[index].path)),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: -4,
                                          right: -4,
                                          child: IconButton(
                                            icon: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Icons.close, color: Colors.red, size: 16),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                images.removeAt(index);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // CATEGORY
                    _buildLabel('CATEGORY', labelColor),
                    _buildDropdown(
                      value: selectedCategory,
                      items: categories,
                      hint: 'Select',
                      bgColor: fieldBgColor,
                      hintColor: hintColor,
                      onChanged: (val) {
                        setState(() {
                          selectedCategory = val;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // SIZE
                    _buildLabel('SIZE', labelColor),
                    _buildDropdown(
                      value: selectedBangleSize,
                      items: bangleSizes,
                      hint: 'Select',
                      bgColor: fieldBgColor,
                      hintColor: hintColor,
                      onChanged: (val) {
                        setState(() {
                          selectedBangleSize = val;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // GOLD PURITY
                    _buildLabel('GOLD PURITY', labelColor),
                    _buildDropdown(
                      value: selectedGoldPurity,
                      items: goldPurity,
                      hint: 'Select',
                      bgColor: fieldBgColor,
                      hintColor: hintColor,
                      onChanged: (val) {
                        setState(() {
                          selectedGoldPurity = val;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // WEIGHT
                    _buildLabel('WEIGHT', labelColor),
                    _buildTextField(
                      controller: gramController,
                      hint: 'Type here',
                      bgColor: fieldBgColor,
                      hintColor: hintColor,
                      isNumber: true,
                    ),
                    const SizedBox(height: 20),

                    // INSTRUCTION
                    _buildLabel('ADD INSTRUCTION (OPTIONAL)', labelColor),
                    _buildMultiLineTextField(
                      controller: produtDesecController,
                      hint: 'Type here',
                      hintColor: hintColor,
                    ),
                    const SizedBox(height: 30),

                    // ORDER BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          if (images.isEmpty) {
                            Fluttertoast.showToast(msg: 'Please select an image');
                          } else if (selectedCategory == null ||
                              selectedBangleSize == null ||
                              selectedGoldPurity == null ||
                              gramController.text.isEmpty) {
                            Fluttertoast.showToast(msg: 'Please fill in all required details');
                          } else {
                            _uploadImage(
                              allImage: images,
                              gram: gramController.text,
                              descp: produtDesecController.text.isEmpty ? " " : produtDesecController.text,
                              carat: selectedGoldPurity!,
                              bangleSize: selectedBangleSize!,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: labelColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'ORDER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // WhatsApp functionality
        },
        backgroundColor: const Color(0xFF25D366), // WhatsApp Green
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(
          FontAwesomeIcons.whatsapp,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  void _showImagePickerOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  pickMultipleImages();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required Color bgColor,
    required Color hintColor,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: 200, // Matching the width from the image which is not full width
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint, style: TextStyle(color: hintColor, fontSize: 14)),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          dropdownColor: Colors.white,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required Color bgColor,
    required Color hintColor,
    required bool isNumber,
  }) {
    return Container(
      width: 200, // Matching the width from the image
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: hintColor, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildMultiLineTextField({
    required TextEditingController controller,
    required String hint,
    required Color hintColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: hintColor, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }

  void _uploadImage({
    required List<XFile> allImage,
    required String gram,
    required String descp,
    required String carat,
    required String bangleSize,
  }) async {
    await UploadDesingImageUser.getUploadDesign(
      images: allImage,
      gram: gram,
      descp: descp,
      carat: carat,
      bangleSize: bangleSize,
    ).then((value) {
      if (mounted) {
        setState(() {
          selectedCategory = null;
          selectedBangleSize = null;
          selectedGoldPurity = null;
          gramController.clear();
          produtDesecController.clear();
          images = [];
        });
      }
    });
  }
}
