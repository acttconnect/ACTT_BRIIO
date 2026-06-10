import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:briio_application/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:briio_application/utils/const.dart';
import 'package:briio_application/model/new_search_models.dart' as search_model;
import 'package:briio_application/model/get_category_id_by_product_model.dart' as product_model;
import 'package:briio_application/model/get_new_wishlist_product_model.dart' as wishlist_model;
import 'package:briio_application/screens/pages/categories/custom_pdf_preview_screen.dart';
import 'package:briio_application/screens/pages/customer_list.dart';
import 'package:briio_application/screens/pages/customer_info_screen.dart';

class PdfGenerator {
  static const String _flowerSvg = '''
  <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
    <path fill="#F5F5F5" d="M50 20 C60 20 60 50 50 50 C40 50 40 20 50 20 Z" />
    <path fill="#F5F5F5" d="M50 80 C60 80 60 50 50 50 C40 50 40 80 50 80 Z" />
    <path fill="#F5F5F5" d="M20 50 C20 40 50 40 50 50 C50 60 20 60 20 50 Z" />
    <path fill="#F5F5F5" d="M80 50 C80 40 50 40 50 50 C50 60 80 60 80 50 Z" />
    <path fill="#F5F5F5" d="M28 28 C35 21 50 50 50 50 C50 50 21 35 28 28 Z" />
    <path fill="#F5F5F5" d="M72 72 C65 79 50 50 50 50 C50 50 79 65 72 72 Z" />
    <path fill="#F5F5F5" d="M28 72 C21 65 50 50 50 50 C50 50 35 79 28 72 Z" />
    <path fill="#F5F5F5" d="M72 28 C79 35 50 50 50 50 C50 50 65 21 72 28 Z" />
    <circle cx="50" cy="50" r="5" fill="#F5F5F5" />
  </svg>
  ''';

  static const String _waveSvg = '''
  <svg viewBox="0 0 200 100" xmlns="http://www.w3.org/2000/svg">
    <path fill="none" stroke="#F4E8CD" stroke-width="1.5" d="M0 20 Q50 0 100 20 T200 20" />
    <path fill="none" stroke="#F4E8CD" stroke-width="1.5" d="M0 30 Q50 10 100 30 T200 30" />
    <path fill="none" stroke="#F4E8CD" stroke-width="1.5" d="M0 40 Q50 20 100 40 T200 40" />
    <path fill="none" stroke="#F4E8CD" stroke-width="1.5" d="M0 50 Q50 30 100 50 T200 50" />
  </svg>
  ''';

  static void showShareBottomSheet(BuildContext parentContext, List<dynamic> selectedItems, String title) {
    showModalBottomSheet(
      context: parentContext,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        bool isGenerating = false;
        
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isGenerating) ...[
                    const LinearProgressIndicator(color: Color(0xFFC0704E)),
                    const SizedBox(height: 10),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (isGenerating) return;
                          setModalState(() => isGenerating = true);
                          await PdfGenerator.generateAndShowPdf(parentContext, selectedItems, title, showLoadingDialog: false);
                          if (bottomSheetContext.mounted) {
                            setModalState(() => isGenerating = false);
                            Navigator.pop(bottomSheetContext);
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.picture_as_pdf, color: Color(0xFFC0704E), size: 28),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: MediaQuery.of(bottomSheetContext).size.width * 0.5,
                              child: Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.ios_share, color: Colors.black87),
                            onPressed: () async {
                              Navigator.pop(bottomSheetContext);
                              final selectedCustomer = await Navigator.push(
                                parentContext,
                                MaterialPageRoute(
                                  builder: (context) => const CustomerListScreen(isSelectionMode: true),
                                ),
                              );
                              if (selectedCustomer != null && selectedCustomer is Map<String, dynamic>) {
                                if (parentContext.mounted) {
                                  await PdfGenerator.generateCustomPdf(parentContext, selectedItems, title, selectedCustomer);
                                }
                              }
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black45),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                              icon: const Icon(Icons.close, color: Colors.black87, size: 20),
                              onPressed: () => Navigator.pop(bottomSheetContext),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      Navigator.pop(bottomSheetContext);
                      Navigator.push(parentContext, MaterialPageRoute(builder: (context) => const CustomerInfoScreen()));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black87, width: 1.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Create New Customer', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87)),
                          Icon(Icons.chevron_right, color: Colors.black87),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          }
        );
      },
    );
  }

  static Future<pw.Document> _buildBeautifulPdf({
    required List<Map<String, dynamic>> items,
    required String title,
    required pw.Font serifFont,
    required pw.Font serifBold,
    required pw.Font sansFont,
    required pw.Font sansBold,
    required pw.Font iconFont,
    pw.MemoryImage? brandLogo,
    pw.MemoryImage? catalogCoverImage,
  }) async {
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: sansFont,
        bold: sansBold,
        icons: iconFont,
      ),
    );

    final maroon = PdfColor.fromHex('#A04A4A');
    final gold = PdfColor.fromHex('#D4AF37');
    final gold50 = PdfColor(gold.red, gold.green, gold.blue, 0.5);
    final cardBg = PdfColor.fromHex('#FCF8EF');
    final pageBg = PdfColor.fromHex('#FFFDF9'); // Warm white background for all pages
    final textBlack = PdfColor.fromHex('#222222');
    final textGrey = PdfColor.fromHex('#555555');
    final footerTextMuted = PdfColor.fromHex('#A06565');
    final footerBarBg = PdfColor.fromHex('#F4E8CD');

    // 1. Cover Page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Container(
            color: pageBg,
            width: double.infinity,
            height: double.infinity,
            child: pw.Stack(
              children: [
                pw.Positioned(
                  top: -100,
                  left: -150,
                  child: pw.Opacity(opacity: 0.3, child: pw.Container(width: 500, child: pw.SvgImage(svg: _waveSvg))),
                ),
                pw.Positioned(
                  bottom: -100,
                  right: -150,
                  child: pw.Opacity(opacity: 0.3, child: pw.Container(width: 500, child: pw.SvgImage(svg: _waveSvg))),
                ),
                pw.Positioned(
                  top: 20,
                  right: 20,
                  child: pw.Opacity(
                    opacity: 0.2,
                    child: pw.Column(
                      children: List.generate(8, (i) => pw.Row(
                        children: List.generate(8, (j) => pw.Container(
                          width: 2, height: 2, margin: const pw.EdgeInsets.all(3),
                          decoration: pw.BoxDecoration(shape: pw.BoxShape.circle, color: maroon)
                        ))
                      ))
                    )
                  )
                ),

                pw.Positioned.fill(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.SizedBox(height: 80),
                      pw.Column(
                        children: [
                          pw.Text('BRIIO', style: pw.TextStyle(font: serifBold, color: maroon, fontSize: 34, letterSpacing: 2.0)),
                          pw.SizedBox(height: 4),
                          pw.Text('jewellery collection', style: pw.TextStyle(font: serifFont, color: gold, fontSize: 18)),
                          pw.SizedBox(height: 12),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Container(width: 80, height: 1, color: gold50),
                              pw.SizedBox(width: 8),
                              pw.Transform.rotate(angle: 3.14159 / 4, child: pw.Container(width: 4, height: 4, color: gold50)),
                              pw.SizedBox(width: 4),
                              pw.Transform.rotate(angle: 3.14159 / 4, child: pw.Container(width: 6, height: 6, color: gold)),
                              pw.SizedBox(width: 4),
                              pw.Transform.rotate(angle: 3.14159 / 4, child: pw.Container(width: 4, height: 4, color: gold50)),
                              pw.SizedBox(width: 8),
                              pw.Container(width: 80, height: 1, color: gold50),
                            ]
                          ),
                        ]
                      ),
                      pw.Expanded(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
                          child: pw.Center(
                            child: catalogCoverImage != null 
                              ? pw.ClipRRect(
                                  horizontalRadius: 16,
                                  verticalRadius: 16,
                                  child: pw.Image(catalogCoverImage, fit: pw.BoxFit.contain)
                                )
                              : pw.Icon(const pw.IconData(0xe3f4), size: 100, color: PdfColors.grey300, font: iconFont)
                          )
                        )
                      ),
                      pw.Column(
                        children: [
                          pw.Text('Timeless Elegance in Every Design', style: pw.TextStyle(font: sansFont, color: maroon, fontSize: 12, letterSpacing: 1.0)),
                          pw.SizedBox(height: 30),
                          pw.Container(
                            width: double.infinity,
                            margin: const pw.EdgeInsets.symmetric(horizontal: 100),
                            padding: const pw.EdgeInsets.symmetric(vertical: 20),
                            color: maroon,
                            child: pw.Center(
                              child: brandLogo != null
                                ? pw.Container(
                                    height: 40,
                                    child: pw.Image(brandLogo, fit: pw.BoxFit.contain)
                                  )
                                : pw.Column(
                                    children: [
                                      pw.Icon(const pw.IconData(0xe31b), color: PdfColors.white, size: 30, font: iconFont),
                                      pw.SizedBox(height: 6),
                                      pw.Text('BRIIO', style: pw.TextStyle(font: serifBold, color: PdfColors.white, fontSize: 18, letterSpacing: 2.0)),
                                    ]
                                  )
                            )
                          ),
                          pw.SizedBox(height: 60),
                        ]
                      )
                    ]
                  )
                )
              ]
            )
          );
        }
      )
    );

    // 2. Products MultiPage
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          buildBackground: (context) => pw.Container(color: pageBg),
        ),
        header: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.topRight,
            margin: const pw.EdgeInsets.only(bottom: 20),
            child: pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                shape: pw.BoxShape.circle,
                color: PdfColors.white,
                border: pw.Border.all(color: PdfColors.grey200),
                boxShadow: [pw.BoxShadow(color: PdfColors.black, blurRadius: 2, spreadRadius: 0.05, offset: const PdfPoint(0, 1))]
              ),
              child: pw.Text('${context.pageNumber}/${context.pagesCount}', style: pw.TextStyle(color: textGrey, fontSize: 10)),
            ),
          );
        },
        build: (pw.Context context) {
          final List<pw.Widget> widgets = [];
          for (int i = 0; i < items.length; i++) {
            final item = items[i];
            
            final imageWidget = pw.Container(
              height: 100,
              width: 100,
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(12),
              ),
              child: pw.Stack(
                alignment: pw.Alignment.center,
                children: [
                  item['memoryImage'] != null
                      ? pw.ClipRRect(
                          horizontalRadius: 8,
                          verticalRadius: 8,
                          child: pw.Image(item['memoryImage'], fit: pw.BoxFit.contain),
                        )
                      : pw.Center(child: pw.Text('No Image', style: pw.TextStyle(font: sansFont, color: PdfColors.grey400, fontSize: 10))),
                ],
              ),
            );

            widgets.add(
              pw.Container(
                height: 130, // Fits 4 per page nicely
                margin: const pw.EdgeInsets.only(bottom: 24), // Larger gap between cards
                padding: const pw.EdgeInsets.all(14),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#FCF6EB'), // Very soft beige/cream
                  borderRadius: pw.BorderRadius.circular(12),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    imageWidget,
                    pw.SizedBox(width: 20),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            item['code'],
                            style: pw.TextStyle(font: sansFont, fontSize: 13, color: PdfColor.fromHex('#222222')),
                          ),
                          pw.SizedBox(height: 6),
                          pw.Text(
                            item['desc'],
                            style: pw.TextStyle(font: sansFont, fontSize: 9.5, color: PdfColor.fromHex('#444444'), lineSpacing: 1.2),
                            maxLines: 3,
                          ),
                          pw.SizedBox(height: 10),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: pw.BoxDecoration(
                              color: PdfColor.fromHex('#E6C675'), // Muted yellow/gold matching image
                              borderRadius: pw.BorderRadius.circular(16),
                            ),
                            child: pw.Text(
                              'WT-${item['gw']}GM',
                              style: pw.TextStyle(font: sansBold, color: PdfColor.fromHex('#222222'), fontSize: 9)
                            )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            );
          }
          return widgets;
        }
      )
    );

    // 3. Footer Page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Container(
                color: pageBg,
                width: double.infinity,
                height: double.infinity,
              ),
              pw.Positioned(
                top: -100,
                left: -150,
                child: pw.Opacity(opacity: 0.3, child: pw.Container(width: 500, child: pw.SvgImage(svg: _waveSvg))),
              ),
              pw.Positioned(
                top: 20,
                right: 20,
                child: pw.Opacity(
                  opacity: 0.2,
                  child: pw.Column(
                    children: List.generate(8, (i) => pw.Row(
                      children: List.generate(8, (j) => pw.Container(
                        width: 2, height: 2, margin: const pw.EdgeInsets.all(3),
                        decoration: pw.BoxDecoration(shape: pw.BoxShape.circle, color: maroon)
                      ))
                    ))
                  )
                )
              ),

              // Large flower watermark
              pw.Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: pw.Center(
                  child: pw.Opacity(
                    opacity: 0.1,
                    child: pw.Container(
                      width: 400,
                      height: 400,
                      child: pw.SvgImage(svg: _flowerSvg),
                    ),
                  ),
                ),
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Spacer(flex: 2),
                  pw.Text('THANK YOU', style: pw.TextStyle(font: serifBold, color: maroon, fontSize: 28, letterSpacing: 1.5)),
                  pw.SizedBox(height: 40),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 60),
                    child: pw.Text(
                      'The designs showcased in this catalogue highlight our approach to jewellery design, where traditional craftsmanship is thoughtfully blended with refined detailing and contemporary sensibilities. Every piece is carefully conceptualized to inspire creativity and support custom jewellery creation, offering endless possibilities for personalization. Our collection reflects a deep appreciation for artistry, precision, and timeless elegance. Stay connected with us to explore many more exclusive, innovative, and uniquely crafted designs as we continue to evolve and bring new inspirations to life.',
                      textAlign: pw.TextAlign.justify,
                      style: pw.TextStyle(font: sansFont, color: PdfColor.fromHex('#A6866A'), fontSize: 11, lineSpacing: 2.0, letterSpacing: 0.5),
                    ),
                  ),
                  pw.Spacer(flex: 3),
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    color: footerBarBg,
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(6),
                          decoration: pw.BoxDecoration(shape: pw.BoxShape.circle, color: PdfColor.fromHex('#E6C675'), border: pw.Border.all(color: PdfColors.white, width: 2)),
                          child: pw.Icon(const pw.IconData(0xe0cd), color: PdfColors.white, size: 14, font: iconFont),
                        ),
                        pw.SizedBox(width: 10),
                        pw.Text(
                          '+919425886678,9425668753',
                          style: pw.TextStyle(font: sansBold, color: footerTextMuted, fontSize: 11),
                        ),
                        pw.SizedBox(width: 40),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(6),
                          decoration: pw.BoxDecoration(shape: pw.BoxShape.circle, color: PdfColor.fromHex('#E6C675'), border: pw.Border.all(color: PdfColors.white, width: 2)),
                          child: pw.Icon(const pw.IconData(0xe0c8), color: PdfColors.white, size: 14, font: iconFont),
                        ),
                        pw.SizedBox(width: 10),
                        pw.Expanded(
                          child: pw.Text(
                            'D.N.R 90 Yeshwant Niwas Road near Rajani\nBhawan, Lad Colony, Indore, (M.P.)',
                            style: pw.TextStyle(font: sansFont, color: footerTextMuted, fontSize: 10, lineSpacing: 1.2),
                          ),
                        ),
                      ]
                    )
                  )
                ]
              )
            ]
          );
        }
      )
    );

    return pdf;
  }

  static Future<void> generateAndShowPdf(BuildContext context, List<dynamic> selectedProducts, String title, {bool showLoadingDialog = true}) async {
    if (showLoadingDialog) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) => const Center(child: CustomLoading(width: 40, height: 40)),
      );
    }

    try {
      final serifFontFuture = PdfGoogleFonts.playfairDisplayRegular();
      final serifBoldFuture = PdfGoogleFonts.playfairDisplayBold();
      final sansFontFuture = PdfGoogleFonts.montserratRegular();
      final sansBoldFuture = PdfGoogleFonts.montserratBold();
      final iconFontFuture = PdfGoogleFonts.materialIconsRegular();

      final List<Map<String, dynamic>> items = selectedProducts.map((p) {
        String name = 'Unknown';
        String gw = '-';
        String image = '';
        String code = 'Unknown';
        String desc = "Crafted with precision, this gold bangle reflects Kolkata's rich heritage, offering a perfect blend of elegance and tradition.";
        
        if (p is product_model.Product) {
          name = p.name ?? 'Unknown';
          gw = p.gw?.toString() ?? '-';
          image = p.image ?? '';
          code = p.productCode ?? name;
          desc = p.shortDesc ?? desc;
        } else if (p is search_model.Data) {
          name = p.name ?? 'Unknown';
          gw = p.gw?.toString() ?? '-';
          image = p.image ?? '';
          code = p.productCode ?? name;
          desc = p.shortDesc ?? desc;
        } else if (p is wishlist_model.Product) {
          name = p.name ?? 'Unknown';
          gw = p.gw?.toString() ?? '-';
          image = p.image ?? '';
          code = p.productCode ?? name;
          desc = p.shortDesc ?? desc;
        }
        
        return <String, dynamic>{
          'name': name,
          'gw': gw,
          'image': image,
          'code': code,
          'desc': desc
        };
      }).toList();

      final imageFutures = items.map((item) async {
        String img = item['image'];
        String url = img.startsWith('http') ? img : "${imgPath}products/$img";
        url = url.replaceAll(' ', '%20');
        try {
          return await networkImage(url);
        } catch (e) {
          return null;
        }
      }).toList();

      final results = await Future.wait([
        serifFontFuture,
        serifBoldFuture,
        sansFontFuture,
        sansBoldFuture,
        iconFontFuture,
        ...imageFutures,
      ]);
      
      final serifFont = results[0] as pw.Font;
      final serifBold = results[1] as pw.Font;
      final sansFont = results[2] as pw.Font;
      final sansBold = results[3] as pw.Font;
      final iconFont = results[4] as pw.Font;
      
      for (int i = 0; i < items.length; i++) {
        items[i]['memoryImage'] = results[i + 5];
      }

      pw.MemoryImage? brandLogo;
      try {
        final ByteData data = await rootBundle.load('assets/blg.png');
        brandLogo = pw.MemoryImage(data.buffer.asUint8List());
      } catch (e) {
        debugPrint("Could not load logo: $e");
      }

      pw.MemoryImage? catalogCoverImage;
      try {
        final ByteData data = await rootBundle.load('assets/jewellery.png');
        catalogCoverImage = pw.MemoryImage(data.buffer.asUint8List());
      } catch (e) {
        debugPrint("Could not load cover image: $e");
      }

      final pdf = await _buildBeautifulPdf(
        items: items,
        title: title,
        serifFont: serifFont,
        serifBold: serifBold,
        sansFont: sansFont,
        sansBold: sansBold,
        iconFont: iconFont,
        brandLogo: brandLogo,
        catalogCoverImage: catalogCoverImage,
      );

      if (showLoadingDialog) {
        Navigator.pop(context);
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 1,
              title: const Text('Preview', style: TextStyle(fontWeight: FontWeight.bold)),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: PdfPreview(
              build: (format) async => pdf.save(),
              allowSharing: true,
              allowPrinting: true,
              canChangeOrientation: false,
              canChangePageFormat: false,
              canDebug: false,
              pdfFileName: 'Briio_Products_${DateTime.now().millisecondsSinceEpoch}.pdf',
            ),
          ),
        ),
      );
    } catch (e) {
      if (showLoadingDialog) {
        Navigator.pop(context);
      }
      debugPrint("Error generating PDF: $e");
    }
  }

  static Future<void> generateCustomPdf(BuildContext context, List<dynamic> selectedProducts, String title, Map<String, dynamic> customer) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(child: CustomLoading(width: 40, height: 40)),
    );

    try {
      final serifFontFuture = PdfGoogleFonts.playfairDisplayRegular();
      final serifBoldFuture = PdfGoogleFonts.playfairDisplayBold();
      final sansFontFuture = PdfGoogleFonts.montserratRegular();
      final sansBoldFuture = PdfGoogleFonts.montserratBold();
      final iconFontFuture = PdfGoogleFonts.materialIconsRegular();

      final List<Map<String, dynamic>> items = selectedProducts.map((p) {
        String name = 'Unknown';
        String gw = '-';
        String image = '';
        String code = 'Unknown';
        String desc = "Crafted with precision, this gold bangle reflects Kolkata's rich heritage, offering a perfect blend of elegance and tradition.";
        
        if (p is product_model.Product) {
          name = p.name ?? 'Unknown';
          gw = p.gw?.toString() ?? '-';
          image = p.image ?? '';
          code = p.productCode ?? name;
          desc = p.shortDesc ?? desc;
        } else if (p is search_model.Data) {
          name = p.name ?? 'Unknown';
          gw = p.gw?.toString() ?? '-';
          image = p.image ?? '';
          code = p.productCode ?? name;
          desc = p.shortDesc ?? desc;
        } else if (p is wishlist_model.Product) {
          name = p.name ?? 'Unknown';
          gw = p.gw?.toString() ?? '-';
          image = p.image ?? '';
          code = p.productCode ?? name;
          desc = p.shortDesc ?? desc;
        }
        
        return <String, dynamic>{
          'name': name,
          'gw': gw,
          'image': image,
          'code': code,
          'desc': desc
        };
      }).toList();

      final imageFutures = items.map((item) async {
        String img = item['image'];
        String url = img.startsWith('http') ? img : "${imgPath}products/$img";
        url = url.replaceAll(' ', '%20');
        try {
          return await networkImage(url);
        } catch (e) {
          return null;
        }
      }).toList();

      final results = await Future.wait([
        serifFontFuture,
        serifBoldFuture,
        sansFontFuture,
        sansBoldFuture,
        iconFontFuture,
        ...imageFutures,
      ]);
      
      final serifFont = results[0] as pw.Font;
      final serifBold = results[1] as pw.Font;
      final sansFont = results[2] as pw.Font;
      final sansBold = results[3] as pw.Font;
      final iconFont = results[4] as pw.Font;
      
      for (int i = 0; i < items.length; i++) {
        items[i]['memoryImage'] = results[i + 5];
      }

      pw.MemoryImage? brandLogo;
      try {
        final ByteData data = await rootBundle.load('assets/blg.png');
        brandLogo = pw.MemoryImage(data.buffer.asUint8List());
      } catch (e) {
        debugPrint("Could not load logo: $e");
      }

      pw.MemoryImage? catalogCoverImage;
      try {
        final ByteData data = await rootBundle.load('assets/jewellery.png');
        catalogCoverImage = pw.MemoryImage(data.buffer.asUint8List());
      } catch (e) {
        debugPrint("Could not load cover image: $e");
      }

      final pdf = await _buildBeautifulPdf(
        items: items,
        title: title,
        serifFont: serifFont,
        serifBold: serifBold,
        sansFont: sansFont,
        sansBold: sansBold,
        iconFont: iconFont,
        brandLogo: brandLogo,
        catalogCoverImage: catalogCoverImage,
      );

      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomPdfPreviewScreen(
            buildPdf: (format) async => pdf.save(),
            title: title,
            pdfFileName: 'Briio_Products_${DateTime.now().millisecondsSinceEpoch}.pdf',
            customerPhone: customer['phone'],
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      debugPrint("Error generating custom PDF: $e");
    }
  }
}
