import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:briio_application/screens/pages/greeting_preview_page.dart';

class GreetingImagesPage extends StatefulWidget {
  final String festivalName;
  final List<dynamic> greetings;

  const GreetingImagesPage({super.key, required this.festivalName, required this.greetings});

  @override
  State<GreetingImagesPage> createState() => _GreetingImagesPageState();
}

class _GreetingImagesPageState extends State<GreetingImagesPage> {
  bool isSelectMode = false;
  Set<String> selectedImageUrls = {};
  bool isSharing = false;

  void _shareSelectedImages() async {
    if (selectedImageUrls.isEmpty) return;
    
    setState(() {
      isSharing = true;
    });

    try {
      final urlsToShare = selectedImageUrls.toList();
      
      // Navigate to the preview page and pass the selected URLs
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GreetingPreviewPage(
            imageUrls: urlsToShare,
            title: widget.festivalName,
          ),
        ),
      );

      setState(() {
        isSelectMode = false;
        selectedImageUrls.clear();
      });
    } catch (e) {
      debugPrint('Error preparing share: $e');
    } finally {
      setState(() {
        isSharing = false;
      });
    }
  }

  void _shareImagesDirectly() async {
    if (selectedImageUrls.isEmpty) return;
    
    setState(() {
      isSharing = true;
    });

    try {
      List<XFile> filesToShare = [];
      for (String url in selectedImageUrls) {
        final file = await DefaultCacheManager().getSingleFile(url);
        filesToShare.add(XFile(file.path));
      }

      if (filesToShare.isNotEmpty) {
        await Share.shareXFiles(filesToShare, text: 'Check out this greeting for ${widget.festivalName}!');
        
        setState(() {
          isSelectMode = false;
          selectedImageUrls.clear();
        });
      }
    } catch (e) {
      debugPrint('Error sharing directly: $e');
    } finally {
      setState(() {
        isSharing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFCFCFCF); // Match the light grey background
    const textColor = Color(0xFF333333);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.festivalName.toUpperCase(),
          style: const TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          if (widget.greetings.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  isSelectMode = !isSelectMode;
                  if (!isSelectMode) {
                    selectedImageUrls.clear();
                  }
                });
              },
              child: Text(
                isSelectMode ? 'Cancel' : 'Select',
                style: const TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
      body: widget.greetings.isEmpty
          ? Center(
              child: Text(
                "No greetings available",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: widget.greetings.length,
              itemBuilder: (context, index) {
                final greeting = widget.greetings[index];
                final imageUrl = greeting['image_url'] ?? '';
                final isSelected = selectedImageUrls.contains(imageUrl);

                return GestureDetector(
                  onTap: () {
                    if (isSelectMode) {
                      setState(() {
                        if (isSelected) {
                          selectedImageUrls.remove(imageUrl);
                        } else {
                          selectedImageUrls.add(imageUrl);
                        }
                      });
                    } else {
                      // Optional: preview image logic here if not in select mode
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: textColor.withOpacity(0.5))),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                        if (isSelectMode)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: isSelected
                                ? const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.white,
                                    size: 28,
                                  )
                                : Container(
                                    width: 24,
                                    height: 24,
                                    margin: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2.5),
                                      color: Colors.black26, // Semi-transparent inner
                                    ),
                                  ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: (isSelectMode && selectedImageUrls.isNotEmpty)
          ? FloatingActionButton(
              onPressed: _shareSelectedImages,
              backgroundColor: const Color(0xFF2DDA6E), // Green color matching screenshot
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.share, color: Colors.white),
            )
          : null,
    );
  }

}
