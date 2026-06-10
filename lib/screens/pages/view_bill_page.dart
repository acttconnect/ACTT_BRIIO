import 'package:briio_application/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'dart:io';
import '../../utils/globel_veriable.dart';
import 'choose_plan_page.dart';

class ViewBillPage extends StatefulWidget {
  final Map<String, dynamic>? membershipData;
  const ViewBillPage({super.key, this.membershipData});

  @override
  State<ViewBillPage> createState() => _ViewBillPageState();
}

class _ViewBillPageState extends State<ViewBillPage> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isCapturing = false;

  Widget _buildTableCell(String text, {bool isHeader = false, bool isBold = false, TextAlign align = TextAlign.left}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          color: Colors.black87,
          fontSize: isHeader ? 10 : 12,
          fontWeight: (isHeader || isBold) ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  String _numberToWords(int number) {
    if (number == 0) return 'Zero';
    
    final List<String> units = [
      '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten',
      'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'
    ];
    
    final List<String> tens = [
      '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'
    ];
    
    String words = '';
    
    if ((number / 10000000).floor() > 0) {
      words += '${_numberToWords((number / 10000000).floor())} Crore ';
      number %= 10000000;
    }
    
    if ((number / 100000).floor() > 0) {
      words += '${_numberToWords((number / 100000).floor())} Lakh ';
      number %= 100000;
    }
    
    if ((number / 1000).floor() > 0) {
      words += '${_numberToWords((number / 1000).floor())} Thousand ';
      number %= 1000;
    }
    
    if ((number / 100).floor() > 0) {
      words += '${_numberToWords((number / 100).floor())} Hundred ';
      number %= 100;
    }
    
    if (number > 0) {
      if (number < 20) {
        words += '${units[number]} ';
      } else {
        words += '${tens[(number / 10).floor()]} ';
        if ((number % 10) > 0) {
          words += '${units[number % 10]} ';
        }
      }
    }
    
    return words.trim();
  }

  Widget _buildInvoice({bool isScreenshot = false}) {
    String planName = widget.membershipData?['plan_name']?.toString() ?? '1 Month';
    double totalAmountDouble = double.tryParse(widget.membershipData?['amount']?.toString() ?? '1180') ?? 1180.0;
    int totalAmount = totalAmountDouble.toInt();
    int basePrice = (totalAmount / 1.18).round();
    int gst = totalAmount - basePrice;
    
    String amountInWords = '${_numberToWords(totalAmount)} rupees only';

    // We constrain the width so the screenshot matches typical mobile width and doesn't get messed up.
    return Container(
      width: isScreenshot ? 400 : double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E7E3), // Light beige invoice background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo Placeholder
          Center(
            child: Image.asset(
              'assets/blg.png', 
              height: 40,
              errorBuilder: (context, error, stackTrace) => const Text(
                'BRIIO',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 8.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            '${GlobalK.userFName ?? ''} ${GlobalK.userLName ?? ''}'.trim().isEmpty 
                ? 'User' 
                : '${GlobalK.userFName ?? ''} ${GlobalK.userLName ?? ''}'.trim() + 
                  '\n${GlobalK.phone ?? 'N/A'}\n${GlobalK.userEmail ?? 'N/A'}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          const Center(
            child: Text(
              'INVOICE',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                letterSpacing: 6.0,
                color: Color(0xFFB57D61), 
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Invoice Table Box
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 1),
            ),
            child: Column(
              children: [
                // Top Table (Header + Items)
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(30),
                    1: FlexColumnWidth(20),
                    2: FlexColumnWidth(12), // Extra space to prevent QTY wrap
                    3: FlexColumnWidth(20),
                  },
                  border: const TableBorder(
                    verticalInside: BorderSide(color: Colors.black12, width: 1),
                  ),
                  children: [
                    // Header
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xFFB57D61)),
                      children: [
                        _buildTableCell('DESCRIPTION', isHeader: true),
                        _buildTableCell('PRICE', isHeader: true, align: TextAlign.center),
                        _buildTableCell('QTY.', isHeader: true, align: TextAlign.center),
                        _buildTableCell('AMOUNT', isHeader: true, align: TextAlign.center), // Center amount header
                      ],
                    ),
                    // Data Row (Tall row to center text vertically)
                    TableRow(
                      children: [
                        Container(
                          height: 70, // Tall row to match standard bill design
                          padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
                          alignment: Alignment.topLeft,
                          child: Text(planName, style: const TextStyle(color: Colors.black87, fontSize: 12)),
                        ),
                        Container(
                          height: 70,
                          alignment: Alignment.center,
                          child: Text(basePrice.toString(), style: const TextStyle(color: Colors.black87, fontSize: 12)),
                        ),
                        Container(
                          height: 70,
                          alignment: Alignment.center,
                          child: const Text('1', style: TextStyle(color: Colors.black87, fontSize: 12)),
                        ),
                        Container(
                          height: 70,
                          alignment: Alignment.center,
                          child: Text(basePrice.toString(), style: const TextStyle(color: Colors.black87, fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
                
                // Totals Table (Bottom right)
                Container(
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black12, width: 1)),
                  ),
                  child: Row(
                    children: [
                      const Expanded(flex: 30, child: SizedBox()),
                      Expanded(
                        flex: 52,
                        child: Table(
                          border: const TableBorder(
                            left: BorderSide(color: Colors.black12, width: 1),
                            horizontalInside: BorderSide(color: Colors.black12, width: 1),
                            verticalInside: BorderSide(color: Colors.black12, width: 1),
                          ),
                          columnWidths: const {
                            0: FlexColumnWidth(32),
                            1: FlexColumnWidth(20),
                          },
                          children: [
                            TableRow(
                              children: [
                                _buildTableCell('Total'),
                                _buildTableCell(basePrice.toString(), align: TextAlign.right),
                              ],
                            ),
                            TableRow(
                              decoration: BoxDecoration(color: Colors.black.withOpacity(0.03)),
                              children: [
                                _buildTableCell('GST 18%'),
                                _buildTableCell(gst.toString(), align: TextAlign.right),
                              ],
                            ),
                            TableRow(
                              children: [
                                _buildTableCell('Grand\nTotal', isBold: true),
                                _buildTableCell(totalAmount.toString(), isBold: true, align: TextAlign.right),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          Text(
            'Amount in words : $amountInWords',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          
          if (!isScreenshot)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_isCapturing)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CustomLoading(width: 40, height: 40),
                  )
                else ...[
                  IconButton(
                    icon: const Icon(Icons.ios_share, size: 20, color: Colors.black87),
                    onPressed: _shareBill,
                  ),
                  IconButton(
                    icon: const Icon(Icons.download_outlined, size: 20, color: Colors.black87),
                    onPressed: _downloadBill,
                  ),
                ],
              ],
            ),
          if (isScreenshot) const SizedBox(height: 20),

          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'For Brij Ornaments Pvt Ltd',
              style: TextStyle(
                fontSize: 10,
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Divider(color: Colors.black38),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'BRIJ ORNAMENTS PVT LTD',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Corporate Address : 1/3, Zone 1, MP Nagar, Bhopal, Madhya\nPradesh - 462011 Corporate Identity No:\nU36996MP2020PTC051614 | Telephone Number : 7022131502\nEmail Id : Info@briio.in',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareBill() async {
    setState(() => _isCapturing = true);
    try {
      final image = await _screenshotController.captureFromWidget(
        Material(
          color: Colors.white,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: _buildInvoice(isScreenshot: true),
          ),
        ),
        delay: const Duration(milliseconds: 100),
      );

      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/invoice.png').create();
      await imagePath.writeAsBytes(image);

      await Share.shareXFiles([XFile(imagePath.path)], text: 'My Invoice');
    } catch (e) {
      debugPrint('Error sharing: $e');
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  Future<void> _downloadBill() async {
    setState(() => _isCapturing = true);
    try {
      final image = await _screenshotController.captureFromWidget(
        Material(
          color: Colors.white,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: _buildInvoice(isScreenshot: true),
          ),
        ),
        delay: const Duration(milliseconds: 100),
      );

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/invoice_download.png';
      final file = await File(imagePath).create();
      await file.writeAsBytes(image);

      await Gal.putImage(imagePath);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice saved to gallery!')),
      );
    } catch (e) {
      debugPrint('Error downloading: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save invoice: $e')),
      );
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light background outside invoice
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'VIEW BILL',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Latest Bill',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildInvoice(isScreenshot: false),
            const SizedBox(height: 30),
            const Text(
              'More',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: const Text('All previous bills', style: TextStyle(fontSize: 14)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChoosePlanPage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
