import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomPdfPreviewScreen extends StatefulWidget {
  final Future<Uint8List> Function(PdfPageFormat) buildPdf;
  final String title;
  final String pdfFileName;
  final String? customerPhone;

  const CustomPdfPreviewScreen({
    super.key,
    required this.buildPdf,
    required this.title,
    required this.pdfFileName,
    this.customerPhone,
  });

  @override
  State<CustomPdfPreviewScreen> createState() => _CustomPdfPreviewScreenState();
}

class _CustomPdfPreviewScreenState extends State<CustomPdfPreviewScreen> {
  bool isSharing = false;

  Future<void> _shareToWhatsApp() async {
    setState(() {
      isSharing = true;
    });

    try {
      final bytes = await widget.buildPdf(PdfPageFormat.a4);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${widget.pdfFileName}');
      await file.writeAsBytes(bytes);

      // Using Share.shareXFiles to let user select WhatsApp.
      if (widget.customerPhone != null && widget.customerPhone!.isNotEmpty) {
        await Clipboard.setData(ClipboardData(text: widget.customerPhone!));
      }

      final xfile = XFile(file.path, mimeType: 'application/pdf');
      await Share.shareXFiles([xfile], text: 'Check out these products!');
    } catch (e) {
      debugPrint("Sharing error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share PDF: $e')),
      );
    } finally {
      setState(() {
        isSharing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PdfPreview(
              build: widget.buildPdf,
              allowSharing: false,
              allowPrinting: false,
              canChangeOrientation: false,
              canChangePageFormat: false,
              canDebug: false,
              useActions: false, // Hide default toolbar
              scrollViewDecoration: BoxDecoration(
                color: Colors.grey.shade300,
              ),
              pdfFileName: widget.pdfFileName,
            ),
          ),
          Container(
            color: const Color(0xFF4A4543), // Dark brownish grey from the image
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      // Optional copy action
                      if (widget.customerPhone != null && widget.customerPhone!.isNotEmpty) {
                        Clipboard.setData(ClipboardData(text: widget.customerPhone!));
                      }
                    },
                    icon: const Icon(Icons.content_copy, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: isSharing ? null : _shareToWhatsApp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50), // WhatsApp green
                      foregroundColor: const Color(0xFF1E3A8A), // Dark blue text from image
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: isSharing 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 24),
                    label: const Text(
                      'Send to WhatsApp',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF283593)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
