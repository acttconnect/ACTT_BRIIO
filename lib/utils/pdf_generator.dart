import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:briio_application/utils/const.dart';
import 'package:briio_application/model/new_search_models.dart' as search_model;
import 'package:briio_application/model/get_category_id_by_product_model.dart' as product_model;

class PdfGenerator {
  /// Accepts a list of either `Product` (from categories) or `Data` (from search page)
  static Future<void> generateAndShowPdf(BuildContext context, List<dynamic> selectedProducts, String title) async {
    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(child: CircularProgressIndicator(color: Colors.red)),
    );

    try {
      // Start fetching fonts concurrently
      final fontFuture = PdfGoogleFonts.robotoRegular();
      final fontBoldFuture = PdfGoogleFonts.robotoBold();

      // Map the dynamic products to a unified structure
      final List<Map<String, dynamic>> items = selectedProducts.map((p) {
        if (p is product_model.Product) {
          return <String, dynamic>{
            'name': p.name ?? 'Unknown',
            'gw': p.gw?.toString() ?? '-',
            'image': p.image ?? '',
          };
        } else if (p is search_model.Data) {
          return <String, dynamic>{
            'name': p.name ?? 'Unknown',
            'gw': p.gw?.toString() ?? '-',
            'image': p.image ?? '',
          };
        }
        return <String, dynamic>{
          'name': 'Unknown',
          'gw': '-',
          'image': '',
        };
      }).toList();

      // Start fetching network images concurrently
      final imageFutures = items.map((item) async {
        String img = item['image'];
        String url = img.startsWith('http') ? img : "${imgPath}products/$img";
        url = url.replaceAll(' ', '%20');
        try {
          return await networkImage(url);
        } catch (e) {
          return null; // Return null if the image fails to load
        }
      }).toList();

      // Wait for fonts and all images to finish downloading
      final results = await Future.wait([
        fontFuture,
        fontBoldFuture,
        ...imageFutures,
      ]);
      
      final baseFont = results[0] as pw.Font;
      final boldFont = results[1] as pw.Font;
      
      // Assign the downloaded images back to the items array sequentially
      for (int i = 0; i < items.length; i++) {
        items[i]['memoryImage'] = results[i + 2];
      }

      final pdf = pw.Document(
        theme: pw.ThemeData.withFont(
          base: baseFont,
          bold: boldFont,
        ),
      );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('BRIIO', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.brown800)),
                  pw.Text('Selected Products ($title)', style: const pw.TextStyle(fontSize: 16)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Wrap(
              spacing: 15,
              runSpacing: 15,
              children: items.map((item) {
                return pw.Container(
                  width: 150,
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      item['memoryImage'] != null
                          ? pw.Container(
                              height: 100,
                              width: double.infinity,
                              child: pw.Image(item['memoryImage'], fit: pw.BoxFit.contain),
                            )
                          : pw.Container(
                              height: 100,
                              width: double.infinity,
                              color: PdfColors.grey200,
                              alignment: pw.Alignment.center,
                              child: pw.Text('No Image', style: const pw.TextStyle(color: PdfColors.grey600)),
                            ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        item['name'],
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
                        maxLines: 1,
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Gross Wt: ${item['gw']}g',
                        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ];
        },
      ),
    );

      // Hide the loading dialog
      Navigator.pop(context);

      // Show preview and allow sharing
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'Briio_Products_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      // Make sure to hide the loading dialog if an error occurs
      Navigator.pop(context);
      debugPrint("Error generating PDF: $e");
    }
  }
}
