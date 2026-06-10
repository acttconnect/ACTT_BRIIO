import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:briio_application/widgets/custom_loading.dart';
import 'package:flutter/services.dart' show rootBundle;

class GreetingPreviewPage extends StatefulWidget {
  final List<String> imageUrls;
  final String title;

  const GreetingPreviewPage({super.key, required this.imageUrls, required this.title});

  @override
  State<GreetingPreviewPage> createState() => _GreetingPreviewPageState();
}

class _GreetingPreviewPageState extends State<GreetingPreviewPage> {
  String _logoPosition = 'Top Left';
  List<Uint8List> _imageBytesList = [];
  Uint8List? _logoBytes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResources();
  }

  Future<void> _loadResources() async {
    try {
      // Load company logo from assets
      final ByteData data = await rootBundle.load('assets/logo_transparent.png');
      _logoBytes = data.buffer.asUint8List();

      // Load all selected images
      for (String url in widget.imageUrls) {
        final file = await DefaultCacheManager().getSingleFile(url);
        final bytes = await file.readAsBytes();
        _imageBytesList.add(bytes);
      }
    } catch (e) {
      debugPrint('Error loading resources for greeting preview: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  pw.Alignment _getPdfAlignment() {
    switch (_logoPosition) {
      case 'Top Right':
        return pw.Alignment.topRight;
      case 'Bottom Left':
        return pw.Alignment.bottomLeft;
      case 'Bottom Right':
        return pw.Alignment.bottomRight;
      case 'Top Left':
      default:
        return pw.Alignment.topLeft;
    }
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    for (var imageBytes in _imageBytesList) {
      final image = pw.MemoryImage(imageBytes);
      final logo = _logoBytes != null ? pw.MemoryImage(_logoBytes!) : null;

      pdf.addPage(
        pw.Page(
          pageFormat: format,
          margin: const pw.EdgeInsets.all(0), // Full bleed
          build: (pw.Context context) {
            return pw.Stack(
              fit: pw.StackFit.expand,
              children: [
                // Background Image
                pw.Image(image, fit: pw.BoxFit.cover),
                
                // Overlay Logo
                if (logo != null)
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(24.0), // Padding from edges
                    child: pw.Align(
                      alignment: _getPdfAlignment(),
                      child: pw.Container(
                        height: 80, // Size of logo
                        child: pw.Image(logo, fit: pw.BoxFit.contain),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  Widget _buildPositionButton(String position) {
    final isSelected = _logoPosition == position;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(
          position,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedColor: Colors.grey.shade800,
        backgroundColor: Colors.grey.shade200,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _logoPosition = position;
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        title: const Text('Preview PDF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CustomLoading(width: 40, height: 40))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Logo Position:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildPositionButton('Top Left'),
                            _buildPositionButton('Top Right'),
                            _buildPositionButton('Bottom Left'),
                            _buildPositionButton('Bottom Right'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PdfPreview(
                    build: (format) => _generatePdf(format),
                    allowSharing: false, // Disabled default share to use custom button below
                    allowPrinting: true,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                    canDebug: false,
                    pdfFileName: '${widget.title}_Greetings.pdf',
                    initialPageFormat: PdfPageFormat.a4,
                  ),
                ),
              ],
            ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final bytes = await _generatePdf(PdfPageFormat.a4);
                      final dir = await getTemporaryDirectory();
                      final file = File('${dir.path}/${widget.title}_Greetings.pdf');
                      await file.writeAsBytes(bytes);
                      await Share.shareXFiles([XFile(file.path)], text: 'Check out these greetings!');
                    } catch (e) {
                      debugPrint('Error sharing: $e');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.share, color: Colors.white, size: 20),
                  label: const Text('Share PDF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
